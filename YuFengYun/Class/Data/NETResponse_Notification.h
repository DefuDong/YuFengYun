//
//  NETResponse_Notification.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_Notification : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end



@interface NETResponse_Notification_Result : NETResponse

@property (nonatomic, strong) NSNumber *noticeId;   //通知ID
@property (nonatomic, copy) NSString *noticeText;   //通知内容
@property (nonatomic, copy) NSString *releaseTime;  //通知发送时间

@end
