//
//  NetworkCenter.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NetworkCenter.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "Utility.h"
#import "DataCenter.h"
#import "JSONKit.h"
#import "NETResponse.h"

#import "LoginViewController.h"
//#import "ASIDataCompressor.h"
//#import "ASIDataDecompressor.h"

//static NSString *const baseURL = @"http://inter.clinatech.com/";
//static NSString *const baseURL = @"http://10.10.90.100:82/";
static NSString *const baseURL = @"http://if.yufengyun.com/";


@interface NetworkCenter ()<ASIHTTPRequestDelegate>
@end

@implementation NetworkCenter

+ (id)center {
    static NetworkCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[self alloc] init];});
    return instance;
}


- (BOOL)cancelRequest:(NSString *)requestName
                  tag:(NSString *)tag
             receiver:(id<NetworkCenterDelegate>)receiver {
    for (NSOperation* opration in [ASIHTTPRequest sharedQueue].operations) {
        
        ASIFormDataRequest *asi = (ASIFormDataRequest *)opration;
        id asiReceiver      = [asi.userInfo objectForKey:YFY_NET_REQUEST_RECEIVER];
        NSString *asiCode   = [asi.userInfo objectForKey:YFY_NET_REQUEST_CODE];
        NSString *asiTag    = [asi.userInfo objectForKey:YFY_NET_REQUEST_TAG];
        if (!asiReceiver) return NO;
        DEBUG_LOG_NET(@"tag: %@, reciver class: %@", asiTag, NSStringFromClass([asiReceiver class]));
        
        BOOL tagEqul = (!tag) && (!asiTag);
        if ([asiCode isEqualToString:requestName] &&
            asiReceiver == receiver &&
            ([asiTag isEqualToString:tag] || tagEqul)) {
            [asi clearDelegatesAndCancel];
            return YES;
        }
    }
    return NO;
}


#pragma mark - request
- (void)startRequestWithPort:(NSString *)port
                        code:(NSString *)code
                  parameters:(NSDictionary *)parameters
                         tag:(NSString *)tag
                     reciver:(id <NetworkCenterDelegate>)reciver {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, port];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    __weak id wReciver = reciver;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    if (wReciver)       [userInfo setObject:wReciver forKey:YFY_NET_REQUEST_RECEIVER];
    if (tag.length)     [userInfo setObject:tag forKey:YFY_NET_REQUEST_TAG];
    if (code.length)    [userInfo setObject:code forKey:YFY_NET_REQUEST_CODE];
    if (port.length)    [userInfo setObject:port forKey:YFY_NET_REQUEST_PORT];
    request.userInfo = userInfo;
    
    request.allowCompressedResponse = NO;
//    request.shouldCompressRequestBody = YES;
    request.delegate = self;
    
    NSDictionary *header = [self requestHeader:code];
    NSDictionary *requestDic = [self requsetData:parameters header:header];
    [request addPostValue:[requestDic JSONString] forKey:YFY_NET_PARAM];
    
//    [request addRequestHeader:@"Content-Type" value:@"application/x-gzip"];    
//    [request addRequestHeader:@"Content-Encoding" value:@"gzip"];    
    DEBUG_LOG_NET(@"\n%@\n%@", urlString, requestDic);
    
    [request startAsynchronous];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)uploadImage:(UIImage *)image
            reciver:(id <NetworkCenterDelegate>)reciver {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, YFY_NET_PORT_UPLOAD_IMAGE];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    __weak id wReciver = reciver;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    if (wReciver)       [userInfo setObject:wReciver forKey:YFY_NET_REQUEST_RECEIVER];
    [userInfo setObject:YFY_NET_CODE_UPLOAD_IMAGE forKey:YFY_NET_REQUEST_CODE];
    [userInfo setObject:YFY_NET_PORT_UPLOAD_IMAGE forKey:YFY_NET_REQUEST_PORT];
    request.userInfo = userInfo;
    
    request.allowCompressedResponse = NO;
    request.delegate = self;
    
    NSDictionary *header = [self requestHeader:YFY_NET_CODE_UPLOAD_IMAGE];
    NSDictionary *requestDic = [self requsetData:nil header:header];
    [request addPostValue:[requestDic JSONString] forKey:YFY_NET_PARAM];
    
    NSString *path = [Utility saveImage:image];
    [request addFile:path forKey:@"upload"];
    
    [request startAsynchronous];    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)downloadOfflineWithProgress:(id)progress {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, YFY_NET_PORT_OFF_LINE];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    __weak id wReciver = DATA;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    if (wReciver)       [userInfo setObject:wReciver forKey:YFY_NET_REQUEST_RECEIVER];
    [userInfo setObject:YFY_NET_CODE_OFF_LINE forKey:YFY_NET_REQUEST_CODE];
    [userInfo setObject:YFY_NET_PORT_OFF_LINE forKey:YFY_NET_REQUEST_PORT];
    request.userInfo = userInfo;
    
    request.allowCompressedResponse = NO;
    request.delegate = self;
    request.downloadProgressDelegate = progress;
//    request.downloadDestinationPath = [[Utility cachesPath] stringByAppendingPathComponent:@"offlineCache"];
    
    NSDictionary *header = [self requestHeader:YFY_NET_CODE_OFF_LINE];
    NSDictionary *requestDic = [self requsetData:nil header:header];
    [request addPostValue:[requestDic JSONString] forKey:YFY_NET_PARAM];
    
    DEBUG_LOG_NET(@"\n%@\n%@", urlString, requestDic);
    
    [request startAsynchronous];
}


#pragma mark - ASI delegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    if ([ASIHTTPRequest sharedQueue].operationCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
        
    id<NetworkCenterDelegate> receiver  = [request.userInfo objectForKey:YFY_NET_REQUEST_RECEIVER];
#ifdef DEBUG
    NSString *code                      = [request.userInfo objectForKey:YFY_NET_REQUEST_CODE];
#endif
    NSString *tag                       = [request.userInfo objectForKey:YFY_NET_REQUEST_TAG];
    NSString *port                      = [request.userInfo objectForKey:YFY_NET_REQUEST_PORT];
        
    NSString *jsonString = request.responseString;
//    NSString *jsonString = nil;
//    if ([request isResponseCompressed]) {// 响应是否被gzip压缩过？
//        jsonString = [[NSString alloc] initWithData:request.responseData
//                                           encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//    } else {
//        jsonString = [request responseString];
//    }
    
    NSError *error;
    NSDictionary *responseDic = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionNone error:&error];
//    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:request.responseData
//                                                                options:NSJSONReadingMutableContainers
//                                                                  error:&error];
    
    DEBUG_LOG_NET(@"\nreciver:%@ \ncode:%@\nport:%@ \ntag:%@\n%@, %@\n%@",
                  NSStringFromClass([receiver class]), code, port, tag,
                  [[responseDic objectForKey:@"rspHeader"] objectForKey:@"rspDesc"],
                  [Utility errorDes:[[responseDic objectForKey:@"rspHeader"] objectForKey:@"rspCode"]],
                  responseDic);

    if (error || !responseDic) DEBUG_LOG_NET(@"ERROR!");
    
    NETResponse_Header *resHeader = [[NETResponse_Header alloc] init];
    resHeader.responseDic = [responseDic objectForKey:YFY_NET_RSP_HEADER];
    if ([resHeader.rspCode isEqualToString:YFY_NET_ERROR_CODE_SUCC]) {
        if ([receiver respondsToSelector:@selector(networkDidSuccess:port:tag:)]) {
            [receiver networkDidSuccess:responseDic port:port tag:tag];
        }
    }else {
        if ([receiver respondsToSelector:@selector(networkDidFail:port:tag:)]) {
            [receiver networkDidFail:responseDic port:port tag:tag];
        }
        
        if ([resHeader.rspCode isEqualToString:@"10100003"]) {
            [DATA setIsLogin:NO];
            [LoginViewController login:nil];
        } 
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    if ([ASIHTTPRequest sharedQueue].operationCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    id<NetworkCenterDelegate> receiver  = [request.userInfo objectForKey:YFY_NET_REQUEST_RECEIVER];
//    NSString *code                      = [request.userInfo objectForKey:YFY_NET_REQUEST_CODE];
    NSString *tag                       = [request.userInfo objectForKey:YFY_NET_REQUEST_TAG];
    NSString *port                      = [request.userInfo objectForKey:YFY_NET_REQUEST_PORT];
    
    NSDictionary *errorDes = @{YFY_NET_RSP_DESC: [request.error localizedDescription]};
    
    if ([receiver respondsToSelector:@selector(networkDidFail:port:tag:)]) {
        [receiver networkDidFail:@{YFY_NET_RSP_HEADER: errorDes} port:port tag:tag];
    }
    DEBUG_LOG_FUN;
}


#pragma mark - privata
- (NSString *)requestTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    return [formatter stringFromDate:date];
}
- (NSString *)transactionId:(NSDate *)date {
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *trans = [NSString stringWithFormat:@"%@-%lf", [Utility MACAddr], timeInterval];
    return [Utility MD5:trans];
}
- (NSDictionary *)requestHeader:(NSString *)code {
    NSMutableDictionary *requsetHeader = [NSMutableDictionary dictionaryWithCapacity:4];
    
//    NSAssert(code.length, @"code can't be nil");
    if (code.length) {
        [requsetHeader setObject:code forKey:YFY_NET_REQ_CODE];
    }
    
    NSDate *date = [NSDate date];
    NSString *time = [self requestTime:date];
    [requsetHeader setObject:time forKey:YFY_NET_REQ_TIME];
    
    NSString *trans = [self transactionId:date];
    [requsetHeader setObject:trans forKey:YFY_NET_REQ_TRANSACTION];
    
    NSString *token = [DATA tokenID].length ? [DATA tokenID] : @"0";//@"00fbe80b-08fb-4a2d-8ed9-33ccc78ddfce";
    [requsetHeader setObject:token forKey:YFY_NET_REQ_TOKEN];
    
    return requsetHeader;
}
- (NSDictionary *)requsetData:(NSDictionary *)paramters header:(NSDictionary *)header {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    if (paramters) {
        [dic setObject:paramters forKey:YFY_NET_DATA];
    }
    if (header) {
        [dic setObject:header forKey:YFY_NET_REQ_HEADER];
    }
    return dic;
}

@end









