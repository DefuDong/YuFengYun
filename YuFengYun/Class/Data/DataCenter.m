//
//  DataCenter.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "DataCenter.h"

//user info 
#import "NetworkCenter.h"
#import "NETRequest_UserInfo.h"
#import "NETResponse_Login.h"
#import "NETResponse_UserInfo.h"

#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "NETResponse_PageDetail.h"
#import "NETResponse_Offline.h"
#import "DBManager.h"
#import "SDWebImageManager.h"
#import "Utility.h"


@interface DataCenter ()<NetworkCenterDelegate, ASIHTTPRequestDelegate>
@property (nonatomic, strong, readonly) NSDictionary *htmlDic;
@property (nonatomic, strong, readonly) NSString *htmlSource;
@property (nonatomic, strong, readonly) NSString *htmlTuijian;
@property (nonatomic, strong, readonly) NSString *htmlEnd;
@end

@implementation DataCenter
@synthesize htmlDic = _htmlDic;
- (NSDictionary *)htmlDic {
    if (!_htmlDic) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pageDetailHTML" ofType:@"plist"];
        _htmlDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _htmlDic;
}
@synthesize htmlSource = _htmlSource;
- (NSString *)htmlSource {
    if (!_htmlSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"详细内容" ofType:@"html"];
        _htmlSource = [[NSString alloc] initWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
//        _htmlSource = [self.htmlDic objectForKey:@"head"];
    }
    return _htmlSource;
}
@synthesize htmlTuijian = _htmlTuijian;
- (NSString *)htmlTuijian {
    if (!_htmlTuijian) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"推荐" ofType:@"html"];
        _htmlTuijian = [[NSString alloc] initWithContentsOfFile:path
                                                       encoding:NSUTF8StringEncoding
                                                          error:NULL];
//        _htmlTuijian = [self.htmlDic objectForKey:@"tuijian"];
    }
    return _htmlTuijian;
}
@synthesize htmlEnd = _htmlEnd;
- (NSString *)htmlEnd {
    if (!_htmlEnd) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"结尾" ofType:@"html"];
        _htmlEnd = [[NSString alloc] initWithContentsOfFile:path
                                                       encoding:NSUTF8StringEncoding
                                                          error:NULL];
//        _htmlEnd = [self.htmlDic objectForKey:@"end"];
    }
    return _htmlEnd;
}

@synthesize face_text_image = _face_text_image;
- (NSDictionary *)face_text_image {
    if (!_face_text_image) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"nameMap" ofType:@"plist"];
        _face_text_image = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _face_text_image;
}


+ (id)data {
    static DataCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[self alloc] init];});
    return instance;
}


//- (NSMutableDictionary *)cityDataDic_pinyin {
//    if (!_cityDataDic_pinyin) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
//        _cityDataDic_pinyin = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//    }
//    return _cityDataDic_pinyin;
//}


#pragma mark - page detail
- (NSString *)pageTextSize:(kPageTextSizeType)type {
    switch (type) {
        case kPageTextSizeTypeSmall:
            return @"16";
        case kPageTextSizeTypeMid:
            return @"18";
        case kPageTextSizeTypeLarge:
            return @"20";
    }
}
- (NSString *)pageTextLinePace:(kPageTextSizeType)type {
    switch (type) {
        case kPageTextSizeTypeSmall:
            return @"28";
        case kPageTextSizeTypeMid:
            return @"30";
        case kPageTextSizeTypeLarge:
            return @"32";
    }
}

- (NSString *)pageDetailWithData:(NETResponse_PageDetail *)data
                        sizeType:(kPageTextSizeType)type {
    
    NSString *htmlTuijian = nil;
    
    NSArray *recommens = data.recommendList;
    if (recommens.count == 3) {
        NETResponse_PageDetail_Recommend *recom1 = [recommens objectAtIndex:0];
        NETResponse_PageDetail_Recommend *recom2 = [recommens objectAtIndex:1];
        NETResponse_PageDetail_Recommend *recom3 = [recommens objectAtIndex:2];
        
        htmlTuijian = [NSString stringWithFormat:self.htmlTuijian,
                       [NSString stringWithFormat:@"%@%@", kLinkTag, recom1.articleId],
                       recom1.articleShortTitle,
                       [NSString stringWithFormat:@"%@/%@", recom1.articleRootIn, recom1.articleAuthor],
                       [NSString stringWithFormat:@"%@%@", kLinkTag, recom2.articleId],
                       recom2.articleShortTitle,
                       [NSString stringWithFormat:@"%@/%@", recom2.articleRootIn, recom2.articleAuthor],
                       [NSString stringWithFormat:@"%@%@", kLinkTag, recom3.articleId],
                       recom3.articleShortTitle,
                       [NSString stringWithFormat:@"%@/%@", recom3.articleRootIn, recom3.articleAuthor]];

    }
    
    NSString *authorLink = data.articleAuthorName;
    if (data.articleAuthor) {
        authorLink = [NSString stringWithFormat:@"<a href=\"%@%@\">%@</a>", kLinkNameTag, data.articleAuthor, data.articleAuthorName];
    }
    
    NSData *comeData = UIImageJPEGRepresentation([UIImage imageNamed:@"come.png"], 1);
    NSData *userData = UIImageJPEGRepresentation([UIImage imageNamed:@"user.png"], 1);
    NSData *clocData = UIImageJPEGRepresentation([UIImage imageNamed:@"cloc.png"], 1);
    
    if (htmlTuijian) {
        NSString *html = [NSString stringWithFormat:self.htmlSource,
                          [NSString stringWithFormat:@"data:image/png;base64,%@", [Utility encodeBase64forData:comeData]],
                          [NSString stringWithFormat:@"data:image/png;base64,%@", [Utility encodeBase64forData:userData]],
                          [NSString stringWithFormat:@"data:image/png;base64,%@", [Utility encodeBase64forData:clocData]],
                          data.articleDeckblatt,
                          data.articleTitle,
                          data.articleRootIn,
                          authorLink,
                          data.articlePublishTime,
                          [self pageTextLinePace:type],
                          [self pageTextSize:type],
                          data.articleContent,
                          [NSString stringWithFormat:@"%@%@", htmlTuijian, self.htmlEnd]];
        return html;
    }else {
        NSString *html = [NSString stringWithFormat:self.htmlSource,
                          [NSString stringWithFormat:@"data:image/png;base64,%@", [Utility encodeBase64forData:comeData]],
                          [NSString stringWithFormat:@"data:image/png;base64,%@", [Utility encodeBase64forData:userData]],
                          [NSString stringWithFormat:@"data:image/png;base64,%@", [Utility encodeBase64forData:clocData]],
                          data.articleDeckblatt,
                          data.articleTitle,
                          data.articleRootIn,
                          authorLink,
                          data.articlePublishTime,
                          [self pageTextLinePace:type],
                          [self pageTextSize:type],
                          data.articleContent,
                          self.htmlEnd];
        return html;
    }    
}



#pragma mark - 
NSString *const kUserInfoSuccessRecivedNotification = @"kUserInfoSuccessRecivedNotification";
- (void)getUserInfoData {
    NETRequest_UserInfo *request = [[NETRequest_UserInfo alloc] init];
    [request loadUserId:self.loginUserID];
    [NET startRequestWithPort:YFY_NET_PORT_USER_INFO
                         code:YFY_NET_CODE_USER_INFO
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
}

NSString *const kOfflineDataSuccessRecivedNotification = @"kOfflineDataSuccessRecivedNotification";


#pragma mark - network delegate
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    if ([port isEqualToString:YFY_NET_PORT_USER_INFO]) {
        NETResponse_UserInfo *userInfo = [[NETResponse_UserInfo alloc] init];
        userInfo.responseDic = [dic objectForKey:YFY_NET_DATA];
        userInfo.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        NETResponse_Login *loginData = [DATA loginData];
        if (!loginData) {
            loginData = [[NETResponse_Login alloc] init];
            loginData.tokenId = [DATA tokenID];
        }
        [loginData resetResponseDic:userInfo.responseDic];
        
        [DATA setLoginData:loginData];
        [NOTI_CENTER postNotificationName:kUserInfoSuccessRecivedNotification object:nil];
    }
    if ([port isEqualToString:YFY_NET_PORT_OFF_LINE]) {
        NETResponse_Offline *rsp = [[NETResponse_Offline alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_DATA];
        rsp.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        NSMutableArray *imageURLArr = [NSMutableArray array];
        for (NETResponse_Offline_Result *channel_1 in rsp.channel_1) 
            [imageURLArr addObject:channel_1.articleDeckblatt];
        for (NETResponse_Offline_Result *channel_2 in rsp.channel_2) 
            [imageURLArr addObject:channel_2.articleDeckblatt];
        for (NETResponse_Offline_Result *channel_3 in rsp.channel_3) 
            [imageURLArr addObject:channel_3.articleDeckblatt];
        for (NETResponse_Offline_Result *channel_4 in rsp.channel_4) 
            [imageURLArr addObject:channel_4.articleDeckblatt];
        for (NETResponse_Offline_Result *channel_9 in rsp.channel_9) 
            [imageURLArr addObject:channel_9.articleDeckblatt];
        
        for (NSString *imageUrl in imageURLArr) {
            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:imageUrl]
                                                       options:0
                                                      progress:NULL
                                                     completed:^(UIImage *image,
                                                                 NSError *error,
                                                                 SDImageCacheType cacheType,
                                                                 BOOL finished) {
//                                                         NSLog(@"%d\t%@", finished, error);
                                                     }];
        }
        
        
        [DB writeOfflineDataToDB:rsp];
        
//        [NOTI_CENTER postNotificationName:kOfflineDataSuccessRecivedNotification object:nil];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    if ([port isEqualToString:YFY_NET_PORT_OFF_LINE]) {
        [NOTI_CENTER postNotificationName:kOfflineDataSuccessRecivedNotification object:@"离线下载失败"];
    }
}

//#pragma mark - ASIHttp
//- (void)requestFinished:(ASIHTTPRequest *)request {
//    NSString *jsonString = nil;
//    if ([request isResponseCompressed]) {// 响应是否被gzip压缩过？
//        jsonString = [[NSString alloc] initWithData:request.responseData
//                                           encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
//    } else {
//        jsonString = [request responseString];
//    }
//    
//    NSError *error;
//    NSDictionary *responseDic = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionNone error:&error];
//    
//    
//}
//- (void)requestFailed:(ASIHTTPRequest *)request {
//    
//}





@end
