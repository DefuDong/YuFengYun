//
//  NETRequest_SendLetter.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_SendLetter.h"

@implementation NETRequest_SendLetter

- (NSDictionary *)build {
    if (self.letterSendUserId) {
        [self.requestDic setObject:self.letterSendUserId forKey:@"letterSendUserId"];
    }
    if (self.letterReceiveUserId) {
        [self.requestDic setObject:self.letterReceiveUserId forKey:@"letterReceiveUserId"];
    }
    if (self.letterText) {
        [self.requestDic setObject:self.letterText forKey:@"letterText"];
    }
    
    return self.requestDic;
}

- (NSDictionary *)loadSendUserId:(NSNumber *)sendUserId
                   receiveUserId:(NSNumber *)receiveUserId
                            text:(NSString *)text {
    self.letterSendUserId = sendUserId;
    self.letterReceiveUserId = receiveUserId;
    self.letterText = text;
    return [self build];
}

@end
