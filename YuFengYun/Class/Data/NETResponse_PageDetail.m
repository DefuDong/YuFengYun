//
//  NETResponse_PageDetail.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse_PageDetail.h"

@implementation NETResponse_PageDetail

//@property (nonatomic, copy) NSString *articleRootIn;        //文章来源
//@property (nonatomic, copy) NSString *articleDeckblatt;     //文章图片
//@property (nonatomic, copy) NSString *articlePublishTime;   //发布时间
//@property (nonatomic, copy) NSString *articleAuthorName;    //作者


- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        
        self.articleId          = [_responseDic objectForKey:@"articleId"];
        self.articleTitle       = [_responseDic objectForKey:@"articleTitle"];
        self.articleContent     = [_responseDic objectForKey:@"articleContent"];
        self.articleRootIn      = [_responseDic objectForKey:@"articleRootIn"];
        self.articleDeckblatt   = [_responseDic objectForKey:@"articleDeckblatt"];
        self.articlePublishTime = [_responseDic objectForKey:@"articlePublishTime"];
        self.articleAuthorName  = [_responseDic objectForKey:@"articleAuthorName"];
        self.articleFavoriteNum = [_responseDic objectForKey:@"articleFavoriteNum"];
        self.articleEnjoyNum    = [_responseDic objectForKey:@"articleEnjoyNum"];
        self.articleCommentNum  = [_responseDic objectForKey:@"articleCommentNum"];
        self.favoriteFlag       = [_responseDic objectForKey:@"favoriteFlag"];
        self.enjoyFlag          = [_responseDic objectForKey:@"enjoyFlag"];
        self.articleShortTitle  = [_responseDic objectForKey:@"articleShortTitle"];
        self.articleLink        = [_responseDic objectForKey:@"articleLink"];
        self.articleSynopsis    = [_responseDic objectForKey:@"articleSynopsis"];
        self.articleAuthor      = [_responseDic objectForKey:@"articleAuthor"];

        NSArray *recommendArr = [_responseDic objectForKey:@"recommendList"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *resultDic in recommendArr) {
            NETResponse_PageDetail_Recommend *result = [[NETResponse_PageDetail_Recommend alloc] init];
            result.responseDic = resultDic;
            
            [arr addObject:result];
        }
        
        self.recommendList = arr;
    }
}
//- (NSString *)

@end



@implementation NETResponse_PageDetail_Recommend

- (void)setResponseDic:(NSDictionary *)responseDic {
    if (_responseDic != responseDic) {
        _responseDic = responseDic;
        self.articleId          = [_responseDic objectForKey:@"articleId"];
        self.articleShortTitle  = [_responseDic objectForKey:@"articleShortTitle"];
        self.articleRootIn      = [_responseDic objectForKey:@"articleRootIn"];
        self.articleAuthor      = [_responseDic objectForKey:@"articleAuthor"];
    }
}

@end
