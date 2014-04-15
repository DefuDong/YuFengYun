//
//  NetRequest_TencentLogin.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-28.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NetRequest_TencentLogin.h"

@implementation NetRequest_TencentLogin

- (NSDictionary *)loadTokenId:(NSString *)tokenId
                       openid:(NSString *)openid
                      openkey:(NSString *)openkey
                    expiresIn:(NSString *)expiresIn {
    self.tokenId = tokenId;
    self.openid = openid;
    self.openkey = openkey;
    self.expiresIn = expiresIn;
    return [self build];
}

- (NSDictionary *)build {
    if (self.tokenId) {
        [self.requestDic setObject:self.tokenId forKey:@"tokenId"];
    }
    if (self.openid) {
        [self.requestDic setObject:self.openid forKey:@"openid"];
    }
    if (self.openkey) {
        [self.requestDic setObject:self.openkey forKey:@"openkey"];
    }
    if (self.expiresIn) {
        [self.requestDic setObject:self.expiresIn forKey:@"expiresIn"];
    }
    
    return self.requestDic;
}


@end
