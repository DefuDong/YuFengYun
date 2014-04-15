//
//  NETRequest_UserInfo.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_Media_UnCollect: NETRequest

@property (nonatomic, strong) NSNumber *mediaId;
@property (nonatomic, copy) NSString *type;

- (NSDictionary *)loadMediaId:(NSNumber *)mediaId type:(NSString *)type;

@end
