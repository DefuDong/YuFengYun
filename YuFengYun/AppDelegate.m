//
//  AppDelegate.m
//  YuFengYun
//
//  Created by 董德富 on 13-9-25.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

#import "MMExampleDrawerVisualStateManager.h"
#import "MLNavigationController.h"

#import "Reachability.h"
#import "AlertUtility.h"
#import "Utility.h"
#import "GuideView.h"
#import "DataCenter.h"
#import "NetworkCenter.h"
#import "NETRequest_RegisterDevice.h"

#import "LoginViewController.h"
#import "MessageShowWindow.h"
#import "ChatListViewController.h"
#import "ChatLetterViewController.h"

//#import "iVersion.h"r
#import "BaiduMobStat.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MobClick.h"

@implementation AppDelegate

//+ (void)initialize
//{
//    [iVersion sharedInstance];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch
    
    [self _queryNet];
    
    MLNavigationController *nav = [self _setRootVC];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
//    backImageView.image = [UIImage imageNamed:@"window_back.png"];
//    [self.window insertSubview:backImageView atIndex:0];
    
    [self _firstGuid];
    
    [self _persetAuthority];
    
    [self _baiduStat];
    
    [self _umSocoalShare];
      
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    [NOTI_CENTER addObserver:self
                    selector:@selector(launchNotification:)
                        name:UIApplicationDidFinishLaunchingNotification
                      object:nil];
    application.applicationIconBadgeNumber = 0;
    
    DEBUG_LOG_(@"%@", [Utility documentPath]);
    
    return YES;
}

- (void)_queryNet {
    [NOTI_CENTER addObserver:self
                    selector:@selector(reachabilityChanged:)
                        name:kReachabilityChangedNotification
                      object:nil];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        [AlertUtility showAlertWithMess:@"无网络连接"];
    }
    else if (status == ReachableViaWWAN) {
        [HUD showText:@"当前网络为GPRS"];
    }
    [reach startNotifier];
}
- (MLNavigationController *)_setRootVC {
    LeftViewController *left = [[LeftViewController alloc] initFromNib];
    RightViewController *right = [[RightViewController alloc] initFromNib];
    ViewController *center = [[ViewController alloc] initFromNib];
//    MLNavigationController *centerNav = [[MLNavigationController alloc] initWithRootViewController:center];
//    centerNav.navigationBarHidden = YES;
//    center.wantsFullScreenLayout = YES;
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:center
                                                            leftDrawerViewController:left
                                                           rightDrawerViewController:right];
    [self.drawerController setMaximumRightDrawerWidth:250.0];
    [self.drawerController setMaximumLeftDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:63];
    [self.drawerController setShouldStretchDrawer:NO];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController,
                                                       MMDrawerSide drawerSide,
                                                       CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block =
        [[MMExampleDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
        if(block)
            block(drawerController, drawerSide, percentVisible);
    }];
    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeNone];
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeNone];
    self.drawerController.view.backgroundColor = [UIColor clearColor];
    
    MLNavigationController *nav = [[MLNavigationController alloc] initWithRootViewController:self.drawerController];
    nav.navigationBarHidden = YES;
    return nav;
}
- (void)_firstGuid {
    //第一次启动用户引导页
    NSString *latestVersion = [USER_DEFAULT objectForKey:kLastVersionKey];
    NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    if (!latestVersion.length || ![latestVersion isEqualToString:applicationVersion]) {
        CGRect frame = [UIScreen mainScreen].applicationFrame;
        if (SYSTEM_VERSION_MOER_THAN_7) {
            frame = [UIScreen mainScreen].bounds;
        }
        NSArray *array = @[@"引导页4s1", @"引导页4s2"];
        if (self.window.frame.size.height > 480) {
            //            frame.size.height = 548;
            array = @[@"引导页1", @"引导页2"];
        }
        GuideView *guid = [[GuideView alloc] initWithFrame:frame];
        guid.imageNames = array;
        guid.completeBlock = ^{
            [USER_DEFAULT setObject:applicationVersion forKey:kLastVersionKey];
            [USER_DEFAULT synchronize];
        };
        [self.window addSubview:guid];
    }    
}
- (void)_persetAuthority {
    NSString *tokenId = [USER_DEFAULT objectForKey:kUserTokenKey];
    NSNumber *userId = [USER_DEFAULT objectForKey:kUserIdKey];
    if (tokenId.length == 0 || !userId) {
        //        [LoginViewController login:NULL];
    }else {
        [DATA setTokenID:tokenId];
        [DATA setLoginUserID:userId];
        [DATA setIsLogin:YES];
        
        [DATA getUserInfoData];
    }
}
- (void)_baiduStat {
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = NO; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.logSendInterval = 12;  //为1时表示发送日志的时间间隔为1小时
    statTracker.logSendWifiOnly = YES; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 60;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    [statTracker startWithAppId:kBaiduAppKey];//设置您在mtj网站上添加的app的appkey
}
- (void)_umSocoalShare {
    //打开调试log的开关
#ifdef DEBUG
    [UMSocialData openLog:YES];
#endif
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUMAppKey];
    
    //打开Qzone的SSO开关
    [UMSocialQQHandler setSupportQzoneSSO:YES];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialQQHandler setQQWithAppId:kQQAppKey appKey:kQQAppSecret url:kURLConnect];
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES];
    
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:kWeixinAppID url:kURLConnect];
    
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionCenter];
    
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"2747278047", UMShareToTencent: @"yufengyunkeji"}];
    
    //使用友盟统计
    [MobClick startWithAppkey:kUMAppKey];
    [MobClick checkUpdate];
    //    [MobClick setLogEnabled:YES];
}


- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *reach = [note object];
    NetworkStatus status = [reach currentReachabilityStatus];
    DEBUG_LOG_(@"%@", [reach currentReachabilityString]);
    if (status == NotReachable) {
        [AlertUtility showAlertWithMess:@"无网络连接"];
    }else if (status == ReachableViaWWAN) {
        [HUD showText:@"当前网络为GPRS"];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UMSocialSnsService  applicationDidBecomeActive];
}


#pragma mark - push
- (void)launchNotification:(NSNotification *)notification {
    DEBUG_LOG(@"%@", notification.userInfo);
    
    if (notification.userInfo != nil) {
		NSDictionary* dictionary = [notification.userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            
            NSDictionary *aps = [dictionary objectForKey:@"aps"];
            NSString *name = [dictionary objectForKey:@"name"];
            NSNumber *userId = [dictionary objectForKey:@"id"];
            NSString *alert = [aps objectForKey:@"alert"];
            
            if (name.length && userId) {
                
                [MESSGAE_WINDOW showMessage:[NSString stringWithFormat:@"来自%@的私信", name]
                                     userId:userId
                                   nickName:name];
                
                __weak AppDelegate *wself = self;
                [self.drawerController openDrawerSide:MMDrawerSideRight animated:NO completion:^(BOOL finished) {
                    ChatListViewController *chatList = [[ChatListViewController alloc] initFromNib];
                    [wself.drawerController.navigationController pushViewController:chatList animated:YES];
                }];
            }else {
                [MESSGAE_WINDOW showMessage:alert userId:nil nickName:nil];
            }
        }
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理推送消息
    DEBUG_LOG(@"%@", userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *name = [userInfo objectForKey:@"name"];
    NSNumber *userId = [userInfo objectForKey:@"id"];
    NSString *alert = [aps objectForKey:@"alert"];
    
    if (name.length && userId) {
        if ([DATA chatPage]) {
            ChatLetterViewController *chatPage = [DATA chatPage];
            [chatPage newMessageReceived:@{@"name": name, @"id": userId, @"text": alert}];
        }else {
            [MESSGAE_WINDOW showMessage:[NSString stringWithFormat:@"来自%@的私信", name]
                                 userId:userId
                               nickName:name];
        }
    }else {
        [MESSGAE_WINDOW showMessage:alert userId:nil nickName:nil];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DEBUG_LOG(@"regisger success:%@",deviceToken);
    
    NSString *string = [NSString stringWithFormat:@"%@", deviceToken];
    string = [string substringWithRange:NSMakeRange(1, string.length-2)];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [USER_DEFAULT setObject:string forKey:kDeviceToken];
    [USER_DEFAULT synchronize];
    
    NETRequest_RegisterDevice *request = [[NETRequest_RegisterDevice alloc] init];
    [request loadDeviceToken:string];
    [NET startRequestWithPort:YFY_NET_PORT_REGISTER_DEVICE
                         code:YFY_NET_CODE_REGISTER_DEVICE
                   parameters:request.requestDic
                          tag:nil
                      reciver:nil];
    //注册成功，将deviceToken保存
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DEBUG_LOG(@"%@", [error localizedDescription]);
}



#pragma mark - sso
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
//Available in iOS 4.2 and later.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
   [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
