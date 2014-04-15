//
//  NetworkCenter.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkMacros.h"


#define NET [NetworkCenter center]

@protocol NetworkCenterDelegate <NSObject>
@optional
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag;
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag;
@end


@interface NetworkCenter : NSObject

+ (id)center;

- (BOOL)cancelRequest:(NSString *)requestName
                  tag:(NSString *)tag
             receiver:(id<NetworkCenterDelegate>)receiver;

- (void)startRequestWithPort:(NSString *)port
                        code:(NSString *)code
                  parameters:(NSDictionary *)parameters
                         tag:(NSString *)tag
                     reciver:(id <NetworkCenterDelegate>)reciver;

- (void)uploadImage:(UIImage *)image
            reciver:(id <NetworkCenterDelegate>)reciver;

- (void)downloadOfflineWithProgress:(id)progress;


@end



