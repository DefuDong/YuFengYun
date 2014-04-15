//
//  NETResponse_UserInfo.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_UserInfo.h"

@implementation NETResponse_UserInfo

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        self.userId             = [_responseDic objectForKey:@"userId"];
        self.userEmail          = [_responseDic objectForKey:@"userEmail"];
        self.userNickname       = [_responseDic objectForKey:@"userNickname"];
        self.userIcon           = [_responseDic objectForKey:@"userIcon"];
        self.userWeibo          = [_responseDic objectForKey:@"userWeibo"];
        self.userSex            = [_responseDic objectForKey:@"userSex"];
        self.userBirthday       = [_responseDic objectForKey:@"userBirthday"];
        self.userCompany        = [_responseDic objectForKey:@"userCompany"];
        self.userTitle          = [_responseDic objectForKey:@"userTitle"];
        self.userArea           = [_responseDic objectForKey:@"userArea"];
        self.userCity           = [_responseDic objectForKey:@"userCity"];
        self.userLevelType      = [_responseDic objectForKey:@"userLevelType"];
        self.userRegisteredTime = [_responseDic objectForKey:@"userRegisteredTime"];
        self.loyaltyValue       = [_responseDic objectForKey:@"loyaltyValue"];
        self.flag               = [_responseDic objectForKey:@"flag"];
        self.noticeCount        = [_responseDic objectForKey:@"noticeCount"];
        self.userInfo           = [_responseDic objectForKey:@"userInfo"];
        self.favoriteCount      = [_responseDic objectForKey:@"favoriteCount"];
        self.commentCount       = [_responseDic objectForKey:@"commentCount"];
        self.articleCount       = [_responseDic objectForKey:@"articleCount"];
    }
}


@end
