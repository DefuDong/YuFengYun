//
//  NETResponse_ChatLetter.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-13.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_ChatLetter : NETResponse

@property (nonatomic, strong) NSNumber *totalSize;
@property (nonatomic, strong) NSMutableArray *results;

- (void)addResponseDic:(NSDictionary *)dic;

@end




@interface NETResponse_ChatLetter_Result : NETResponse

@property (nonatomic, strong) NSNumber *letterSendUserId;
@property (nonatomic, strong) NSNumber *letterReceiveUserId;
@property (nonatomic, copy) NSString *letterSendUserName;
@property (nonatomic, copy) NSString *letterReceiveUserName;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *letterText;
@property (nonatomic, strong) NSNumber *letterId;



@end
