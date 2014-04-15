//
//  VideoDetailViewController.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "DiscussViewController.h"
#import "UMSocial.h"
#import "SDWebImageManager.h"
#import "DDFSegmentControl.h"
#import "VideoCell.h"
#import "UITableViewCell+Nib.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"

#import "DataCenter.h"
#import "LoginViewController.h"
#import "NetworkCenter.h"
#import "NETRequest_Video.h"
#import "NETResponse_Video.h"
#import "NETRequest_Media_Collect.h"
#import "NETRequest_Media_UnCollect.h"
#import "NETRequest_Media_Like.h"
#import "NETRequest_Media_UnLike.h"

#import <MediaPlayer/MediaPlayer.h>

static NSString *baseVideoUrl = @"http://yuntv.letv.com/bcloud.html?";


@interface VideoDetailViewController ()
<
  NetworkCenterDelegate,
  DDFSegmentControlDelegate,
  UMSocialUIDelegate,
  UIWebViewDelegate
>
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIImageView *toolImageView;
@property (nonatomic, weak) IBOutlet UIButton *collectionButton;
@property (nonatomic, weak) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet DDFSegmentControl *segmentControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_2;


@property (nonatomic, strong) NETResponse_Video *videoDetail;
@property (nonatomic, strong) NSNumber *videoId;
@end

@implementation VideoDetailViewController

- (id)initWithVideoId:(NSNumber *)videoId {
    self = [super initFromNib];
    if (self) {
        self.videoId = videoId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"视频";
    [self setRightButton];
    
    UIImage *image = [UIImage imageNamed:@"toolbar_back.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 1, 1, 1)];
    self.toolImageView.image = image;
    
    self.segmentControl.titles = @[@"详情" ,@"相关"];
    
    self.webView.layer.cornerRadius = 3;
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView setMediaPlaybackRequiresUserAction:NO];
    self.webView.allowsInlineMediaPlayback = YES;
    
    if (self.videoDetail) {
        [self loadDateToView];
    }else {
        [self requestData];
        [self showLoadingViewBelow:nil];
    }
    
    self.scrollView_1.hidden = NO;
    self.scrollView_2.hidden = YES;
    
    
    [NOTI_CENTER addObserver:self
                    selector:@selector(exitFullScreen)
                        name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                      object:nil];
    [NOTI_CENTER addObserver:self
                    selector:@selector(enterFullScreen)
                        name:@"UIMoviePlayerControllerDidEnterFullscreenNotification"
                      object:nil];
}
- (void)dealloc {
    [NOTI_CENTER removeObserver:self];
}

- (void)clickLoadingViewToRefresh {
    [self requestData];
}


#pragma mark - actions
- (IBAction)discussButtonPressed:(id)sender {
    DiscussViewController *discuss = [[DiscussViewController alloc] initWithArticleId:self.videoId type:@"4"];
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
        __weak VideoDetailViewController *wself = self;
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
        __weak VideoDetailViewController *wself = self;
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
    
    [self showHUDTitle:nil];
    __weak VideoDetailViewController *wself = self;
    
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.videoDetail.coverPhoto]
                                               options:SDWebImageLowPriority|SDWebImageRetryFailed
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                
                                                 [self hideHUD:0];
                                                 
                                                 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
                                                 [UMSocialConfig setWXAppId:kWeixinAppID url:wself.videoDetail.link];
                                                 [UMSocialConfig setQQAppId:kQQAppKey url:wself.videoDetail.link importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
                                                 
                                                 NSString *shareText = [NSString stringWithFormat:@"%@\n%@",
                                                                        wself.videoDetail.videoName,
                                                                        wself.videoDetail.link];
                                                 
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
- (void)playButtonPressed:(UIButton *)button {
    
    NSString *videoStr = [NSString stringWithFormat:@"%@%@&auto_play=1&gpcflag=1&width=304&height=203", baseVideoUrl, self.videoDetail.videoUrl];
    NSURL *url = [NSURL URLWithString:videoStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Video" ofType:@"html"];
//    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
//    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - private
- (void)requestData {
    NETRequest_Video *req = [[NETRequest_Video alloc] init];
    [req loadVideoId:self.videoId];
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_VIDEO
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestAddCollection {
    NETRequest_Media_Collect *req = [[NETRequest_Media_Collect alloc] init];
    [req loadMediaId:self.videoId type:@"4"];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_COLLECT
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestDeleCollection {
    NETRequest_Media_UnCollect *req = [[NETRequest_Media_UnCollect alloc] init];
    [req loadMediaId:self.videoId type:@"4"];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_DELE_COLLECT
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestAddLike {
    NETRequest_Media_Like *req = [[NETRequest_Media_Like alloc] init];
    [req loadMediaId:self.videoId type:@"4"];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_LIKE
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestDeleLike {
    NETRequest_Media_UnLike *req = [[NETRequest_Media_UnLike alloc] init];
    [req loadMediaId:self.videoId type:@"4"];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_DELE_LIKE
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}

- (void)setRightButton {
    if (!self.videoDetail) {
        self.navigationBar.rightBarButton = nil;
        return;
    }
    UIImage *image = [UIImage imageNamed:@"page_detail_comment.png"];
    CGSize size = image.size;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 30, 5, 5)];
    NSString *discuss = [NSString stringWithFormat:@"评论 %d", [self.videoDetail.commentNum integerValue]];
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
- (void)loadWebViewPlayButton {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.webView.bounds];
    [imageView setImageWithURL:[NSURL URLWithString:self.videoDetail.coverPhoto]];
    imageView.tag = 1234;
    [self.webView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 54, 54);
    button.tag = 1235;
    [button setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
    button.center = self.webView.center;
    [self.webView addSubview:button];
    [button addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)loadDateToView {
    self.titleLabel.text = self.videoDetail.videoName;
    self.timeLabel.text = self.videoDetail.publishTime;
    self.numberLabel.text = [self.videoDetail.pv stringValue];
    self.detailLabel.text = self.videoDetail.videoSynopsis;
    
    CGSize size = [self.videoDetail.videoSynopsis sizeWithFont:self.detailLabel.font
                                             constrainedToSize:CGSizeMake(self.detailLabel.frame.size.width, MAXFLOAT)];
    CGRect frame = self.detailLabel.frame;
    frame.size.height = size.height;
    self.detailLabel.frame = frame;
    self.scrollView_1.contentSize = CGSizeMake(self.scrollView_1.frame.size.width, frame.origin.x+frame.size.height + 10);
    
    [self loadCollectionScrollView];

    [self loadWebViewPlayButton];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Video" ofType:@"html"];
//    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
//    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    
    [self setRightButton];
    
    if ([self.videoDetail.favoriteFlag isEqualToString:@"true"]) self.collectionButton.selected = YES;
    else self.collectionButton.selected = NO;
    
    if ([self.videoDetail.enjoyFlag isEqualToString:@"true"]) self.likeButton.selected = YES;
    else self.likeButton.selected = NO;
}
- (void)loadCollectionScrollView {
    [self.scrollView_2.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!self.videoDetail.recommendList || !self.videoDetail.recommendList.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.scrollView_2.bounds];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"没有相关推荐";
        label.textColor = kRGBColor(100, 100, 100);
        label.textAlignment = UITextAlignmentCenter;
        [self.scrollView_2 addSubview:label];
        self.scrollView_2.contentSize = self.scrollView_2.frame.size;
        return;
    }
    
    for (int i = 0; i < self.videoDetail.recommendList.count; i++) {
        NETResponse_Video_Recommen *data = self.videoDetail.recommendList[i];
        
        CGRect frame = CGRectMake((i%2) ? 164 : 8, (i>1 ? 110 : 0) + 8, 149, 102);
        
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 3;
        backView.clipsToBounds = YES;
        [self.scrollView_2 addSubview:backView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectInset(backView.bounds, 4, 4);
        button.tag = i;
        [button setImageWithURL:[NSURL URLWithString:data.coverPhoto] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(collectionVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height-40, button.frame.size.width, 40)];
        back.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        back.userInteractionEnabled = NO;
        [button addSubview:back];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(back.bounds, 4, 2)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.text = data.videoName;
        [back addSubview:label];
    }
    
    float contentHeight = 0;
    if (self.videoDetail.recommendList.count > 2) {
        contentHeight = 220;
    }else if (self.videoDetail.recommendList.count > 0) {
        contentHeight = 110;
    }
    self.scrollView_2.contentSize = CGSizeMake(self.scrollView_2.frame.size.width, contentHeight);
}

- (void)collectionVideoPressed:(UIButton *)button {
    int tag = button.tag;
    
    NETResponse_Video_Recommen *result = self.videoDetail.recommendList[tag];
    
    VideoDetailViewController *video = [[VideoDetailViewController alloc] initWithVideoId:result.videoId];
    [self.navigationController pushViewController:video animated:YES];
}

- (void)exitFullScreen {
    [self.segmentControl setPercent:.5];
    self.scrollView_1.hidden = YES;
    self.scrollView_2.hidden = NO;
}
- (void)enterFullScreen {
    NSLog(@"%s", __func__);
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


#pragma mark - segment
- (void)DDFSegmentPressedIndex:(int)index {
    if (index == 0) {
        self.scrollView_1.hidden = NO;
        self.scrollView_2.hidden = YES;
    }else {
        self.scrollView_1.hidden = YES;
        self.scrollView_2.hidden = NO;
    }
}


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_MEDIA_VIDEO]) {
        
        [self hideLoadingView];
        
        NETResponse_Video *rsp = [[NETResponse_Video alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_DATA];
        rsp.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        self.videoDetail = rsp;
        [self loadDateToView];
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_LIKE]) {
        [HUD showText:@"添加喜欢成功" image:[UIImage imageNamed:@"detail_tool_like2.png"] autoHide:YES];
    
        self.likeButton.selected = YES;
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_DELE_LIKE]) {
        [HUD showText:@"取消喜欢成功" image:[UIImage imageNamed:@"picture_enjoy.png"] autoHide:YES];
        
        self.likeButton.selected = NO;
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_COLLECT]) {
        [HUD showText:@"添加收藏成功" image:[UIImage imageNamed:@"detail_tool_collect2.png"] autoHide:YES];
        
        self.collectionButton.selected = YES;
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_DELE_COLLECT]) {
        [HUD showText:@"取消收藏成功" image:[UIImage imageNamed:@"picture_collect.png"] autoHide:YES];
        
        self.collectionButton.selected = NO;
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_MEDIA_VIDEO]) {
        NETResponse_Header *rsp = [[NETResponse_Header alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *error = rsp.rspDesc.length ? rsp.rspDesc : @"没有数据";
        [HUD showFaceText:error];
        
        [self setLoadingFail];
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_LIKE] ||
             [port isEqualToString:YFY_NET_PORT_MEDIA_DELE_LIKE] ||
             [port isEqualToString:YFY_NET_PORT_MEDIA_COLLECT] ||
             [port isEqualToString:YFY_NET_PORT_MEDIA_DELE_COLLECT]) {
        
        NETResponse_Header *res = [[NETResponse_Header alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:res.rspDesc];
    }
}

#pragma mark - webview
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    UIView *bt = [self.webView viewWithTag:1235];
    [bt removeFromSuperview];
    
    UIView *im = [self.webView viewWithTag:1234];
    [im removeFromSuperview];
}

@end
