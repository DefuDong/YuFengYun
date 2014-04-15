//
//  NETResponse_PageDetail.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-8.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETResponse.h"

@interface NETResponse_PageDetail : NETResponse

@property (nonatomic, strong) NSNumber *articleId;          //文章ID
@property (nonatomic, copy) NSString *articleTitle;         //文章标题
@property (nonatomic, copy) NSString *articleContent;       //文章内容
@property (nonatomic, copy) NSString *articleRootIn;        //文章来源
@property (nonatomic, copy) NSString *articleDeckblatt;     //文章图片
@property (nonatomic, copy) NSString *articlePublishTime;   //发布时间
@property (nonatomic, copy) NSString *articleAuthorName;    //作者
@property (nonatomic, strong) NSNumber *articleFavoriteNum;   //文章收藏数
@property (nonatomic, strong) NSNumber *articleEnjoyNum;      //文章喜欢数
@property (nonatomic, strong) NSNumber *articleCommentNum;    //文章评论数
@property (nonatomic, copy) NSString *favoriteFlag;
@property (nonatomic, copy) NSString *enjoyFlag;
@property (nonatomic, copy) NSString *articleShortTitle;
@property (nonatomic, copy) NSString *articleLink;
@property (nonatomic, copy) NSString *articleSynopsis;
@property (nonatomic, strong) NSNumber *articleAuthor;


@property (nonatomic, strong) NSArray *recommendList; //NETResponse_PageDetail_Recommend

@end



@interface NETResponse_PageDetail_Recommend : NETResponse

@property (nonatomic, strong) NSNumber *articleId;            //文章ID
@property (nonatomic, copy) NSString *articleShortTitle;    //文章短标题
@property (nonatomic, copy) NSString *articleRootIn;
@property (nonatomic, copy) NSString *articleAuthor;

@end
