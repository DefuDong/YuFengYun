//
//  XMPPCenter.m
//  XMPPTest
//
//  Created by 董德富 on 13-6-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "XMPPCenter.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

#define XMPP_HOST_NAME @"ddfmac.local"

@interface XMPPCenter()
<
  XMPPStreamDelegate,
  XMPPRosterDelegate,
  XMPPMessageArchivingStorage
>
{
    
    XMPPStream                  *_xmppStream;               //base
	XMPPReconnect               *_xmppReconnect;            //自动重连
    XMPPRoster                  *_xmppRoster;               //名单
	XMPPRosterCoreDataStorage   *_xmppRosterStorage;        //名单数据库
    XMPPvCardCoreDataStorage    *_xmppvCardStorage;         //名片
	XMPPvCardTempModule         *_xmppvCardTempModule;
	XMPPvCardAvatarModule       *_xmppvCardAvatarModule;    //头像
	XMPPCapabilities            *_xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *_xmppCapabilitiesStorage;
    
    ////////离线消息
    XMPPMessageArchiving *_xmppMessageArchiving;
    XMPPMessageArchivingCoreDataStorage *_xmppMessageArchivingStorage;
    
    NSString *password;
	
	BOOL allowSelfSignedCertificates;//允许自我签名证书
	BOOL allowSSLHostNameMismatch;//允许SSL主机名不匹配
	
	BOOL isXmppConnected;
}
@end

@implementation XMPPCenter

+ (id)center {
    static XMPPCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[self alloc] init];});
    return instance;
}
- (id)init {
    self = [super init];
    if (self) {
//        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        [self setupStream];
//        if (![self connect]) {
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                
//             });
//        }
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupStream {
    
	NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");

	_xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		_xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
		
    //自动重连
	_xmppReconnect = [[XMPPReconnect alloc] init];
		
    //名单数据库
	_xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
//	_xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
    //名单
	_xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
	_xmppRoster.autoFetchRoster = YES;
	_xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
    //名片（头像） 会自动整合到名单中
	_xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	_xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
	
	_xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
    
    //服务器端消息
    _xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self];
	
    /*
     Setup capabilities

     The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
     Basically, when other clients broadcast their presence on the network
     they include information about what capabilities their client supports (audio, video, file transfer, etc).
     But as you can imagine, this list starts to get pretty big.
     This is where the hashing stuff comes into play.
     Most people running the same version of the same client are going to have the same list of capabilities.
     So the protocol defines a standardized way to hash the list of capabilities.
     Clients then broadcast the tiny hash instead of the big list.
     The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
     and also persistently storing the hashes so lookups aren't needed in the future.

     Similarly to the roster, the storage of the module is abstracted.
     You are strongly encouraged to persist caps information across sessions.

     The XMPPCapabilitiesCoreDataStorage is an ideal solution.
     It can also be shared amongst multiple streams to further reduce hash lookups.
    */
	//音频、视频、文件等传输
	_xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesStorage];
    
    _xmppCapabilities.autoFetchHashedCapabilities = YES;
    _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// 激活xmpp模块
	[_xmppReconnect         activate:_xmppStream];
	[_xmppRoster            activate:_xmppStream];
	[_xmppvCardTempModule   activate:_xmppStream];
	[_xmppvCardAvatarModule activate:_xmppStream];
	[_xmppCapabilities      activate:_xmppStream];
    [_xmppMessageArchiving  activate:_xmppStream];//////
    
	// Add ourself as a delegate to anything we may be interested in
	[_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];

	[_xmppStream setHostName:XMPP_HOST_NAME];
	[_xmppStream setHostPort:5222];
	
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;//允许自我签名证书
	allowSSLHostNameMismatch = NO;//允许SSL主机名不匹配
}
- (void)teardownStream {
	[_xmppStream removeDelegate:self];
	[_xmppRoster removeDelegate:self];
	
	[_xmppReconnect         deactivate];
	[_xmppRoster            deactivate];
	[_xmppvCardTempModule   deactivate];
	[_xmppvCardAvatarModule deactivate];
	[_xmppCapabilities      deactivate];
	
	[_xmppStream disconnect];
	
	_xmppStream = nil;
	_xmppReconnect = nil;
    _xmppRoster = nil;
	_xmppRosterStorage = nil;
	_xmppvCardStorage = nil;
    _xmppvCardTempModule = nil;
	_xmppvCardAvatarModule = nil;
	_xmppCapabilities = nil;
	_xmppCapabilitiesStorage = nil;
}
- (void)goOnline {
    
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    [_xmppStream sendElement:presence];
}
- (void)goOffline {
    
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)xmppConnect {
    if (![_xmppStream isDisconnected]) return YES;
    
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [defaults stringForKey:@"user"];
    NSString *pass = [defaults stringForKey:@"password"];
    
    if (!userId || !pass) return NO;
    
    //设置用户
    [_xmppStream setMyJID:[XMPPJID jidWithString:userId]];
    //密码
    password = pass;
    
    //连接服务器
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        DEBUG_LOG_XMPP(@"Error connecting: %@", error);
        return NO;
    }
    
    return YES;
}
- (void)disconnect {
	[self goOffline];
	[_xmppStream disconnect];
}
- (void)queryRoster {
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
//    [iq addAttributeWithName:@"id" stringValue:@"123456"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}
- (void)addBuddy:(NSString *)jid nickName:(NSString *)nickName {
    //添加好友
    XMPPJID *frendJID = [XMPPJID jidWithString:jid];
    [_xmppRoster addUser:frendJID withNickname:nickName];
//    [_xmppRoster subscribePresenceToUser:frendJID];
}
//删除好友,取消加好友，或者加好友后需要删除
- (void)removeBuddy:(NSString *)jidString {
    XMPPJID *jid = [XMPPJID jidWithString:jidString];
    [_xmppRoster removeUser:jid];
}
- (void)sendMessage:(NSString *)message to:(NSString *)chatUser {
//    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//    [body setStringValue:message];
//    
//    //生成XML消息文档
//    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
//    //消息类型
//    [mes addAttributeWithName:@"type" stringValue:@"chat"];
//    //发送给谁
//    [mes addAttributeWithName:@"to" stringValue:chatUser];
//    //由谁发送
//    [mes addAttributeWithName:@"from" stringValue:self.xmppStream.myJID.description];
//    //组合
//    [mes addChild:body];
//    
//    NSLog(@"%@", mes);
//    //发送消息
//    [self.xmppStream sendElement:mes];
    
    XMPPMessage *mess = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:chatUser]];
    [mess addBody:message];
    NSLog(@"%@", mess);
    [_xmppStream sendElement:mess];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
	DEBUG_LOG_XMPP(nil);
}
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
	DEBUG_LOG_XMPP(nil);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = _xmppStream.hostName;
		NSString *virtualDomain = [_xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}
- (void)xmppStreamDidSecure:(XMPPStream *)sender {
	DEBUG_LOG_XMPP(nil);
}
//连接服务器  此方法在stream开始连接服务器的时候调用
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    DEBUG_LOG_XMPP(nil);
    isXmppConnected = YES;
    
    NSError *error = nil;
    //验证密码
    if (![_xmppStream authenticateWithPassword:password error:&error]) {
		DEBUG_LOG_XMPP(@"Error authenticating: %@", error);
	}
}
//此方法在stream连接断开的时候调用
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    DEBUG_LOG_XMPP(nil);
	
	if (!isXmppConnected) {
		DEBUG_LOG_XMPP(@"Unable to connect to server. Check xmppStream.hostName");
	}
}
//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    DEBUG_LOG_XMPP(nil);
    [self goOnline];
}
//验证失败后调用
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
	DEBUG_LOG_XMPP(nil);
}
//好友花名册 
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	DEBUG_LOG_XMPP(nil);
	
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                
//                <item subscription="both" name="admin" jid="admin@ddfmac.local">
//                  <group>联系人列表</group>
//                </item>
                
//                NSString *jid = [item attributeStringValueForName:@"jid"];
//                XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
//                [self.roster addObject:xmppJID];
            }
        }
    }
    
	return NO;
}
//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    DEBUG_LOG_XMPP(@"message = %@", message);
    
    if ([message isChatMessageWithBody]) {
		XMPPUserCoreDataStorageObject *user = [_xmppRosterStorage userForJID:[message from]
                                                                  xmppStream:_xmppStream
                                                        managedObjectContext:[self managedObjectContext_roster]];
		
		NSString *body = [[message elementForName:@"body"] stringValue];
//        NSString *from = [[message attributeForName:@"from"] stringValue];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:body forKey:@"message"];
        [dict setObject:user.jidStr forKey:@"from"];
        [dict setObject:[NSDate date] forKey:@"time"];
        //消息委托
        if ([self.messageDelegate respondsToSelector:@selector(newMessageReceived:)]) {
            [self.messageDelegate newMessageReceived:dict];
        }
        
		if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
//                                                                message:body
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//			[alertView show];
		}
		else {
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",user.displayName,body];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
	}
}
//接受到好友状态更新 
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
//    DEBUG_LOG_XMPP(@"presence = %@", presence);
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            
        }
        
    }
    /*
     none   表示用户和contact之前没有任何的关系（虽然在server的buddy list中存在）；
     to     表示用户能看到contact的presence，但是contact看不到用户的Presence；
     from   和to的含义相反，指用户看不到contact的presence，但是contact可以看到；
     both   表示相关之间都能看到对方的presence。
     */
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error {
	 DEBUG_LOG_XMPP(nil);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//添加后，好友收到消息，好友同意 有如下回调 
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    DEBUG_LOG_XMPP(nil);
	
	XMPPUserCoreDataStorageObject *user = [_xmppRosterStorage userForJID:[presence from]
                                                              xmppStream:_xmppStream
                                                    managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare]) {
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else {
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else {
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
}
/*
//处理加好友回调,加好友
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
}
*/


#pragma mark - message archiving
- (BOOL)configureWithParent:(XMPPMessageArchiving *)aParent queue:(dispatch_queue_t)queue {
    DEBUG_LOG_FUN;
    return [_xmppMessageArchivingStorage configureWithParent:aParent queue:queue];
}
- (void)archiveMessage:(XMPPMessage *)message outgoing:(BOOL)isOutgoing xmppStream:(XMPPStream *)stream {
    DEBUG_LOG_FUN;
    [_xmppMessageArchivingStorage archiveMessage:message outgoing:isOutgoing xmppStream:stream];
}

//- (void)setPreferences:(NSXMLElement *)prefs forUser:(XMPPJID *)bareUserJid;
//- (NSXMLElement *)preferencesForUser:(XMPPJID *)bareUserJid;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSManagedObjectContext *)managedObjectContext_roster {
	return [_xmppRosterStorage mainThreadManagedObjectContext];
}
- (NSManagedObjectContext *)managedObjectContext_capabilities {
	return [_xmppCapabilitiesStorage mainThreadManagedObjectContext];
}
- (NSManagedObjectContext *)managedObjectContext_messageArchiving {
    return [_xmppMessageArchivingStorage mainThreadManagedObjectContext];
}

@end








