//
//  NetworkMacros.h
//  JingXiang
//
//  Created by xiaohuzhu on 13-1-25.
//
//

#ifndef YFY_NetworkMacros_h
#define YFY_NetworkMacros_h

//request tag keys
#define YFY_NET_REQUEST_RECEIVER    @"receiver"
#define YFY_NET_REQUEST_TAG         @"tag"
#define YFY_NET_REQUEST_CODE        @"code"
#define YFY_NET_REQUEST_PORT        @"port"

//code
#define YFY_NET_CODE_USER_INFO          @"INTER00001"
#define YFY_NET_CODE_LOGIN              @"INTER00002" //account/login
#define YFY_NET_CODE_REGISTER           @"INTER00003"
#define YFY_NET_CODE_FIRST_PAGE_HEADER  @"INTER00004"
#define YFY_NET_CODE_FIRST_PAGE         @"INTER00005"
#define YFY_NET_CODE_CHANNEL_PAGE       @"INTER00006"
#define YFY_NET_CODE_ADD_DISSCUSS       @"INTER00007"
#define YFY_NET_CODE_DELE_DISSCUSS      @"INTER00008"
#define YFY_NET_CODE_MY_DISSCUSS        @"INTER00009"
#define YFY_NET_CODE_REPLY_ME           @"INTER00010"
#define YFY_NET_CODE_ADD_COLLECTION     @"INTER00011"
#define YFY_NET_CODE_DELE_COLLECTION    @"INTER00012"
#define YFY_NET_CODE_COLLECTION         @"INTER00013"
#define YFY_NET_CODE_SEND_MESSAGE       @"INTER00014"
#define YFY_NET_CODE_DELE_MESSAGE       @"INTER00015"
#define YFY_NET_CODE_MESSAGE_LIST       @"INTER00016"
#define YFY_NET_CODE_READ_NOTIF         @"INTER00017"
#define YFY_NET_CODE_READ_PAGE          @"INTER00018"
#define YFY_NET_CODE_RETRIEVE_PASS      @"INTER00019"
#define YFY_NET_CODE_EDIT_USER          @"INTER00020"
#define YFY_NET_CODE_ADD_LIKE           @"INTER00021"
#define YFY_NET_CODE_DELE_LIKE          @"INTER00022"
#define YFY_NET_CODE_PAGE_DISCUSS       @"INTER00023"
#define YFY_NET_CODE_UPLOAD_IMAGE       @"INTER00024"
#define YFY_NET_CODE_LOGOUT             @"INTER00025"
#define YFY_NET_CODE_DELE_NOTIF         @"INTER00026"
#define YFY_NET_CODE_SINA_LOGIN         @"INTER00027"
#define YFY_NET_CODE_TENCENT_LOGIN      @"INTER00028"
#define YFY_NET_CODE_OFF_LINE           @"INTER00030"
#define YFY_NET_CODE_SEARCH_ARTICLE     @"INTER00031"
#define YFY_NET_CODE_SEARCH_USER        @"INTER00032"
#define YFY_NET_CODE_USER_ARTICLE       @"INTER00033"
#define YFY_NET_CODE_MESSAGE_CHAT       @"INTER00034"
#define YFY_NET_CODE_REGISTER_DEVICE    @"INTER00035"


//port
#define YFY_NET_PORT_USER_INFO          @"account/getUserInfo"
#define YFY_NET_PORT_LOGIN              @"account/login"
#define YFY_NET_PORT_REGISTER           @"account/registe"
#define YFY_NET_PORT_FIRST_PAGE_HEADER  @"article/queryStickArticle"
#define YFY_NET_PORT_FIRST_PAGE         @"category/queryIndexChannelArticle"
#define YFY_NET_PORT_CHANNEL_PAGE       @"category/code"
#define YFY_NET_PORT_ADD_DISSCUSS       @"comment/commentObject"
#define YFY_NET_PORT_DELE_DISSCUSS      @"comment/deleteComment"
#define YFY_NET_PORT_MY_DISSCUSS        @"comment/mycomment"
#define YFY_NET_PORT_REPLY_ME           @"comment/replyOfComment"
#define YFY_NET_PORT_ADD_COLLECTION     @"article/collect"
#define YFY_NET_PORT_DELE_COLLECTION    @"article/uncollect"
#define YFY_NET_PORT_COLLECTION         @"article/favoriteArticle"
#define YFY_NET_PORT_SEND_MESSAGE       @"profile/sendLetter"
#define YFY_NET_PORT_DELE_MESSAGE       @"profile/deleteUserLetter"
#define YFY_NET_PORT_MESSAGE_LIST       @"profile/letterPager"
#define YFY_NET_PORT_READ_NOTIF         @"profile/noticeData"
#define YFY_NET_PORT_READ_PAGE          @"article"
#define YFY_NET_PORT_RETRIEVE_PASS      @"account/findPwd"
#define YFY_NET_PORT_EDIT_USER          @"account/updateUserInfo"
#define YFY_NET_PORT_ADD_LIKE           @"article/like"
#define YFY_NET_PORT_DELE_LIKE          @"article/unlike"
#define YFY_NET_PORT_PAGE_DISCUSS       @"comment/commentOfArticle"
#define YFY_NET_PORT_UPLOAD_IMAGE       @"account/uploadImage"
#define YFY_NET_PORT_LOGOUT             @"account/logout"
#define YFY_NET_PORT_DELE_NOTIF         @"profile/deleteNotice"
#define YFY_NET_PORT_SINA_LOGIN         @"account/weiboLogin"
#define YFY_NET_PORT_TENCENT_LOGIN      @"account/qqLogin"
#define YFY_NET_PORT_OFF_LINE           @"category/downloadArticle"
#define YFY_NET_PORT_SEARCH_ARTICLE     @"search/article"
#define YFY_NET_PORT_SEARCH_USER        @"search/user"
#define YFY_NET_PORT_USER_ARTICLE       @"article/published"
#define YFY_NET_PORT_MESSAGE_CHAT       @"profile/letterRecord"
#define YFY_NET_PORT_REGISTER_DEVICE    @"account/registeDevice"
#define YFY_NET_PORT_PICTURE_INDEX      @"pix/index"
#define YFY_NET_PORT_PICTURE            @"pix/"
#define YFY_NET_PORT_MEDIA_COLLECT      @"richMedia/collect"
#define YFY_NET_PORT_MEDIA_DELE_COLLECT @"richMedia/uncollect"
#define YFY_NET_PORT_MEDIA_LIKE         @"richMedia/like"
#define YFY_NET_PORT_MEDIA_DELE_LIKE    @"richMedia/unlike"
#define YFY_NET_PORT_MEDIA_DISCUSS      @"comment/rmcomment/data"
#define YFY_NET_PORT_MEDIA_VIDEO_INDEX  @"video/index"
#define YFY_NET_PORT_MEDIA_VIDEO        @"video/"
#define YFY_NET_PORT_SEARCH_MEDIA       @"search/media"
#define YFY_NET_PORT_MEDIA_READ_COLLECT @"richMedia/favoriteMedia"


//REQ
#define YFY_NET_REQ_HEADER      @"reqHeader"
#define YFY_NET_REQ_CODE        @"reqCode"
#define YFY_NET_REQ_TIME        @"reqTime"
#define YFY_NET_REQ_TRANSACTION @"transactionId"
#define YFY_NET_REQ_TOKEN       @"tokenId"
/*
 {
     "reqHeader": {
         "reqCode": "INTER00001",
         "reqTime": "20130105121212",
         "tokenId": "00fbe80b-08fb-4a2d-8ed9-33ccc78ddfce",
         "transactionId": "123456789"
     }
 }
 */

//res
#define YFY_NET_RSP_HEADER      @"rspHeader"
#define YFY_NET_RSP_CODE        @"rspCode"
#define YFY_NET_RSP_REQ_CODE    @"reqCode"
#define YFY_NET_RSP_DESC        @"rspDesc"
#define YFY_NET_RSP_TIME        @"rspTime"
#define YFY_NET_RSP_TRANSACTION @"transactionId"
/*
{
    "rspHeader": {
        "reqCode": "INTER00001",
        "rspCode": "00000000",
        "rspDesc": "成功",
        "rspTime": "20130131132431",
        "transactionId": "123456789"
    }
}
*/

#define YFY_NET_PARAM   @"param"
#define YFY_NET_DATA    @"data"


#define YFY_NET_ERROR_CODE_SUCC @"00000000" //请求成功

//系统
//10100001	请求报文参数缺失
//10100002	请求报文参数格式错误
//10100003	用户token不存在或已过期
//10100004	authCode认证失败
//10100005	用户没有登录
//10100006	服务器业务接口调用异常

//终端
//10200001	缺失证书号
//10200002	缺失终端标识
//10200003	缺失apkCode
//10200004	缺失apkType
//10200005	缺失apkVersion
//10200006	终端组件规格不存在
//10200007	缺失厂商
//10200008	缺失终端版本ID
//10200009	无效的APK CODE
//10200010	缺失个人终端标识
//10200011	缺失操作系统类型
//10200012	缺失软件版本
//10200013	缺失终端设备类型
//10200014	操作系统格式错误
//10200015	操作系统格式错误
//10200016	终端设备类型格式错误
//10200017	颜色格式不匹配
//10200018	3G标准不匹配
//10200019	出厂日期格式不匹配
//10200020	尺寸单位格式不匹配
//10200021	分辨率格式不匹配
//10200022	重力感应格式不匹配
//10200023	触摸感应格式不匹配
//10200024	WIFI格式不匹配
//10200025	ios访问扩展标识错误

//文章
//10300001	商品ID缺失
//10300002	是否赠送标识缺失
//10300003	商品ID参数错误
//10300004	是否赠送标识参数错误
//10300005	当前用户ID错误
//10300006	缺失设备证书号
//10300007	缺失内容列表
//10300008	缺失内容项
//10300009	缺失内容的Guid
//10300010	根据Guid没有找到内容数据
//10300101	获取赠送列表分页验证失败
//10300102	订阅编号缺失
//10300103	商品类型错误
//10300104	交付单编号缺失
//10300109	该客户端无商品可赠
//10300110	该商品已下架

//用户
//10400001	用户账号为空
//10400002	用户密码为空
//10400003	用户密码或密码错误
//10400004	用户注册类型参数缺失
//10400005	分页结束参数格式错误
//10400006
//10400007	图片内容编码参数缺失
//10400008	图片上传格式参数缺失
//10400009	图片格式参数非法
//10400102	email参数缺失
//10400103	email参数格式错误
//10400104	电话号码参数缺失
//10400105	电话号码参数格式错误
//10400106	QQ参数缺失
//10400107	QQ参数格式错误
//10400108	性别参数缺失
//10400109	性别参数格式错误
//10400110	姓名参数缺失
//10400111	昵称参数缺失
//10400112	更新个人信息失败
//10400113	查询用户信息失败
//10400114	关注的V8列表请求信息中V8Info节点缺失
//10400201	处理类型参数错误
//10400202	微吧信息顶级操作参数缺失
//10400203	微吧ID参数错误
//10400204	留言信息顶级操作参数缺失
//10400205	留言对象ID参数错误
//10400206	留言内容为空
//10400207	留言ID参数错误
//10400208	用户信息顶级参数缺失
//10400209	好友标识错误
//10400210	分享信息顶级参数缺失
//10400211	分享对象ID错误
//10400212	分享类型为空或错误
//10400213	分享内容为空
//10400214	分享来源错误
//10400215	分享对象信息为空
//10400216	分享内容标识错误
//10400217	回复内容为空
//10400218	屏蔽动态失败
//10400219	通讯录上传条数为0
//10400221	回复ID为空
//10400222	动态ID为空
//10400223	对象不存在
//10400224	搜索微吧顶级参数缺失
//10400225	搜索类型参数错误
//10400226	搜索文号参数错误
//10400227	搜索昵称参数错误
//10400228	指定好友ID错误
//10400229	分享对象ID类型错误
//10400230	收藏信息顶级参数缺失
//10400233	名师顶级操作参数缺失
//10400234	名师列表来源参数缺失
//10400235	名师列表来源参数错误
//10400236	微吧ID缺失
//10400237	课程ID缺失
//10400238	他（我）的微吧顶级参数缺失
//10400239	他（我）的请求微吧ID缺失
//10400240	推荐到第三方失败
//10400243	动态不存在或已删除
//10400301	微吧广场顶层操作参数缺失
//10400302	微吧广场顶层操作参数格式错误
//10400303	微吧广场次级操作参数缺失
//10400304	微吧广场次级操作参数格式错误
//10400401	动态回复或@提醒顶级参数缺失
//10400402	动态回复最后查看时间缺失
//10400403	查询类型无效
//10400404	最后查看时间缺失
//10400406	图片路径不存在
//10700101	登录名为空
//10700102	密码为空
//10700103	登录失败！登录名或密码不正确
//10700104	用户邮箱为空
//10700105	用户手机号为空
//10700106	用户类型为空
//10700107	用户密码为空
//10700108	验证码为空
//10700109	用户名已存在
//10700110	真实姓名为空
//10700113	登录类型为空
//10700114	登录类型格式错误
//10700115	用户不存在
//10700116	注册前请先调用验证码生成接口
//10700117	验证码为空
//10700118	验证码与服务器端不匹配
//10700119	原密码为空
//10700120	原密码错误
//10700121	新密码为空
//10700122	微吧名字为空
//10700123	微吧名称已存在
//10700124	第三方平台标识为空
//10700125	第三方平台标识不匹配
//10700126	访问权限token为空
//10700127	失效时间为空
//10700128	第三方平台用户标识为空
//10700129	绑定类型为空
//10700130	绑定类型不匹配
//10700131	随学用户类型错误
//10700132	第三方注册绑定不能解绑
//10700133	未找到绑定的第三方，可能已经解绑


#endif
