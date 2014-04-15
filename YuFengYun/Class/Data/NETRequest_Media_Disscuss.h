//
//  NETRequest_Disscuss.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest.h"

@interface NETRequest_Media_Disscuss : NETRequest

@property (nonatomic, strong) NSNumber *mediaId;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;

- (NSDictionary *)loadMediaId:(NSNumber *)mediaId
                         type:(NSString *)type
                    pageIndex:(NSNumber *)pageIndex
                     pageSize:(NSNumber *)pageSize;


@end
