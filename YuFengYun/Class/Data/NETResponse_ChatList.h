//
//  NETResponse_ChatList.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_ChatList : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end




@interface NETResponse_ChatList_Result : NETResponse

@property (nonatomic, strong) NSNumber *letterSendUserId;
@property (nonatomic, copy) NSString *letterSendUserName;
@property (nonatomic, copy) NSString *letterReceiveUserName;
@property (nonatomic, strong) NSNumber *childCount;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *letterText;
@property (nonatomic, strong) NSNumber *letterId;
@property (nonatomic, copy) NSString *sendTime;


@end