//
//  NETRequest_DeleDisscuss.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_DeleDisscuss : NETRequest

@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic, strong) NSNumber *commentUserId;


- (NSDictionary *)loadUserId:(NSNumber *)commentUserId
                   commentId:(NSNumber *)commentId;


@end
