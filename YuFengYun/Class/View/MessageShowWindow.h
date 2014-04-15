//
//  MessageShowWindow.h
//  YunHua
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MESSGAE_WINDOW [MessageShowWindow message]

//@class NETResponse_ChatList_Result;
@interface MessageShowWindow : UIWindow

+ (id)message;

- (void)showMessage:(NSString *)text
             userId:(NSNumber *)userId
           nickName:(NSString *)nickName;

@end
