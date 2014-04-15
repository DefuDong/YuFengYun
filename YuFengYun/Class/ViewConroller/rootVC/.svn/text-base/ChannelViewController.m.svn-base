//
//  ViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-4.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "ChannelViewController.h"
//#import "CycleScrollView.h"
#import "RefreshView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PullUpView.h"
#import "Common.h"

#import "UITableViewCell+Nib.h"
//#import "FirstPage_Channel_Cell.h"
#import "FirstPage_Cell.h"

#import "DetailViewController.h"

#import "UIViewController+MMDrawerController.h"
#import "DetailViewController.h"

#import "DataCenter.h"
#import "NetworkCenter.h"
#import "NETRequest_Channel.h"
#import "NETResponse_Channel.h"
#import "NETResponse_Login.h"

#import "DBManager.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"


@interface ChannelViewController ()
<
//    CycleScrollViewDatasource,
//    CycleScrollViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    NetworkCenterDelegate
>
{
    unsigned int _pageIndex;
}
//IBOutlet
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
//strong vierws
//@property (nonatomic, strong) CycleScrollView *cycleView;
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) PullUpView *pullUpView;

@property (nonatomic, copy) NSString *channelCode;

@end

@implementation ChannelViewController
/*
- (CycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(5, 5, 310, 155)];
        _cycleView.datasource = self;
        _cycleView.delegate = self;
    }
    return _cycleView;
}
*/

#pragma mark - view
- (id)initWithChannelCode:(NSString *)code {
    self = [super initFromNib];
    if (self) {
        self.channelCode = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self presetNav];
    
//    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainTableView.frame.size.width, 164)];
//    [back addSubview:self.cycleView];
//    self.mainTableView.tableHeaderView = back;
    
    __weak ChannelViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.mainTableView callBack:^{
        [wself requestWithTag:kRequestTagNew];
    }];
    
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.mainTableView complete:^{
        int count = [self channelData].results.count;
        int total = [[self channelData].totalSize integerValue];
        if (count < total) {
            _pageIndex++;
            [wself requestWithTag:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
    if (![self channelData]) {
        [self requestWithTag:kRequestTagNew];
        [self showLoadingViewBelow:nil];
    }else {
        [self resetFooterStyle];
    }
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topButton.frame = CGRectMake(60, 0, 200, 44);
    [topButton addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.cycleView startTimer];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *selectedIndexPath = [self.mainTableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.mainTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
    
    APP_ROOT_VC.panGesture.enabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.cycleView stopTimer];
    
    APP_ROOT_VC.panGesture.enabled = NO;
}
- (void)clearMemory {
//    self.cycleView = nil;
    self.refreshView = nil;
    self.pullUpView = nil;
}

- (void)clickLoadingViewToRefresh {
    [self requestWithTag:kRequestTagNew];
}
- (void)scrollToTop {
    [self.mainTableView scrollRectToVisible:CGRectMake(0, 0, 320, 10) animated:YES];
}


#pragma mark - actions
- (void)rightButtonPressed:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
- (void)leftButtonPressed:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

/*
#pragma mark - CycleScrollView
#pragma mark data source
- (NSInteger)numberOfCycleScrollViewPage {
    return 3;
}
- (UIView *)cycleView:(CycleScrollView *)cycleView pageAtIndex:(NSInteger)index {
    NSArray *_imageArray = @[
                             @"http://static2.dmcdn.net/static/video/629/228/44822926:jpeg_preview_source.jpg?20120509181018",
                             @"http://static2.dmcdn.net/static/video/116/367/44763611:jpeg_preview_source.jpg?20120509101749",
                             @"http://static2.dmcdn.net/static/video/666/645/43546666:jpeg_preview_source.jpg?20120412153140"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cycleView.bounds];
    [imageView setImageWithURL:_imageArray[index]];
    return imageView;
}
- (NSString *)cycleView:(CycleScrollView *)cycleView titleAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"是蹙额我我弄粗文文辉辉还 ：%d", index];
}
#pragma mark delegate
- (void)cycleView:(CycleScrollView *)cycleView didSelectPageAtIndex:(NSInteger)index {
    DEBUG_LOG_(@"click index: %d", index);
}
*/


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
    return [self channelData].results.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FirstPageCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = FirstPageCellIdentifier;
    FirstPage_Cell *cell = (FirstPage_Cell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (FirstPage_Cell *)[UITableViewCell cellWithNibName:@"FirstPage_Cell"];
    }
    
    NETResponse_Channel_Result *result = [self channelData].results[indexPath.row];
    
    [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.articleDeckblatt]];
    cell.titleLabel_.text = result.articleShortTitle;
    cell.detailLabel_.text = result.articleSynopsis;
    NSString *time = [NSString stringWithFormat:@"%@ •", result.articlePublishTime];
    cell.timeNumber = time;
    cell.discussLabel.text = [result.articleCommentNum stringValue];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NETResponse_Channel_Result *result = [self channelData].results[indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:result.articleId];
    [self.navigationController pushViewController:detail animated:YES];
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self channelData].results.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FirstPageChannelCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = FirstPageChannelCellIdentifier;
    FirstPage_Channel_Cell *cell = (FirstPage_Channel_Cell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (FirstPage_Channel_Cell *)[UITableViewCell cellWithNibName:@"FirstPage_Channel_Cell"];
    }
    
    NETResponse_Channel_Result *result = [self channelData].results[indexPath.row];
    [cell.theImageView setImageWithURL:[NSURL URLWithString:result.articleDeckblatt]];
    cell.titleLabel.text = result.articleShortTitle;
    cell.detailLabel.text = result.articleSynopsis;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NETResponse_Channel_Result *result = [self channelData].results[indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:result.articleId];
    [self.navigationController pushViewController:detail animated:YES];
}
*/

#pragma mark - private
- (void)presetNav {
    UIImage *image = [UIImage imageNamed:@"nav_logo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, image.size.width, image.size.height)];
    imageView.image = image;
//    imageView.center = CGPointMake(self.navigationBar.center.x, self.navigationBar.center.y);
    self.navigationBar.titleView = imageView;
    
    [self setNavigationBarWithImageName:@"firstPage_left_item"
                                 target:self
                                 action:@selector(rightButtonPressed:)
                               position:CustomNavigationBarPositionRight];
    
    [self setNavigationBarWithImageName:@"firstPage_right_item.png"
                                 target:self
                                 action:@selector(leftButtonPressed:)
                               position:CustomNavigationBarPositionLeft];
}
- (void)requestWithTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _pageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_Channel *request = [[NETRequest_Channel alloc] init];
    [request loadUserId:[DATA loginData].userId
            channleCode:self.channelCode
              pageIndex:[NSNumber numberWithUnsignedInt:_pageIndex]
               pageSize:@20];
    
    [NET startRequestWithPort:YFY_NET_PORT_CHANNEL_PAGE
                         code:YFY_NET_CODE_CHANNEL_PAGE
                   parameters:request.requestDic
                          tag:tag
                      reciver:self];
}
- (void)resetFooterStyle {
    int count = [self channelData].results.count;
    int total = [[self channelData].totalSize integerValue];
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}

- (NETResponse_Channel *)channelData {
    if ([self.channelCode isEqualToString:CHANNEL_CODE_XINSHIDIAN]) {
        NSString *tableName = [DB tableNames][1];
        if ([DB isTableExist:tableName]) return [DB channelDataWithName:tableName];
        else return [DATA channelPage_XinShiDian];
    }
    if ([self.channelCode isEqualToString:CHANNEL_CODE_DONGTAI]) {
        NSString *tableName = [DB tableNames][2];
        if ([DB isTableExist:tableName]) return [DB channelDataWithName:tableName];
        else return [DATA channelPage_DongTai];
    }
    if ([self.channelCode isEqualToString:CHANNEL_CODE_SHIDIAN]) {
        NSString *tableName = [DB tableNames][3];
        if ([DB isTableExist:tableName]) return [DB channelDataWithName:tableName];
        else return [DATA channelPage_ShiDian];
    }
    if ([self.channelCode isEqualToString:CHANNEL_CODE_GUANLI]) {
        NSString *tableName = [DB tableNames][4];
        if ([DB isTableExist:tableName]) return [DB channelDataWithName:tableName];
        else return [DATA channelPage_GuanLi];
    }
    return nil;
}
- (void)setChannelData:(NETResponse_Channel *)channelData {
    if ([self.channelCode isEqualToString:CHANNEL_CODE_XINSHIDIAN]) {
        [DATA setChannelPage_XinShiDian:channelData];
    }
    if ([self.channelCode isEqualToString:CHANNEL_CODE_DONGTAI]) {
        [DATA setChannelPage_DongTai:channelData];
    }
    if ([self.channelCode isEqualToString:CHANNEL_CODE_SHIDIAN]) {
        [DATA setChannelPage_ShiDian:channelData];
    }
    if ([self.channelCode isEqualToString:CHANNEL_CODE_GUANLI]) {
        [DATA setChannelPage_GuanLi:channelData];
    }
}

- (void)deleteOfflineData {
    NSString *tableName = nil;
    if ([self.channelCode isEqualToString:CHANNEL_CODE_XINSHIDIAN]) 
        tableName = [DB tableNames][1];
    if ([self.channelCode isEqualToString:CHANNEL_CODE_DONGTAI]) 
        tableName = [DB tableNames][2];
    if ([self.channelCode isEqualToString:CHANNEL_CODE_SHIDIAN]) 
        tableName = [DB tableNames][3];
    if ([self.channelCode isEqualToString:CHANNEL_CODE_GUANLI]) 
        tableName = [DB tableNames][4];
    
    if ([DB isTableExist:tableName]) {
        [DB deleteTableWithName:tableName];
    }
}


#pragma mark - network
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self hideLoadingView];
    
    if ([port isEqualToString:YFY_NET_PORT_CHANNEL_PAGE]) {
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_Channel *res = [[NETResponse_Channel alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [self setChannelData:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
                        
            [self.mainTableView reloadData];
            
            [self deleteOfflineData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([self channelData]) { //如果已存在，添加信息
                NETResponse_Channel *res = [self channelData];
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.mainTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_Channel *res = [[NETResponse_Channel alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [self setChannelData:res];
                [self.mainTableView reloadData];
            }
        }
        [self resetFooterStyle];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self setLoadingFail];
    
    if ([port isEqualToString:YFY_NET_PORT_CHANNEL_PAGE]) {
        NETResponse_Channel *res = [[NETResponse_Channel alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _pageIndex--;
        }
    }
}


@end








