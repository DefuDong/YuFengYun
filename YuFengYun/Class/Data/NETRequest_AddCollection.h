//
//  NETRequest_AddCollection.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_AddCollection : NETRequest

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *articleId;

- (NSDictionary *)loadUserId:(NSNumber *)userId articleId:(NSNumber *)articleId;

@end
