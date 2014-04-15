//
//  VideoViewController.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-5.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "VideoViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "VideoCell.h"
#import "UITableViewCell+Nib.h"
#import "UIImageView+WebCache.h"
#import "RefreshView.h"
#import "PullUpView.h"
#import "VideoDetailViewController.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETResponse_Login.h"
#import "NETRequest_VideoIndex.h"
#import "NETResponse_VideoIndex.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface VideoViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  NetworkCenterDelegate
>
{
    unsigned int _pageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) PullUpView *pullUpView;

@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self presetNav];
    
    
    __weak VideoViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.mainTableView callBack:^{
        [wself requestPageTag:kRequestTagNew];
    }];
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.mainTableView complete:^{
        int count = [DATA videoPage].results.count;
        int total = [[DATA videoPage].totalSize integerValue];
        if (count < total) {
            _pageIndex++;
            [wself requestPageTag:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];

    if ([DATA videoPage]) {
        [self.mainTableView reloadData];
        [self resetFooterStyle];
    }else {
        [self requestPageTag:kRequestTagNew];
        [self showLoadingViewBelow:nil];
    }
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topButton.frame = CGRectMake(60, 0, 200, 44);
    [topButton addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topButton];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    APP_ROOT_VC.panGesture.enabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    APP_ROOT_VC.panGesture.enabled = NO;
}
- (void)clearMemory {
    self.refreshView = nil;
}

- (void)clickLoadingViewToRefresh {
    [self requestPageTag:kRequestTagNew];
}
- (void)scrollToTop {
    [self.mainTableView scrollRectToVisible:CGRectMake(0, 0, 320, 10) animated:YES];
}



#pragma mark - private
- (void)presetNav {
    self.navigationBarHidden = NO;
    
    self.navigationBar.title = @"视频";
    
    [self setNavigationBarWithImageName:@"firstPage_left_item.png"
                                 target:self
                                 action:@selector(rightButtonPressed:)
                               position:CustomNavigationBarPositionRight];
    [self setNavigationBarWithImageName:@"firstPage_right_item.png"
                                 target:self
                                 action:@selector(leftButtonPressed:)
                               position:CustomNavigationBarPositionLeft];
}
- (void)requestPageTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _pageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_VideoIndex *req = [[NETRequest_VideoIndex alloc] init];
    [req loadUserId:[DATA loginData].userId
          pageIndex:[NSNumber numberWithUnsignedInt:_pageIndex]
           pageSize:@20];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_VIDEO_INDEX
                         code:nil
                   parameters:req.requestDic
                          tag:tag
                      reciver:self];
}
- (void)resetFooterStyle {
    int count = [DATA videoPage].results.count;
    int total = [[DATA videoPage].totalSize integerValue];
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}


#pragma mark - actions
- (void)rightButtonPressed:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
- (void)leftButtonPressed:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - segment delegate
- (void)discussSegmentPressedIndex:(int)index {
    
}

#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.refreshView scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.refreshView scrollViewDidScroll:scrollView];
        [self.pullUpView tableViewDidScroll:(UITableView *)scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self.refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


#pragma mark - UITableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DATA videoPage].results.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VideoCellCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = VideoCellIdentifier;
    VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (VideoCell *)[UITableViewCell cellWithNibName:@"VideoCell"];
    }
    
    NETResponse_VideoIndex_Result *result = [DATA videoPage].results[indexPath.row];

    [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.coverPhoto]];
    cell.titleLabel_.text = result.videoName;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@\t•", result.vidDuration];
    cell.numberLabel.text = [result.pv stringValue];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NETResponse_VideoIndex_Result *result = [DATA videoPage].results[indexPath.row];
    
    VideoDetailViewController *video = [[VideoDetailViewController alloc] initWithVideoId:result.videoId];
    [self.navigationController pushViewController:video animated:YES];
}


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self hideLoadingView];
    
    if ([port isEqualToString:YFY_NET_PORT_MEDIA_VIDEO_INDEX]) {
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_VideoIndex *res = [[NETResponse_VideoIndex alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [DATA setVideoPage:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.mainTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([DATA videoPage]) { //如果已存在，添加信息
                NETResponse_VideoIndex *res = [DATA videoPage];
                
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.mainTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_VideoIndex *res = [[NETResponse_VideoIndex alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [DATA setVideoPage:res];
                [self.mainTableView reloadData];
            }
        }
        [self resetFooterStyle];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_MEDIA_VIDEO_INDEX]) {
        [self.refreshView stopLoading];
        [self setLoadingFail];
        
        NETResponse_VideoIndex *res = [[NETResponse_VideoIndex alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _pageIndex--;
        }
    }
}


@end
