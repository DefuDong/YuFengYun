//
//  NETResponse.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@implementation NETResponse
@synthesize responseDic = _responseDic;
@synthesize responseHeader = _responseHeader;
- (NETResponse_Header *)responseHeader {
    if (!_responseHeader) {
        _responseHeader = [[NETResponse_Header alloc] init];
    }
    return _responseHeader;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n%@", self.responseHeader, [self.responseDic description]];
}

@end



@implementation NETResponse_Header

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        self.reqCode = [_responseDic objectForKey:@"reqCode"];
        self.rspCode = [_responseDic objectForKey:@"rspCode"];
        self.rspDesc = [_responseDic objectForKey:@"rspDesc"];
        self.rspTime = [_responseDic objectForKey:@"rspTime"];
        self.transactionId = [_responseDic objectForKey:@"transactionId"];
    }
}

- (NSString *)description {
    return [self.responseDic description];
}

@end