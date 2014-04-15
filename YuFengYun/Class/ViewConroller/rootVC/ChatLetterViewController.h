//
//  ChatMessageViewController.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-1.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "YFYViewController.h"

@interface ChatLetterViewController : YFYViewController

@property (nonatomic, readonly, strong) NSNumber *userId;
@property (nonatomic, readonly, copy) NSString *nickName;

- (id)initWithUserId:(NSNumber *)userId nickName:(NSString *)nickName;
- (void)newMessageReceived:(NSDictionary *)dic;

@end
