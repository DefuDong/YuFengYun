//
//  DBManager.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-9.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB [DBManager dbCenter]

@class FMDatabaseQueue;
@class NETResponse_Offline;
@class NETResponse_Channel;
@class NETResponse_PageDetail;
@class NETResponse_FirstPageHeader;
@class NETResponse_FirstPage;
@interface DBManager : NSObject

@property (strong, readonly, nonatomic) FMDatabaseQueue *databaseQueue;
@property (strong, readonly, nonatomic) NSArray *tableNames;


+ (id)dbCenter;
+ (NSString *)cachePath;

- (void)writeOfflineDataToDB:(NETResponse_Offline *)data;
- (void)deleteTableWithName:(NSString *)name;

- (NETResponse_Channel *)channelDataWithName:(NSString *)tableName;
- (NETResponse_PageDetail *)pageDetailWithID:(NSNumber *)articleId tableName:(NSString *)name;

- (NETResponse_FirstPageHeader *)firstPageHeader;
- (NETResponse_FirstPage *)firstPageData;

- (BOOL)isTableExist:(NSString *)name;
@end


