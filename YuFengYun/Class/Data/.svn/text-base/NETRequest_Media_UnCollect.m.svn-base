//
//  NETRequest_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_Media_UnCollect.h"

@implementation NETRequest_Media_UnCollect

- (NSDictionary *)build {
    if (self.mediaId) {
        [self.requestDic setObject:self.mediaId forKey:@"mediaId"];
        [self.requestDic setObject:self.type forKey:@"type"];
    }
    return self.requestDic;
}

- (NSDictionary *)loadMediaId:(NSNumber *)mediaId type:(NSString *)type {
    self.mediaId = mediaId;
    self.type = type;
    return [self build];
}

@end
