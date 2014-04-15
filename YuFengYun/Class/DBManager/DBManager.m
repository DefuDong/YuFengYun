//
//  DBManager.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-9.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "DBManager.h"
#import "Utility.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "NETResponse_Offline.h"
#import "NETResponse_Channel.h"
#import "NETResponse_PageDetail.h"
#import "NETResponse_FirstPage.h"
#import "NETResponse_FirstPageHeader.h"
#import "DataCenter.h"

@interface DBManager()
@property (strong, readwrite, nonatomic) FMDatabaseQueue *databaseQueue;
@end


@implementation DBManager
@synthesize tableNames = _tableNames;


+ (id)dbCenter {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (id)init {
    self = [super init];
    if (self) {
        DEBUG_LOG_(@"%@", [DBManager dbPath]);
        [DBManager creatDatabase];
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[DBManager dbPath]];
    }
    return self;
}


#pragma mark - offline
- (void)writeOfflineDataToDB:(NETResponse_Offline *)data {
    if (!data) return;
    
    [self deleteTables];
    [self creatTables];
    
    [self insertData:data.channel_1 toTable:self.tableNames[0]];
    [self insertData:data.channel_2 toTable:self.tableNames[1]];
    [self insertData:data.channel_3 toTable:self.tableNames[2]];
    [self insertData:data.channel_4 toTable:self.tableNames[3]];
    [self insertData:data.channel_9 toTable:self.tableNames[4]];
    
    [NOTI_CENTER postNotificationName:kOfflineDataSuccessRecivedNotification object:nil];
    
}
- (void)deleteTableWithName:(NSString *)name {
    
    if (name.length == 0) return;
    
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", name];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

- (NETResponse_Channel *)channelDataWithName:(NSString *)tableName {
    
    if (tableName.length == 0) return nil;
    if ([tableName isEqualToString:self.tableNames[0]]) {
        DEBUG_LOG_DB(@"CANT BE FIRST TABLE !!!");
        return nil;
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    FMDatabase * db = [FMDatabase databaseWithPath:[DBManager dbPath]];
    if ([db open]) {
        
        FMResultSet *result = [db executeQuery:sql];
        
        while ([result next]) {
            NETResponse_Channel_Result *ch = [[NETResponse_Channel_Result alloc] init];
            ch.articleId          = [NSNumber numberWithInt:[result intForColumn:@"articleId"]];
            ch.articleShortTitle  = [result stringForColumn:@"articleShortTitle"];
            ch.articleRootIn      = [result stringForColumn:@"articleRootIn"];
            ch.articleDeckblatt   = [result stringForColumn:@"articleDeckblatt"];
            ch.articlePublishTime = [result stringForColumn:@"articlePublishTime"];
            ch.articleSynopsis    = [result stringForColumn:@"articleSynopsis"];
            ch.articleCommentNum  = [NSNumber numberWithInt:[result intForColumn:@"articleCommentNum"]];
            
            [resultArr addObject:ch];
        }
        [db close];
    }
    
    if (resultArr.count == 0) return nil;
    
    NETResponse_Channel *channel = [[NETResponse_Channel alloc] init];
    channel.results = resultArr;
    channel.totalSize = [NSNumber numberWithInt:resultArr.count];
    
    return channel;
}
- (NETResponse_PageDetail *)pageDetailWithID:(NSNumber *)articleId tableName:(NSString *)name {
    
    if (!articleId) return nil;
    NETResponse_PageDetail *page = nil;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[DBManager dbPath]];
    if ([db open]) {
        
        if (name.length == 0) {
            for (NSString *tableName in self.tableNames) {
                
                if (![self isTableExist:tableName]) continue;
                
                NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE articleId = %@", tableName, articleId];
                FMResultSet *result = [db executeQuery:sql];
                while ([result next]) {
                    page = [[NETResponse_PageDetail alloc] init];
                    page.articleId          = [NSNumber numberWithInt:[result intForColumn:@"articleId"]];
                    page.articleTitle       = [result stringForColumn:@"articleTitle"];
                    page.articleContent     = [result stringForColumn:@"articleContent"];
                    page.articleRootIn      = [result stringForColumn:@"articleRootIn"];
                    page.articleDeckblatt   = [result stringForColumn:@"articleDeckblatt"];
                    page.articlePublishTime = [result stringForColumn:@"articlePublishTime"];
                    page.articleCommentNum  = [NSNumber numberWithInt:[result intForColumn:@"articleCommentNum"]];
                    break;
                }
                if (page) break;
            }
        }else {
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE articleId = %@", name, articleId];
            FMResultSet *result = [db executeQuery:sql];
            while ([result next]) {
                page = [[NETResponse_PageDetail alloc] init];
                page.articleId          = [NSNumber numberWithInt:[result intForColumn:@"articleId"]];
                page.articleTitle       = [result stringForColumn:@"articleTitle"];
                page.articleContent     = [result stringForColumn:@"articleContent"];
                page.articleRootIn      = [result stringForColumn:@"articleRootIn"];
                page.articleDeckblatt   = [result stringForColumn:@"articleDeckblatt"];
                page.articlePublishTime = [result stringForColumn:@"articlePublishTime"];
                page.articleCommentNum  = [NSNumber numberWithInt:[result intForColumn:@"articleCommentNum"]];
                break;
            }
        }
        
        [db close];
    }
    
    
    return page;
}
- (NETResponse_FirstPageHeader *)firstPageHeader {
    NSString *name = self.tableNames[0];
    
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:5];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", name];
    FMDatabase * db = [FMDatabase databaseWithPath:[DBManager dbPath]];
    if ([db open]) {
        
        FMResultSet *result = [db executeQuery:sql];
        
        while ([result next]) {
            
            NETResponse_FirstPageHeader_Result *ch = [[NETResponse_FirstPageHeader_Result alloc] init];
            ch.articleId          = [NSNumber numberWithInt:[result intForColumn:@"articleId"]];
            ch.articleShortTitle  = [result stringForColumn:@"articleShortTitle"];
            ch.articleRootIn      = [result stringForColumn:@"articleRootIn"];
            ch.articleDeckblatt   = [result stringForColumn:@"articleDeckblatt"];
            ch.articlePublishTime = [result stringForColumn:@"articlePublishTime"];
            
            [resultArr addObject:ch];
            if (resultArr.count == 5) break;
        }
        [db close];
    }
    
    if (resultArr.count == 0) return nil;
    
    NETResponse_FirstPageHeader *header = [[NETResponse_FirstPageHeader alloc] init];
    header.results = resultArr;
    
    return header;
}
- (NETResponse_FirstPage *)firstPageData {
    NSString *name = self.tableNames[0];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", name];
    FMDatabase * db = [FMDatabase databaseWithPath:[DBManager dbPath]];
    if ([db open]) {
        
        FMResultSet *result = [db executeQuery:sql];
        
        int index = 0;
        while ([result next]) {
            if (index < 5) {
                index++;
                break;
            }
            
            NETResponse_FirstPage_Result *ch = [[NETResponse_FirstPage_Result alloc] init];
            ch.articleId          = [NSNumber numberWithInt:[result intForColumn:@"articleId"]];
            ch.articleShortTitle  = [result stringForColumn:@"articleShortTitle"];
            ch.articleRootIn      = [result stringForColumn:@"articleRootIn"];
            ch.articleDeckblatt   = [result stringForColumn:@"articleDeckblatt"];
            ch.articlePublishTime = [result stringForColumn:@"articlePublishTime"];
            ch.formatPublishTime  = [result stringForColumn:@"formatPublishTime"];
            
            [resultArr addObject:ch];
        }
        [db close];
    }
    
    if (resultArr.count == 0) return nil;
    
    NETResponse_FirstPage *firstPage = [[NETResponse_FirstPage alloc] init];
    firstPage.results = resultArr;
    firstPage.totalSize = [NSNumber numberWithInt:resultArr.count];
    
    return firstPage;
}


- (BOOL)isTableExist:(NSString *)name {
    if (name.length == 0) return NO;
    
    NSString *sql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'", name];
    BOOL exist = NO;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[DBManager dbPath]];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"count(*)"];
            
            if (0 == count) exist = NO;
            else exist = YES;
            break;
        }
        [db close];
    }
    
    return exist;
}


#pragma mark -
#pragma mark - private
+ (NSString *)cachePath {
    return [[Utility cachesPath] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
}
+ (NSString *)dbPath {
    return [[Utility cachesPath] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default/userCacheDB.sqlite"];
    //    return [[Utility libraryPath] stringByAppendingPathComponent:@"Caches/userCacheDB.sqlite"];
}
+ (void)creatDatabase {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[DBManager cachePath]]) {
        [fileManager createDirectoryAtPath:[DBManager cachePath] withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    if (![fileManager fileExistsAtPath:[DBManager dbPath]]) {
        FMDatabase *db = [FMDatabase databaseWithPath:[DBManager dbPath]];
        if (![db open]) {
            DEBUG_LOG_(@"Error when open db");
            return;
        }
        [db close];
    }
}
- (NSArray *)tableNames {
    if (!_tableNames) {
        _tableNames = @[@"channel_1", @"channel_2", @"channel_3", @"channel_4", @"channel_9"];
    }
    return _tableNames;
}
- (void)creatTables {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[DBManager dbPath]]) {
        [DBManager creatDatabase];
    }
    
    NSString *parameter = @"articleId INT, articleContent TEXT, articleTitle TEXT, articleShortTitle TEXT, articleRootIn TEXT, articleDeckblatt TEXT, articlePublishTime TEXT, articleSynopsis TEXT, formatPublishTime TEXT, articleCommentNum INT";
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        for (NSString *name in self.tableNames) {
            
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT , %@)", name, parameter];
            [db executeUpdate:sql];
        }
    }];
    
}
- (void)deleteTables {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[DBManager dbPath]]) {
        return;
    }
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        for (NSString *name in self.tableNames) {
            NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", name];
            [db executeUpdate:sql];
        }
    }];
}
- (void)insertData:(NSArray *)data toTable:(NSString *)tableName {
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (articleId, articleContent, articleTitle, articleShortTitle, articleRootIn, articleDeckblatt, articlePublishTime, articleSynopsis, formatPublishTime, articleCommentNum) VALUES (?,?,?,?,?,?,?,?,?,?)", tableName];
    
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        for (NETResponse_Offline_Result *result in data) {
            db.logsErrors = YES;
            
            [db executeUpdate:sql,
             result.articleId,
             result.articleContent,
             result.articleTitle,
             result.articleShortTitle,
             result.articleRootIn,
             result.articleDeckblatt,
             result.articlePublishTime,
             result.articleSynopsis,
             result.formatPublishTime,
             result.articleCommentNum];
        }
    }];
}



@end






