//
//  ShareCenter.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "ShareCenter.h"
#import "DataCenter.h"
#import "UIImage+Tint.h"

@interface ShareCenter () 
<
  SSODelegate
>
/*****************************************************************************************************************************/
@property (nonatomic, strong, readwrite) TCWBEngine *tencentWeibo;
//third part
@property (nonatomic, copy)     TencentTirdPartLoginBlock tencentTirdPartBlock;
@end

@implementation ShareCenter

+ (id)center {
    static ShareCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[self alloc] init];});
    return instance;
}
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (TCWBEngine *)tencentWeibo {
    if (!_tencentWeibo) {
        _tencentWeibo = [[TCWBEngine alloc] initWithAppKey:kTencentAppKey
                                                 andSecret:kTencentAppSecret
                                            andRedirectUrl:kTencentRedirectURI];
    }
    return _tencentWeibo;
}


#pragma mark tencent
- (void)tencentTirdPartLogin:(TencentTirdPartLoginBlock)block {
    self.tencentTirdPartBlock = block;
    
    [self.tencentWeibo logInWithDelegate:self
                               onSuccess:@selector(tencentWeiboDidLogIn)
                               onFailure:@selector(tencentWeiboDidLoginFail:)];
}
#pragma mark tencent
/*
- (void)tencentGetUserInfo {
    [self.tencentWeibo getUserInfoWithFormat:@"json"
                                 parReserved:nil
                                    delegate:self
                                   onSuccess:@selector(getUserInfoSuccess:)
                                   onFailure:@selector(getUserInfoFail:)];
}
*/


#pragma mark - tencent delegate
- (void)tencentWeiboDidLogIn {
    
    self.tencentTirdPartBlock(YES, nil);
    self.tencentTirdPartBlock = nil;
}
- (void)tencentWeiboDidLoginFail:(NSError *)error {
    self.tencentTirdPartBlock(NO, error);
    self.tencentTirdPartBlock = nil;
}

//sso delegate
-(void)onLoginFailed:(WBErrCode)errCode msg:(NSString*)msg {
    
}
-(void)onLoginSuccessed:(NSString*)name token:(WBToken*)token {
    
}




@end





