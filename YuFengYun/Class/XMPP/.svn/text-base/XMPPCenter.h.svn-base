//
//  XMPPCenter.h
//  XMPPTest
//
//  Created by 董德富 on 13-6-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

#define XMPP_CENTER [XMPPCenter center]


@protocol XMPPCenterMessageDelegate <NSObject>
@optional
- (void)newMessageReceived:(NSDictionary *)dic;
@end


@interface XMPPCenter : NSObject


@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

@property (nonatomic, strong, readonly) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;


@property (nonatomic, weak) id<XMPPCenterMessageDelegate> messageDelegate;

+ (id)center;
//是否连接
- (BOOL)xmppConnect;
//断开连接
- (void)disconnect;
//好友花名册
- (void)queryRoster;
//添加好友
- (void)addBuddy:(NSString *)jid nickName:(NSString *)nickName;
//删除好友,取消加好友，或者加好友后需要删除
- (void)removeBuddy:(NSString *)jidString;
//发送消息
- (void)sendMessage:(NSString *)message to:(NSString *)chatUser;


//数据库
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSManagedObjectContext *)managedObjectContext_messageArchiving;


@end

/*
 XEP-0009        在两个XMPP实体间传输XML-RPC编码请求和响应
 XEP-0006        使能与网络上某个XMPP实体间的通信
 XEP-0045        多人聊天相关协议
 XEP-0054        名片格式的标准文档
 XEP-0060        提供通用公共订阅功能
 XEP-0065        两个XMPP用户之间建立一个带外流，主要用于文件传输
 XEP-0082        日期和时间信息的标准化表示
 XEP-0085        聊天对话中通知用户状态
 XEP-0100        表述了XMPP客户端与提供传统的IM服务的代理网关之间交换的最佳实践
 XEP-0115        广播和动态发现客户端、设备、或一般实体能力。
 XEP-0136        为服务端备份和检索XMPP消息定义机制和偏好设置
 XEP-0153        用于交换用户头像
 XEP-0184        消息送达回执协议
 XEP-0199        XMPP ping 协议
 XEP-0202        用于交换实体间的本地时间信息
 XEP-0203        用于延迟发送
 XEP-0224        引起另一个用户注意的协议
 */

/*
 一、注册
    XEP-0077   In-Band Registration     http://www.xmpp.org/extensions/xep-0077.html
 
 二、登录
    XEP-0020    Software Version        http://www.xmpp.org/extensions/xep-0092.html

 三、好友列表
    1、获取好友列表
    XEP-0083    Nested Roster Groups    http://www.xmpp.org/extensions/xep-0083.html
    2、存储好友列表
    XEP-0049    Private XML Storage     http://www.xmpp.org/extensions/xep-0049.html
    3、备注好友信息
    XEP-0145    Annotations             http://www.xmpp.org/extensions/xep-0145.html
    4、存储书签
    XEP-0048    Bookmark Storage        http://www.xmpp.org/extensions/xep-0048.html
    5、好友头像
    XEP-0008    IQ-Based Avatars        http://www.xmpp.org/extensions/xep-0008.html
    XEP-0084    User Avatar             http://www.xmpp.org/extensions/xep-0084.html
    XEP-0054    vcard-temp              http://www.xmpp.org/extensions/xep-0054.html

 四、用户状态
    RFC-3921    Subscription States     http://www.ietf.org/rfc/rfc3921.txt

 五、文本消息
    1、在线消息
    2、离线消息
    XEP-0013    Flexible Offline Message Retrieval              http://www.xmpp.org/extensions/xep-0013.html
    XEP-0160    Best Practices for Handling Offline Messages    http://www.xmpp.org/extensions/xep-0160.html
    XEP-0203    Delayed Delivery                                http://www.xmpp.org/extensions/xep-0203.html
    3、聊天状态通知
    XEP-0085    Chat State Notifications                        http://www.xmpp.org/extensions/xep-0085.html
 
 六、群组聊天
    1、XEP-0045      Multi-User Chat                     http://www.xmpp.org/extensions/xep-0045.html

 七、文件传输
    1、XEP-0095      Stream Initiation                   http://www.xmpp.org/extensions/xep-0095.html
    2、XEP-0096      File Transfer                       http://www.xmpp.org/extensions/xep-0096.html
    3、XEP-0065      SOCKS5 Bytestreams                  http://www.xmpp.org/extensions/xep-0065.html
    4、XEP-0215      STUN Server Discovery for Jingle    http://www.xmpp.org/extensions/xep-0215.html
    5、RFC-3489      STUN                                http://tools.ietf.org/html/rfc3489
 
 八、音视频会议
    1、XEP-0166      Jingle                              http://www.xmpp.org/extensions/xep-0166.html#negotiation
    2、XEP-0167      Jingle Audio via RTP                http://www.xmpp.org/extensions/xep-0167.html
    3、XEP-0176      Jingle ICE Transport                http://www.xmpp.org/extensions/xep-0176.html
    4、XEP-0180      Jingle Video via RTP                http://www.xmpp.org/extensions/xep-0180.html#negotiation
    5、XEP-0215      STUN Server Discovery for Jingle    http://www.xmpp.org/extensions/xep-0215.html
    6、RFC-3489      STUN                                http://tools.ietf.org/html/rfc3489
 
 九、用户查询
    XEP-0055        Jabber Search       http://www.xmpp.org/extensions/xep-0055.html
 
 
 整体：
 
 一、协议数据交互
    XEP-0004        Data Forms          http://www.xmpp.org/extensions/xep-0004.html
 
 二、jabber-RPC
    XEP-0009        Jabber-RPC          http://www.xmpp.org/extensions/xep-0009.html

 三、功能协商
    XEP-0020        Feature Negotiation http://www.xmpp.org/extensions/xep-0020.html

 四、服务发现
    XEP-0030        Service Discovery   http://www.xmpp.org/extensions/xep-0030.html

 五、会话建立
    XEP-0116        Encrypted Session Negotiation       http://www.xmpp.org/extensions/xep-0116.html
    XEP-0155        Stanza Session Negotiation          http://www.xmpp.org/extensions/xep-0155.html
    XEP-0201        Best Practices for Message Threads  http://www.xmpp.org/extensions/xep-0201.html
 */


