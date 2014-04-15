//
//  NETRequest_SendLetter.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_SendLetter : NETRequest

@property (nonatomic, strong) NSNumber *letterSendUserId;
@property (nonatomic, strong) NSNumber *letterReceiveUserId;
@property (nonatomic, copy) NSString *letterText;

- (NSDictionary *)loadSendUserId:(NSNumber *)sendUserId
                   receiveUserId:(NSNumber *)receiveUserId
                            text:(NSString *)text;

@end
