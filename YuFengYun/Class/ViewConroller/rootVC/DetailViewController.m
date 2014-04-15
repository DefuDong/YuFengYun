//
//  DetailViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-25.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "DiscussViewController.h"
#import "LoginViewController.h"
//#import "ShareCenter.h" //share
#import "UMSocial.h"
#import <MessageUI/MessageUI.h>
#import "UserInfoViewController.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_PageDetail.h"
#import "NETResponse_PageDetail.h"
#import "NETResponse_Login.h"
#import "NETRequest_AddLike.h"
#import "NETResponse_AddLike.h"
#import "NETRequest_DeleLike.h"
#import "NETResponse_DeleLike.h"
#import "NETRequest_AddCollection.h"
#import "NETResponse_AddCollection.h"
#import "NETRequest_DeleCollection.h"
#import "NETResponse_DeleCollection.h"

#import "DBManager.h"
#import "SDWebImageManager.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "TSMiniWebBrowser.h"

@interface DetailViewController ()
<
  UIWebViewDelegate,
  NetworkCenterDelegate,
  UIActionSheetDelegate,
  ASIHTTPRequestDelegate,
  MFMailComposeViewControllerDelegate,
  MFMessageComposeViewControllerDelegate,
  UMSocialUIDelegate,
  UIScrollViewDelegate
>
{
    //tool bar
    BOOL _isDraging;
    CGPoint _perPiont;
    BOOL _isHidden;
}
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIView *toolView;

@property (nonatomic, weak) IBOutlet UIImageView *toolImageView;
@property (nonatomic, weak) IBOutlet UIButton *collectionButton;
@property (nonatomic, weak) IBOutlet UIButton *likeButton;


@property (nonatomic, strong) NSNumber *articleId;
@property (nonatomic, strong) NETResponse_PageDetail *pageDetail;

@property (nonatomic, assign) BOOL shouldShowAlert;
@end

@implementation DetailViewController

- (id)initWithArticleId:(NSNumber *)articleId {
    self = [super initFromNib];
    if (self) {
        self.articleId = articleId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"新闻";
    
    self.webView.scrollView.delegate = self;
    for (UIView *shadowView in [self.webView.scrollView subviews]) {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
            shadowView.hidden = YES;
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"toolbar_back.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 1, 1, 1)];
    self.toolImageView.image = image;
    
    //load data
    if (self.pageDetail) {
        NSString *htmlString = [DATA pageDetailWithData:self.pageDetail sizeType:[DATA pageTextType]];
        [self.webView loadHTMLString:htmlString baseURL:nil];
        
        if ([self.pageDetail.favoriteFlag isEqualToString:@"true"]) self.collectionButton.selected = YES;
        else self.collectionButton.selected = NO;
        
        if ([self.pageDetail.enjoyFlag isEqualToString:@"true"]) self.likeButton.selected = YES;
        else self.likeButton.selected = NO;
        
        [self setRightButton];
    }else {
        NETResponse_PageDetail *offline = [DB pageDetailWithID:self.articleId tableName:nil];
        if (offline) {
            self.pageDetail = offline;
            
            NSString *htmlString = [DATA pageDetailWithData:self.pageDetail sizeType:[DATA pageTextType]];
            [self.webView loadHTMLString:htmlString baseURL:nil];
            
            if ([offline.favoriteFlag isEqualToString:@"true"]) self.collectionButton.selected = YES;
            else self.collectionButton.selected = NO;
            
            if ([offline.enjoyFlag isEqualToString:@"true"]) self.likeButton.selected = YES;
            else self.likeButton.selected = NO;
            
            [self setRightButton];
        }else {
            [self requestData];
            [self showLoadingViewBelow:self.toolView];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (SYSTEM_VERSION_MOER_THAN_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.shouldShowAlert) {
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:@"分享账号已自动绑定，您可以在”设置-分享账号管理“中解除绑定"
                                   delegate:nil
                          cancelButtonTitle:@"好的"
                          otherButtonTitles:nil, nil] show];
    }
}
- (void)clearMemory {
}
- (void)clickLoadingViewToRefresh {
    [self requestData];
}



#pragma mark - private
- (void)bottomButtonPressed:(UIButton *)button {
    NSArray *recommens = self.pageDetail.recommendList;
    NETResponse_PageDetail_Recommend *recom = [recommens objectAtIndex:button.tag];
    
    DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:recom.articleId];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)requestData {
    NETRequest_PageDetail *page = [[NETRequest_PageDetail alloc] init];
    [page loadUserId:[DATA loginData].userId
           articleId:self.articleId];
    [NET startRequestWithPort:YFY_NET_PORT_READ_PAGE
                         code:YFY_NET_CODE_READ_PAGE
                   parameters:page.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestAddLike {
    NETRequest_AddLike *request = [[NETRequest_AddLike alloc] init];
    [request loadUserId:[DATA loginData].userId articleId:self.articleId];
    
    [NET startRequestWithPort:YFY_NET_PORT_ADD_LIKE
                         code:YFY_NET_CODE_ADD_LIKE
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)requestDeleLike {
    NETRequest_DeleLike *request = [[NETRequest_DeleLike alloc] init];
    [request loadUserId:[DATA loginData].userId articleId:self.articleId];
    
    [NET startRequestWithPort:YFY_NET_PORT_DELE_LIKE
                         code:YFY_NET_CODE_DELE_LIKE
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)requestAddCollection {
    NETRequest_AddCollection *request = [[NETRequest_AddCollection alloc] init];
    [request loadUserId:[DATA loginData].userId articleId:self.articleId];
    [NET startRequestWithPort:YFY_NET_PORT_ADD_COLLECTION
                         code:YFY_NET_CODE_ADD_COLLECTION
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)requestDeleCollection {
    NETRequest_DeleCollection *dele = [[NETRequest_DeleCollection alloc] init];
    [dele loadUserId:[DATA loginData].userId articleId:self.articleId];
    [NET startRequestWithPort:YFY_NET_PORT_DELE_COLLECTION
                         code:YFY_NET_CODE_DELE_COLLECTION
                   parameters:dele.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}

- (void)setRightButton {
    if (!self.pageDetail) {
        self.navigationBar.rightBarButton = nil;
        return;
    }
    UIImage *image = [UIImage imageNamed:@"page_detail_comment.png"];
    CGSize size = image.size;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 30, 5, 5)];
    NSString *discuss = [NSString stringWithFormat:@"评论 %d", [self.pageDetail.articleCommentNum integerValue]];
    CGSize stringSize = [discuss sizeWithFont:[UIFont boldSystemFontOfSize:14]];
    size.width = 37+stringSize.width;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(discussButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButton = button;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, stringSize.width, size.height)];
    label.text = discuss;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [button addSubview:label];
    
    CGRect buttonFrame = button.frame;
    buttonFrame.origin.x = self.view.frame.size.width-buttonFrame.size.width-5;
    buttonFrame.origin.y = self.navigationBar.frame.size.height-buttonFrame.size.height-6;
    button.frame = buttonFrame;
}


#pragma mark - actions
- (IBAction)discussButtonPressed:(id)sender {
    DiscussViewController *discuss = [[DiscussViewController alloc] initWithArticleId:self.articleId type:@"1"];
    [self.navigationController pushViewController:discuss animated:YES];
}
- (IBAction)collectButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if ([DATA isLogin]) {
        if (button.selected) {
            [self requestDeleCollection];
        }else {
            [self requestAddCollection];
        }
    }else {
        __weak DetailViewController *wself = self;
        [LoginViewController login:^(BOOL flag) {
            if (flag) {
                if (button.selected) {
                    [wself requestDeleCollection];
                }else {
                    [wself requestAddCollection];
                }
            }else {
//                [HUD showFaceText:@"登录失败"];
            }
        }];
    }
}
- (IBAction)enjoyButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if ([DATA isLogin]) {
        if (button.selected) {
            [self requestDeleLike];
        }else {
            [self requestAddLike];
        }
    }else {
        __weak DetailViewController *wself = self;
        [LoginViewController login:^(BOOL flag) {
            if (flag) {
                if (button.selected) {
                    [wself requestDeleLike];
                }else {
                    [wself requestAddLike];
                }
            }else {
//                [HUD showFaceText:@"登录失败"];
            }
        }];
    }
}
- (IBAction)shareButtonPressed:(id)sender {
    
    __weak DetailViewController *wself = self;
    [self showHUDTitle:nil];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.pageDetail.articleDeckblatt]
                                               options:SDWebImageLowPriority|SDWebImageRetryFailed
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 [wself hideHUD:0];
                                                 
                                                 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
                                                 [UMSocialConfig setWXAppId:kWeixinAppID url:wself.pageDetail.articleLink];
                                                 [UMSocialConfig setQQAppId:kQQAppKey url:wself.pageDetail.articleLink importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
                                                 
                                                 NSString *shareText = [NSString stringWithFormat:@"%@\n%@\n%@",
                                                                        wself.pageDetail.articleShortTitle,
                                                                        wself.pageDetail.articleSynopsis,
                                                                        wself.pageDetail.articleLink];
                                                 
                                                 NSArray *shareTo = @[UMShareToSina,
                                                                      UMShareToTencent,
                                                                      UMShareToEmail,
                                                                      UMShareToSms,
                                                                      UMShareToWechatSession,
                                                                      UMShareToWechatTimeline,
                                                                      UMShareToQQ,
                                                                      UMShareToQzone];
                                                 //如果得到分享完成回调，需要传递delegate参数
                                                 [UMSocialSnsService presentSnsIconSheetView:wself
                                                                                      appKey:kUMAppKey
                                                                                   shareText:shareText
                                                                                  shareImage:image
                                                                             shareToSnsNames:shareTo
                                                                                    delegate:wself];
                                                 
                                                 
                                             }];
}

static BOOL isTextChanging = NO;
- (IBAction)pinch:(id)sender {
    UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)sender;
    kPageTextSizeType current = [DATA pageTextType];
    if (pinch.state == UIGestureRecognizerStateBegan) {
        isTextChanging = NO;
    }
    else if (pinch.state == UIGestureRecognizerStateChanged) {
        if (isTextChanging) return;
        if (pinch.scale >= 1.2f) {
            isTextChanging = YES;
            switch (current) {
                case kPageTextSizeTypeSmall:
                {
                    [DATA setPageTextType:kPageTextSizeTypeMid];
                    NSString *htmlString = [DATA pageDetailWithData:self.pageDetail sizeType:[DATA pageTextType]];
                    [self.webView loadHTMLString:htmlString baseURL:nil];
                    
                    [HUD showText:@"中号字体"];
                }
                    break;
                case kPageTextSizeTypeMid:
                {
                    [DATA setPageTextType:kPageTextSizeTypeLarge];
                    NSString *htmlString = [DATA pageDetailWithData:self.pageDetail sizeType:[DATA pageTextType]];
                    [self.webView loadHTMLString:htmlString baseURL:nil];
                    
                    [HUD showText:@"大号字体"];
                }
                    break;
                case kPageTextSizeTypeLarge:
                {
                    [HUD showText:@"已经是最大号字体了！"];
                }
                    break;
            }
        }
        else if (pinch.scale <= 0.8) {
            isTextChanging = YES;
            switch (current) {
                case kPageTextSizeTypeSmall:
                {
                    [HUD showText:@"已经是最小号字体了！"];
                }
                    break;
                case kPageTextSizeTypeMid:
                {
                    [DATA setPageTextType:kPageTextSizeTypeSmall];
                    NSString *htmlString = [DATA pageDetailWithData:self.pageDetail sizeType:[DATA pageTextType]];
                    [self.webView loadHTMLString:htmlString baseURL:nil];
                    
                    [HUD showText:@"小号字体"];
                }
                    break;
                case kPageTextSizeTypeLarge:
                {
                    [DATA setPageTextType:kPageTextSizeTypeMid];
                    NSString *htmlString = [DATA pageDetailWithData:self.pageDetail sizeType:[DATA pageTextType]];
                    [self.webView loadHTMLString:htmlString baseURL:nil];
                    
                    [HUD showText:@"中号字体"];
                }
                    break;
            }
        }
    }
}

- (void)dealloc {
   [[NSURLCache sharedURLCache] removeAllCachedResponses];
   NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
   for (NSHTTPCookie *cookie in [storage cookies]) {
      [storage deleteCookie:cookie];
   }
}


#pragma mark - scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _perPiont = scrollView.contentOffset;
    _isDraging = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isDraging = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isDraging) {
        BOOL hideTabBar = scrollView.contentOffset.y > _perPiont.y;
        if (hideTabBar) {
            [self setBarsHide:YES];
        }else {
            [self setBarsHide:NO];
        }
    }
}
- (void)setBarsHide:(BOOL)hide {
    
    if (_isHidden == hide) return;
    
    __block CGRect navFrame = self.navigationBar.frame;
    __block CGRect toolFrame = self.toolView.frame;
    __block CGRect webFrame = self.webView.frame;
    
    float navHeight = navFrame.size.height;
    float toolHeight = toolFrame.size.height;
    float height = self.view.frame.size.height;
    
    BOOL iOS7 = SYSTEM_VERSION_MOER_THAN_7;

    if (hide) {
        [UIView animateWithDuration:.25 animations:^{
            navFrame.origin.y = -navHeight;
            self.navigationBar.frame = navFrame;
            
            toolFrame.origin.y = height;
            self.toolView.frame = toolFrame;
            
            webFrame.origin.y = iOS7 ? 20 : 0;
            webFrame.size.height = iOS7 ? height-20 : height;
            self.webView.frame = webFrame;
        }];
    }else {
        [UIView animateWithDuration:.25 animations:^{
            navFrame.origin.y = 0;
            self.navigationBar.frame = navFrame;
            
            toolFrame.origin.y = height - toolHeight;
            self.toolView.frame = toolFrame;
            
            webFrame.origin.y = navHeight;
            webFrame.size.height = height - navHeight - toolHeight + 2;
            self.webView.frame = webFrame;
        }];
    }
    
    _isHidden = hide;
    _isDraging = NO;
}

//#pragma mark - gesture
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}


#pragma mark - webView
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self hideHUD:0];
    
    
//   [[NSURLCache sharedURLCache] removeAllCachedResponses];
//   NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//   for (NSHTTPCookie *cookie in [storage cookies]) {
//      [storage deleteCookie:cookie];
//   }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *requestString = [url absoluteString];
    NSRange range = [requestString rangeOfString:kLinkTag];
    if (range.location != NSNotFound) {
        NSString *articleId = [requestString substringFromIndex:range.location+range.length];
        NSNumber *articleNum = [NSNumber numberWithInteger:[articleId integerValue]];
        
        DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:articleNum];
        [self.navigationController pushViewController:detail animated:YES];
        
        return NO;
    }
    
    NSRange range2 = [requestString rangeOfString:kLinkNameTag];
    if (range2.location != NSNotFound) {
        NSString *authorId = [requestString substringFromIndex:range2.location+range2.length];
        NSNumber *authorNum = [NSNumber numberWithInteger:[authorId integerValue]];
        
        UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:authorNum];
        [self.navigationController pushViewController:user animated:YES];
        
        return NO;
    }
    
    if ([requestString hasPrefix:@"http://"]) {
        TSMiniWebBrowser *web = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:requestString]];
        [self.navigationController pushViewController:web animated:YES];
        
        return NO;
    }
    
    return YES;
}


#pragma mark - action sheet
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        [HUD showText:@"分享成功"];
    }else {
        NSString *errorMessage = nil;
        switch (response.responseCode) {
            case UMSResponseCodeBaned:
                errorMessage = @"用户被封禁";
                break;
            case UMSResponseCodeFaild:
                errorMessage = @"发送失败(内容不符合要求)";
                break;
            case UMSResponseCodeEmptyContent:
                errorMessage = @"发送内容为空";
                break;
            case UMSResponseCodeShareRepeated:
                errorMessage = @"分享内容重复";
                break;
            case UMSResponseCodeGetNoUidFromOauth:
                errorMessage = @"授权之后没有得到用户uid";
                break;
            case UMSResponseCodeAccessTokenExpired:
                errorMessage = @"token过期";
                break;
            case UMSResponseCodeNetworkError:
                errorMessage = @"网络错误";
                break;
            case UMSResponseCodeGetProfileFailed:
                errorMessage = @"获取账户失败";
                break;
            case UMSResponseCodeCancel:
                errorMessage = @"用户取消授权";
                break;
            case UMSResponseCodeNoApiAuthority:
                errorMessage = @"QQ空间无相册权限";
                break;
                
            default:
                break;
        }
        
        [HUD showFaceText:errorMessage];
    }
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    if (platformName == UMShareToQQ) {
        NSString *shareText = socialData.shareText;
        if (shareText.length >= 128) {
            int synopsisLength = self.pageDetail.articleSynopsis.length - (shareText.length-120);
            NSString *synopsis = [self.pageDetail.articleSynopsis substringToIndex:synopsisLength];
            shareText = [NSString stringWithFormat:@"%@\n%@\n%@",
                         self.pageDetail.articleShortTitle,
                         synopsis,
                         self.pageDetail.articleLink];
            
            socialData.shareText = shareText;
        }
    }
    
    self.shouldShowAlert = NO;
    if (platformName == UMShareToSina || platformName == UMShareToTencent || platformName == UMShareToQzone) {
        if (![UMSocialAccountManager isOauthWithPlatform:platformName]) {
            self.shouldShowAlert = YES;
        }
    }
}


#pragma mark - message & mail
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithReswswxult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [controller dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultSent) {
        [HUD showText:@"邮件发送成功"];
    }else if (result == MFMailComposeResultFailed) {
        [HUD showFaceText:@"邮件发送失败"];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [controller dismissModalViewControllerAnimated:YES];
    if (result == MessageComposeResultSent) {
        [HUD showText:@"短信发送成功"];
    }else if (result == MessageComposeResultFailed) {
        [HUD showFaceText:@"短信发送失败"];
    }
}



#pragma mark - network delegate
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self hideHUD:0];
    if ([port isEqualToString:YFY_NET_PORT_READ_PAGE]) {
        [self hideLoadingView];
        
        NETResponse_PageDetail *pageDetail = [[NETResponse_PageDetail alloc] init];
        pageDetail.responseDic = [dic objectForKey:YFY_NET_DATA];
        pageDetail.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        self.pageDetail = pageDetail;
        
        NSString *htmlString = [DATA pageDetailWithData:self.pageDetail sizeType:[DATA pageTextType]];
        [self.webView loadHTMLString:htmlString baseURL:nil];
        
        if ([pageDetail.favoriteFlag isEqualToString:@"true"]) self.collectionButton.selected = YES;
        else self.collectionButton.selected = NO;
        
        if ([pageDetail.enjoyFlag isEqualToString:@"true"]) self.likeButton.selected = YES;
        else self.likeButton.selected = NO;
        
        [self setRightButton];
    }
    else if ([port isEqualToString:YFY_NET_PORT_ADD_LIKE]) {
        [HUD showText:@"添加喜欢成功" image:[UIImage imageNamed:@"detail_tool_like2.png"] autoHide:YES];
        
        NETResponse_AddLike *res = [[NETResponse_AddLike alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        self.likeButton.selected = YES;
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_LIKE]) {
        [HUD showText:@"取消喜欢成功" image:[UIImage imageNamed:@"detail_tool_like.png"] autoHide:YES];
        
        NETResponse_DeleLike *res = [[NETResponse_DeleLike alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        self.likeButton.selected = NO;
    }
    else if ([port isEqualToString:YFY_NET_PORT_ADD_COLLECTION]) {
        [HUD showText:@"添加收藏成功" image:[UIImage imageNamed:@"detail_tool_collect2.png"] autoHide:YES];
        
        NETResponse_AddCollection *res = [[NETResponse_AddCollection alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        self.collectionButton.selected = YES;
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_COLLECTION]) {
        [HUD showText:@"取消收藏成功" image:[UIImage imageNamed:@"detail_tool_collect.png"] autoHide:YES];
        
        NETResponse_DeleCollection *res = [[NETResponse_DeleCollection alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        self.collectionButton.selected = NO;
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    if ([port isEqualToString:YFY_NET_PORT_READ_PAGE]) {
        [self setLoadingFail];
        NETResponse_Header *rsp = [[NETResponse_Header alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *error = rsp.rspDesc.length ? rsp.rspDesc : @"没有数据";
        [HUD showFaceText:error];
    }
    else if ([port isEqualToString:YFY_NET_PORT_ADD_LIKE]) {
        [self hideHUD:0];
        
        NETResponse_AddLike *res = [[NETResponse_AddLike alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:res.responseHeader.rspDesc];
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_LIKE]) {
        [self hideHUD:0];
        
        NETResponse_DeleLike *res = [[NETResponse_DeleLike alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:res.responseHeader.rspDesc];
    }
    else if ([port isEqualToString:YFY_NET_PORT_ADD_COLLECTION]) {
        [self hideHUD:0];
        
        NETResponse_AddCollection *res = [[NETResponse_AddCollection alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:res.responseHeader.rspDesc];
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_COLLECTION]) {
        [self hideHUD:0];
        
        NETResponse_DeleCollection *res = [[NETResponse_DeleCollection alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:res.responseHeader.rspDesc];
    }
}






@end
