//
//  NETRequest_EditUser.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_EditUser.h"

@implementation NETRequest_EditUser

- (NSDictionary *)build {
    if (self.userId) {
        [self.requestDic setObject:self.userId forKey:@"userId"];
    }
    if (self.userNickname) {
        [self.requestDic setObject:self.userNickname forKey:@"userNickname"];
    }
    if (self.userIcon) {
        [self.requestDic setObject:self.userIcon forKey:@"userIcon"];
    }
    if (self.userCompany) {
        [self.requestDic setObject:self.userCompany forKey:@"userCompany"];
    }
    if (self.userTitle) {
        [self.requestDic setObject:self.userTitle forKey:@"userTitle"];
    }
    if (self.userArea) {
        [self.requestDic setObject:self.userArea forKey:@"userArea"];
    }
    if (self.userCity) {
        [self.requestDic setObject:self.userArea forKey:@"userArea"];
    }
    if (self.userSex) {
        [self.requestDic setObject:self.userSex forKey:@"userSex"];
    }
    if (self.userInfo) {
        [self.requestDic setObject:self.userInfo forKey:@"userInfo"];
    }
    return self.requestDic;
}



- (NSDictionary *)loadUserId:(NSNumber *)userId
                userNickname:(NSString *)userNickname
                    userIcon:(NSString *)userIcon
                 userCompany:(NSString *)userCompany
                   userTitle:(NSString *)userTitle
                    userArea:(NSString *)userArea
                    userCity:(NSString *)userCity
                     userSex:(NSString *)userSex
                    userInfo:(NSString *)userInfo {
    self.userId = userId;
    self.userNickname = userNickname;
    self.userIcon = userIcon;
    self.userCompany = userCompany;
    self.userTitle = userTitle;
    self.userArea = userArea;
    self.userCity = userCity;
    self.userSex = userSex;
    self.userInfo = userInfo;
    return [self build];
}




@end
