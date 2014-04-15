//
//  NETRequest_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_Picture.h"

@implementation NETRequest_Picture

- (NSDictionary *)build {
    if (self.atlasId) {
        [self.requestDic setObject:self.atlasId forKey:@"atlasId"];
    }
    return self.requestDic;
}

- (NSDictionary *)loadAtlasId:(NSNumber *)atlasId {
    self.atlasId = atlasId;
    return [self build];
}

@end
