//
//  DataCenter.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATA [DataCenter data]


typedef NS_ENUM(NSInteger, kPageTextSizeType) {
    kPageTextSizeTypeSmall  = 0,
    kPageTextSizeTypeMid    = 1,
    kPageTextSizeTypeLarge  = 2
};

@class NETResponse_Login;
@class NETResponse_FirstPageHeader;
@class NETResponse_FirstPage;
@class NETResponse_Channel;
@class NETResponse_Disscuss;
@class NETResponse_ReplayMe;
@class NETResponse_Collections;
@class NETResponse_Notification;
@class NETResponse_PageDiscuss;
@class NETResponse_PageDetail;
@class NETResponse_ChatList;
@class NETResponse_PictureIndex;
@class NETResponse_VideoIndex;
@class NETResponse_Media_Collections;

@class ChatLetterViewController;

@interface DataCenter : NSObject

+ (id)data;

//login & user
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSNumber *loginUserID;
@property (nonatomic, copy) NSString *tokenID;
@property (nonatomic, strong) NETResponse_Login *loginData;

//首页
@property (nonatomic, strong) NETResponse_FirstPageHeader *firstPageHeader;
@property (nonatomic, strong) NETResponse_FirstPage *firstPage;

//频道
@property (nonatomic, strong) NETResponse_Channel *channelPage_XinShiDian;
@property (nonatomic, strong) NETResponse_Channel *channelPage_DongTai;
@property (nonatomic, strong) NETResponse_Channel *channelPage_ShiDian;
@property (nonatomic, strong) NETResponse_Channel *channelPage_GuanLi;

//图集
@property (nonatomic, strong) NETResponse_PictureIndex *picturePage;

//视频
@property (nonatomic, strong) NETResponse_VideoIndex *videoPage;


//用户
//我的评论/回复我的
@property (nonatomic, strong) NETResponse_Disscuss *myDisscusses;
@property (nonatomic, strong) NETResponse_ReplayMe *replayMe;

//通知
@property (nonatomic, strong) NETResponse_Notification *myNotification;
//文章评论
@property (nonatomic, strong) NETResponse_PageDiscuss *pageDiscuss;

//私信列表
@property (nonatomic, strong) NETResponse_ChatList *chatList;
//当前私信界面 指针
@property (nonatomic, weak) ChatLetterViewController *chatPage;


@property (nonatomic, strong) NSMutableDictionary *cityDataDic_pinyin;

//net
extern NSString *const kUserInfoSuccessRecivedNotification;
- (void)getUserInfoData;

//face
@property (nonatomic, strong, readonly) NSDictionary *face_text_image;


//根据获取到的页面数据， 组装成显示的html代码
@property (nonatomic, assign) kPageTextSizeType pageTextType;
- (NSString *)pageDetailWithData:(NETResponse_PageDetail *)data
                        sizeType:(kPageTextSizeType)size;


//off line
extern NSString *const kOfflineDataSuccessRecivedNotification;


@end














