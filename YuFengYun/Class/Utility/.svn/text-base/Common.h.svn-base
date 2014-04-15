//
//  Common.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-25.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#ifndef YunHuaShiDai_Common_h
#define YunHuaShiDai_Common_h

#import "DebugMacros.h"


#define kRGBColor(R,G,B)    [UIColor colorWithRed:(R / 255.) green:(G / 255.) blue:(B / 255.) alpha:1]
#define kRGBAColor(R,G,B,A) [UIColor colorWithRed:(R / 255.) green:(G / 255.) blue:(B / 255.) alpha:A]

#define NOTI_CENTER         [NSNotificationCenter defaultCenter]
#define USER_DEFAULT        [NSUserDefaults standardUserDefaults]

//用来获取手机的系统，判断系统是多少
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_MOER_THAN_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

//image form file
#define	PATHRESOURCE(__Name__, __Type__) [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x", __Name__] ofType:__Type__]
#define UIIMAGE_FILE(__imageName__) [[UIImage alloc] initWithContentsOfFile:PATHRESOURCE(__imageName__, @"png")]


/******************************************************************************************************************************/

#define kLastVersionKey     @"kLastVersionKey"

/******************************************************************************************************************************/

#define kUserTokenKey   @"accessToken"
#define kUserIdKey      @"userId"
#define kUserNameKey    @"userName"
#define kUserLoginType  @"userLoginType"

// page detail
#define kLinkTag @"YunHuanShiDai"
#define kLinkNameTag @"ArticleAuthor"

//设备推送
#define kDeviceToken @"deviceToken"

//百度统计
#define kBaiduAppKey @"b431010685"

//友盟社会分享
#define kUMAppKey   @"528acd0456240be0db35cff5"
#define kURLConnect @"http://xf.yufengyun.com"


#define kSinaAppKey             @"996627267"//@"4016205768"
#define kSinaAppSecret          @"2a69cc8a063451d06b312403097eaaeee"//@"91f093a5a8065e95e1c68d6128068d11"
#define kSinaAppRedirectURI     @"http://xf.yufengyun.com/account/auth/weibo/callback"

#define kTencentAppKey              @"801395878"//@"801445697"//
#define kTencentAppSecret           @"21d9bdf0ed49867564da70667d9b92cc"//@"1a42863095ae0d7adb9aff348adff853"//
#define kTencentRedirectURI         @"http://xf.yufengyun.com/account/auth/qq/callback"

#define kWeixinAppKey       @"abd82d26d985eed786d2d3e8faa2e7eb"
#define kWeixinAppID        @"wx922e63039c17fee2"

#define kQQAppKey       @"100559949"
#define kQQAppSecret    @"f1eb2d58fe774fd647a178e33027018e"





/******************************************************************************************************************************/
#define CHANNEL_CODE_XINSHIDIAN @"01"
#define CHANNEL_CODE_DONGTAI    @"02"
#define CHANNEL_CODE_SHIDIAN    @"03"
#define CHANNEL_CODE_GUANLI     @"04"
/******************************************************************************************************************************/


#endif
