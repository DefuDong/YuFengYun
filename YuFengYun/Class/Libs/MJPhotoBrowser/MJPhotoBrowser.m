//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SDWebImageManager.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"
#import "MJPhotoCollectionView.h"
#import "AlertHUDView.h"
#import "UMSocial.h"
#import "DiscussViewController.h"

#import "DataCenter.h"
#import "LoginViewController.h"
#import "NetworkCenter.h"
#import "NETRequest_Picture.h"
#import "NETResponse_Picture.h"
#import "NETRequest_Media_Collect.h"
#import "NETRequest_Media_UnCollect.h"
#import "NETRequest_Media_Like.h"
#import "NETRequest_Media_UnLike.h"


#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface TopNavView : UIView
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong, readonly) UIButton *discussButton;
- (id)initWithDiscussNum:(NSNumber *)discuss;
@end


@interface MJPhotoBrowser ()
<
  MJPhotoViewDelegate,
  NetworkCenterDelegate,
  MJPhotoCollectionViewDelegate,
  MJPhotoToolbarDelegate,
  UMSocialUIDelegate
>
{
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    MJPhotoToolbar *_toolbar;
    TopNavView *_navBarView;
    MJPhotoCollectionView *_collectView;
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    UIStatusBarStyle _statusBarStyle;
    
    BOOL _barsHidden;
}

@property (nonatomic, strong) NETResponse_Picture *pictureData;

@end

@implementation MJPhotoBrowser

#pragma mark - Lifecycle
- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];
}

- (id)initWithPictures:(NETResponse_Picture *)pic {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.pictureData = pic;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wantsFullScreenLayout = YES;
    self.hidesBottomBarWhenPushed = YES;

    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.pictureData.pictures.count];
    for (NETResponse_Picture_Pictures *pic in self.pictureData.pictures) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:pic.picUrl];
        [photos addObject:photo];
    }
    self.photos = photos;
    
    // 1.创建UIScrollView
    [self createScrollView];
    
    // 2.创建工具条
    [self createToolbar];
    
    //
    [self createImageCollectionView];
    
    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
    
    _navBarView = [[TopNavView alloc] initWithDiscussNum:self.pictureData.commentNum];
    [self.view addSubview:_navBarView];
    [_navBarView.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView.discussButton addTarget:self action:@selector(discussButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (SYSTEM_VERSION_MOER_THAN_7) {
        _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else {
        _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
        // 隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (SYSTEM_VERSION_MOER_THAN_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
    }else {
        [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHiddenInited withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)discussButtonPressed:(id)sender {
    DiscussViewController *discuss = [[DiscussViewController alloc] initWithArticleId:self.pictureData.atlasId type:@"3"];
    [self.navigationController pushViewController:discuss animated:YES];
//#warning discuss
}

#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = kToolBarHeight;
    CGFloat barY = self.view.frame.size.height - barHeight;
    _toolbar = [[MJPhotoToolbar alloc] initWithFrame:CGRectMake(0, barY, self.view.frame.size.width, barHeight)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = _photos;
    _toolbar.delegate = self;
    [self.view addSubview:_toolbar];
    
    [self updateToolbarState];
    
    UIButton *enjoyButton = _toolbar.buttons[0];
    UIButton *collectButton = _toolbar.buttons[1];
    
    if ([self.pictureData.enjoyFlag isEqualToString:@"true"]) enjoyButton.selected = YES;
    else enjoyButton.selected = NO;
    
    if ([self.pictureData.favoriteFlag isEqualToString:@"true"]) collectButton.selected = YES;
    else collectButton.selected = NO;
    
}
- (void)createImageCollectionView {
    CGRect frame = self.view.bounds;
    frame.origin.x = (_photos.count) * frame.size.width;
    _collectView = [[MJPhotoCollectionView alloc] initWithFrame:frame];
    _collectView.delegate = self;
    [_photoScrollView addSubview:_collectView];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * (_photos.count+1), 0);
    
    NSArray *recommen = self.pictureData.recommendList;
    _collectView.photos = recommen;
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}


- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    // 移除工具条
    BOOL willHide = _toolbar.hidden ? NO : YES;
    float willAlpha = willHide ? 0 : 1;
    _toolbar.hidden = _navBarView.hidden = NO;
    _toolbar.alpha = _navBarView.alpha = 1-willAlpha;
    
    [UIView animateWithDuration:.25 animations:^{
        _toolbar.alpha = willAlpha;
        _navBarView.alpha = willAlpha;
    } completion:^(BOOL finished) {
        _toolbar.hidden = willHide;
        _navBarView.hidden = willHide;
    }];
    
    _barsHidden = willHide;
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark 显示照片
- (void)showPhotos
{
    if (_photos.count == 0) return;
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
	int firstIndex = (int)floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
	int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index
{
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    
    if (SYSTEM_VERSION_MOER_THAN_7) {
        if (bounds.origin.y == 0) {
            bounds.origin.y = -20;
        }
    }
    CGRect photoViewFrame = bounds;
    photoViewFrame.origin.x = (bounds.size.width * index);
    photoView.tag = kPhotoViewTagOffset + index;
    
    MJPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(int)index
{
    if (index > 0) {
        MJPhoto *photo = _photos[index - 1];
        
        [[SDWebImageManager sharedManager] downloadWithURL:photo.url
                                                   options:SDWebImageLowPriority|SDWebImageRetryFailed
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {}];
    }
    
    if (index < _photos.count - 1) {
        MJPhoto *photo = _photos[index + 1];
        
        [[SDWebImageManager sharedManager] downloadWithURL:photo.url
                                                   options:SDWebImageLowPriority|SDWebImageRetryFailed
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {}];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (MJPhotoView *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
           return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateToolbarState
{
    _currentPhotoIndex = fabs(_photoScrollView.contentOffset.x / _photoScrollView.frame.size.width);
    if (_currentPhotoIndex >= _photos.count) return;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
    _toolbar.title = self.pictureData.atlasName;
    
    NETResponse_Picture_Pictures *pic = self.pictureData.pictures[_currentPhotoIndex];
    _toolbar.detail = pic.picDescription;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect visibleBounds = _photoScrollView.bounds;
    if (CGRectGetMaxX(visibleBounds) <= _photos.count*CGRectGetWidth(visibleBounds)) {
        [self showPhotos];
    }
    
    if (CGRectGetMaxX(visibleBounds) > (_photos.count+.5)*CGRectGetWidth(visibleBounds)) {
        //show
        _toolbar.hidden = YES;
        _navBarView.hidden = NO;
        _navBarView.discussButton.hidden = YES;
    }else {
        _toolbar.hidden = _navBarView.hidden = _barsHidden;
        _navBarView.discussButton.hidden = NO;
        _toolbar.alpha = _navBarView.alpha = 1;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateToolbarState];
}


#pragma mark - collection pic delegate
- (void)collectionPicturePressedAtIndex:(unsigned int)index {
    
    NETResponse_Picture_Recommen *recommen = self.pictureData.recommendList[index];
    
    NETRequest_Picture *req = [[NETRequest_Picture alloc] init];
    [req loadAtlasId:recommen.mediaId];
    [NET startRequestWithPort:YFY_NET_PORT_PICTURE
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}

#pragma mark - tool delegate
- (void)toolBarButtonPressedAtIndex:(unsigned int)index {
    
    UIButton *button = _toolbar.buttons[index];
    if (index == 0) {
        
        if ([DATA isLogin]) {
            if (button.selected) {
                [self requestDeleLike];
            }else {
                [self requestAddLike];
            }
        }else {
            __weak MJPhotoBrowser *wself = self;
            [LoginViewController login:^(BOOL flag) {
                if (flag) {
                    if (button.selected) {
                        [wself requestDeleLike];
                    }else {
                        [wself requestAddLike];
                    }
                }else {
                }
            }];
        }
    }
    else if (index == 1) {

        if ([DATA isLogin]) {
            if (button.selected) {
                [self requestDeleCollection];
            }else {
                [self requestAddCollection];
            }
        }else {
            __weak MJPhotoBrowser *wself = self;
            [LoginViewController login:^(BOOL flag) {
                if (flag) {
                    if (button.selected) {
                        [wself requestDeleCollection];
                    }else {
                        [wself requestAddCollection];
                    }
                }else {
                }
            }];
        }
    }
    else if (index == 3) {
        __weak MJPhotoBrowser *wself = self;
        
        NETResponse_Picture_Pictures *firstImage = self.pictureData.pictures[0];
        NSString *firstImageUrl = firstImage.picUrl;
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:firstImageUrl]
                                                   options:SDWebImageLowPriority|SDWebImageRetryFailed
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     
                                                     NSString *shareText = [NSString stringWithFormat:@"%@\n%@",
                                                                            wself.pictureData.atlasSynopsis,
                                                                            wself.pictureData.link];
                                                     
                                                     [wself shareUmengWithString:shareText
                                                                           image:image
                                                                             url:wself.pictureData.link
                                                                        delegate:wself];
                                                     
                                                 }];
    }
}

- (void)requestAddCollection {
    NETRequest_Media_Collect *req = [[NETRequest_Media_Collect alloc] init];
    [req loadMediaId:self.pictureData.atlasId type:@"3"];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_COLLECT
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestDeleCollection {
    NETRequest_Media_UnCollect *req = [[NETRequest_Media_UnCollect alloc] init];
    [req loadMediaId:self.pictureData.atlasId type:@"3"];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_DELE_COLLECT
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestAddLike {
    NETRequest_Media_Like *req = [[NETRequest_Media_Like alloc] init];
    [req loadMediaId:self.pictureData.atlasId type:@"3"];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_LIKE
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestDeleLike {
    NETRequest_Media_UnLike *req = [[NETRequest_Media_UnLike alloc] init];
    [req loadMediaId:self.pictureData.atlasId type:@"3"];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_DELE_LIKE
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
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


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_PICTURE]) {
        
        NETResponse_Picture *rsp = [[NETResponse_Picture alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_DATA];
        rsp.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] initWithPictures:rsp];
        browser.currentPhotoIndex = 0;
        [self.navigationController pushViewController:browser animated:YES];
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_LIKE]) {
        [HUD showText:@"添加喜欢成功" image:[UIImage imageNamed:@"detail_tool_like2.png"] autoHide:YES];
        
        UIButton *button = _toolbar.buttons[0];
        button.selected = YES;
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_DELE_LIKE]) {
        [HUD showText:@"取消喜欢成功" image:[UIImage imageNamed:@"picture_enjoy.png"] autoHide:YES];
        
        UIButton *button = _toolbar.buttons[0];
        button.selected = NO;
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_COLLECT]) {
        [HUD showText:@"添加收藏成功" image:[UIImage imageNamed:@"detail_tool_collect2.png"] autoHide:YES];
        
        UIButton *button = _toolbar.buttons[1];
        button.selected = YES;
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_DELE_COLLECT]) {
        [HUD showText:@"取消收藏成功" image:[UIImage imageNamed:@"picture_collect.png"] autoHide:YES];
        
        UIButton *button = _toolbar.buttons[1];
        button.selected = NO;
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_PICTURE]) {
        NETResponse_Header *rsp = [[NETResponse_Header alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *error = rsp.rspDesc.length ? rsp.rspDesc : @"没有数据";
        [HUD showFaceText:error];
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


@end




@implementation TopNavView
- (id)initWithDiscussNum:(NSNumber *)dis {
    BOOL ios7 = SYSTEM_VERSION_MOER_THAN_7;
    CGRect frame = CGRectMake(0, 0, 320, 44);
    if (ios7) {
        frame.size.height = 64;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"nav_back.png"];
        
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        if (rect.size.height > 44) {
            rect.size.width *= 44 / rect.size.height;
            rect.size.height = 44;
        }
        rect.origin = CGPointMake(0, self.frame.size.height-rect.size.height);
        _backButton.frame = rect;
        
        [_backButton setImage:image forState:UIControlStateNormal];
        [self addSubview:_backButton];
        
        
        UIImage *image2 = [UIImage imageNamed:@"picture_commen.png"];
        CGSize size = image2.size;
        image2 = [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(5, 30, 5, 5)];
        NSString *discuss = [NSString stringWithFormat:@"评论 %d", [dis integerValue]];
        CGSize stringSize = [discuss sizeWithFont:[UIFont boldSystemFontOfSize:14]];
        size.width = 37+stringSize.width;
        
        _discussButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _discussButton.frame = CGRectMake(0, 0, size.width, size.height);
        CGRect buttonFrame = _discussButton.frame;
        buttonFrame.origin.x = self.frame.size.width-buttonFrame.size.width-5;
        buttonFrame.origin.y = self.frame.size.height-buttonFrame.size.height-6;
        _discussButton.frame = buttonFrame;
        [_discussButton setBackgroundImage:image2 forState:UIControlStateNormal];
        [self addSubview:_discussButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, stringSize.width, size.height)];
        label.text = discuss;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        [_discussButton addSubview:label];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        0/255.0, 0/255.0, 0/255.0, 1,
        0/255.0, 0/255.0, 0/255.0, 0,
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(0, 0),
                                CGPointMake(0, rect.size.height),
                                0);
}
@end










