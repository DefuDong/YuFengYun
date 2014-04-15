//
//  NETRequest_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_Video.h"

@implementation NETRequest_Video

- (NSDictionary *)build {
    if (self.videoId) {
        [self.requestDic setObject:self.videoId forKey:@"videoId"];
    }
    return self.requestDic;
}

- (NSDictionary *)loadVideoId:(NSNumber *)videoId {
    self.videoId = videoId;
    return [self build];
}

@end
