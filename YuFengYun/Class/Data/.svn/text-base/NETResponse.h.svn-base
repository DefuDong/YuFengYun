//
//  NETResponse.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NETResponse_Header;
@interface NETResponse : NSObject {
    @public
    NSDictionary *_responseDic;
    NETResponse_Header *_responseHeader;
}

@property (nonatomic, strong) NSDictionary *responseDic;
@property (nonatomic, strong) NETResponse_Header *responseHeader;

@end




@interface NETResponse_Header : NSObject

@property (nonatomic, strong) NSDictionary *responseDic;

@property (nonatomic, copy) NSString *reqCode;      //请求代码(从请求中直接返回)
@property (nonatomic, copy) NSString *rspCode;      //响应代码
@property (nonatomic, copy) NSString *rspDesc;      //响应描述
@property (nonatomic, copy) NSString *rspTime;      //响应时间
@property (nonatomic, copy) NSString *transactionId;//直接从请求返回

@end