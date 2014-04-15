//
//  ShareCenter.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCWBEngine.h"

#define kTencentSourceApplication   @"com.tencent.WeiBo"

#define SHARE [ShareCenter center]

typedef void (^TencentTirdPartLoginBlock)(BOOL flag, NSError *error);

@interface ShareCenter : NSObject

@property (nonatomic, readonly, strong) TCWBEngine *tencentWeibo;

+ (id)center;

- (void)tencentTirdPartLogin:(TencentTirdPartLoginBlock)block;

@end
