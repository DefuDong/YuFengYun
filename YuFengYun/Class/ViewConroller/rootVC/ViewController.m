//
//  ViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-4.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"
#import "RefreshView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PullUpView.h"

#import "UITableViewCell+Nib.h"
#import "FirstPage_Cell.h"

#import "DetailViewController.h"
#import "UIViewController+MMDrawerController.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETResponse_FirstPageHeader.h"
#import "NETRequest_FirstPageHeader.h"
#import "NETResponse_Login.h"
#import "NETRequest_FirstPage.h"
#import "NETResponse_FirstPage.h"

#import "DBManager.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"


@interface ViewController ()
<
  CycleScrollViewDatasource,
  CycleScrollViewDelegate,
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
@property (nonatomic, strong) CycleScrollView *cycleView;
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) PullUpView *pullUpView;

@end

@implementation ViewController
- (CycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
        _cycleView.datasource = self;
        _cycleView.delegate = self;
    }
    return _cycleView;
}

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];

    [self presetNav];
    
    self.mainTableView.tableHeaderView = self.cycleView;
    
    __weak ViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.mainTableView callBack:^{
        [wself requestHeader];
        [wself requestPageTag:kRequestTagNew];
    }];
    
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.mainTableView complete:^{
        int count = [DATA firstPage].results.count;
        int total = [[DATA firstPage].totalSize integerValue];
        if (count < total) {
            _pageIndex++;
            [wself requestPageTag:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
    //离线
    NSString *tableName = [DB tableNames][0];
    if ([DB isTableExist:tableName]) {
        NETResponse_FirstPageHeader *header = [DB firstPageHeader];
        if (header) {
            [DATA setFirstPageHeader:header];
        }
        
        NETResponse_FirstPage *firstPage = [DB firstPageData];
        if (firstPage) {
            [DATA setFirstPage:firstPage];
        }
    }
    
    if ([DATA firstPageHeader]) {
        [self.cycleView reloadData];
    }else {
        [self requestHeader];
    }
    
    if ([DATA firstPage]) {
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cycleView startTimer];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *selectedIndexPath = [self.mainTableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.mainTableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
    }
    
    APP_ROOT_VC.panGesture.enabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.cycleView stopTimer];
    
    APP_ROOT_VC.panGesture.enabled = NO;
}
- (void)clearMemory {
    self.cycleView = nil;
    self.refreshView = nil;
    self.pullUpView = nil;
}

- (void)clickLoadingViewToRefresh {
    [self requestHeader];
    [self requestPageTag:kRequestTagNew];
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


#pragma mark - CycleScrollView
#pragma mark data source
- (NSInteger)numberOfCycleScrollViewPage {
    return [[[DATA firstPageHeader] results] count];
}
- (UIView *)cycleView:(CycleScrollView *)cycleView pageAtIndex:(NSInteger)index {
    
    NETResponse_FirstPageHeader_Result *result = [[[DATA firstPageHeader] results] objectAtIndex:index];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cycleView.bounds];
    [imageView setImageWithURL:[NSURL URLWithString:result.articleDeckblatt]];
//    [imageView setImageWithURL:nil];
    return imageView;
}
- (NSString *)cycleView:(CycleScrollView *)cycleView titleAtIndex:(NSInteger)index {
    NETResponse_FirstPageHeader_Result *result = [[[DATA firstPageHeader] results] objectAtIndex:index];
    return result.articleShortTitle;
}
#pragma mark delegate
- (void)cycleView:(CycleScrollView *)cycleView didSelectPageAtIndex:(NSInteger)index {
    
    NETResponse_FirstPageHeader_Result *result = [DATA firstPageHeader].results[index];
    DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:result.articleId];
    [self.navigationController pushViewController:detail animated:YES];
    
//    TestViewController *test = [[TestViewController alloc] initFromNib];
//    [self.navigationController pushViewController:test animated:YES];
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
    return [DATA firstPage].results.count;
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
    
    NETResponse_FirstPage_Result *result = [DATA firstPage].results[indexPath.row];
    
    [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.articleDeckblatt]];
    cell.titleLabel_.text = result.articleShortTitle;
    cell.detailLabel_.text = result.articleSynopsis;
    NSString *time = [NSString stringWithFormat:@"%@ •", result.articlePublishTime];
    cell.timeNumber = time;
    cell.discussLabel.text = [result.articleCommentNum stringValue];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *results = [[DATA firstPage] results];
    NETResponse_FirstPage_Result *result = [results objectAtIndex:indexPath.row];
    
    DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:result.articleId];
    [self.navigationController pushViewController:detail animated:YES];
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [DATA firstPage].results.count;
    return count/2 + count%2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FirstPageFirstCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = FirstPageFirstCellIdentifier;
    FirstPage_First_Cell *cell = (FirstPage_First_Cell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (FirstPage_First_Cell *)[UITableViewCell cellWithNibName:@"FirstPage_First_Cell"];
    }
    
    int index = indexPath.row * 2;
    NSArray *results = [[DATA firstPage] results];
    NETResponse_FirstPage_Result *result1 = [results objectAtIndex:index];
    NETResponse_FirstPage_Result *result2 = nil;
    if (results.count > index+1) {
        result2 = [results objectAtIndex:index+1];
    }
    
//    NSInteger h1,h2,m1,m2;
    
//    [self time:result1.formatPublishTime hour:&h1 minute:&m1];
//    [cell.aView.timeView setHour:h1 minute:m1];
    cell.aView.timeLabel.text = result1.articlePublishTime;
    [cell.aView.imageButton setImageWithURL:[NSURL URLWithString:result1.articleDeckblatt]
                                   forState:UIControlStateNormal];
    cell.aView.detailLabel.text = result1.articleShortTitle;
    [cell.aView.imageButton addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.aView.imageButton.tag = indexPath.row;
    
    if (result2) {
//        [self time:result2.formatPublishTime hour:&h2 minute:&m2];
        cell.bView.hidden = NO;
//        [cell.bView.timeView setHour:h2 minute:m2];
        cell.bView.timeLabel.text = result2.articlePublishTime;
        [cell.bView.imageButton setImageWithURL:[NSURL URLWithString:result2.articleDeckblatt]
                                       forState:UIControlStateNormal];
        cell.bView.detailLabel.text = result2.articleShortTitle;
        [cell.bView.imageButton addTarget:self action:@selector(cellPressed2:) forControlEvents:UIControlEventTouchUpInside];
        cell.bView.imageButton.tag = indexPath.row;
    }else {
        cell.bView.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView.tag != 0) {
//        RightViewController *right = [[RightViewController alloc] initFromNib];
//        [self.navigationController pushViewController:right animated:YES];
//    }
}

- (void)cellPressed:(UIButton *)button {
    int index = button.tag * 2;
    NSArray *results = [[DATA firstPage] results];
    NETResponse_FirstPage_Result *result = [results objectAtIndex:index];
    
    DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:result.articleId];
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)cellPressed2:(UIButton *)button {
    int index = button.tag * 2;
    NSArray *results = [[DATA firstPage] results];
    NETResponse_FirstPage_Result *result = [results objectAtIndex:index+1];
    
    DetailViewController *test = [[DetailViewController alloc] initWithArticleId:result.articleId];
    [self.navigationController pushViewController:test animated:YES];
}
*/

#pragma mark - private
- (void)presetNav {
    self.navigationBarHidden = NO;
    
    UIImage *image = [UIImage imageNamed:@"nav_logo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
//    imageView.center = CGPointMake(self.navigationBar.center.x, self.navigationBar.center.y);
    self.navigationBar.titleView = imageView;
    
    [self setNavigationBarWithImageName:@"firstPage_left_item.png"
                                 target:self
                                 action:@selector(rightButtonPressed:)
                               position:CustomNavigationBarPositionRight];
    [self setNavigationBarWithImageName:@"firstPage_right_item.png"
                                 target:self
                                 action:@selector(leftButtonPressed:)
                               position:CustomNavigationBarPositionLeft];
}
- (void)requestHeader {
    NETRequest_FirstPageHeader *header = [[NETRequest_FirstPageHeader alloc] init];
    [header loadUserId:[DATA loginData].userId];
    [NET startRequestWithPort:YFY_NET_PORT_FIRST_PAGE_HEADER
                         code:YFY_NET_CODE_FIRST_PAGE_HEADER
                   parameters:header.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestPageTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _pageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_FirstPage *req = [[NETRequest_FirstPage alloc] init];
    [req loadUserId:[DATA loginData].userId
          pageIndex:[NSNumber numberWithUnsignedInt:_pageIndex]
           pageSize:@20];
    
    [NET startRequestWithPort:YFY_NET_PORT_FIRST_PAGE
                         code:YFY_NET_CODE_FIRST_PAGE
                   parameters:req.requestDic
                          tag:tag
                      reciver:self];
}
- (void)resetFooterStyle {
    int count = [DATA firstPage].results.count;
    int total = [[DATA firstPage].totalSize integerValue];
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}
- (void)time:(NSString *)time hour:(int *)hour minute:(int *)minute {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
//    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [formatter dateFromString:time];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *component = [calendar components:unitFlags fromDate:date];
    *hour = component.hour;
    *minute = component.minute;
}

- (void)deleteOfflineData {
    NSString *tableName = [DB tableNames][0];
    
    if ([DB isTableExist:tableName]) {
        [DB deleteTableWithName:tableName];
    }
}


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self hideLoadingView];
    
    if ([port isEqualToString:YFY_NET_PORT_FIRST_PAGE_HEADER]) {
        NETResponse_FirstPageHeader *response = [[NETResponse_FirstPageHeader alloc] init];
        response.responseDic = [dic objectForKey:YFY_NET_DATA];
        response.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        [DATA setFirstPageHeader:response];
        
        [self.cycleView reloadData];
    }
    else if ([port isEqualToString:YFY_NET_PORT_FIRST_PAGE]) {
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_FirstPage *res = [[NETResponse_FirstPage alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [DATA setFirstPage:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.mainTableView reloadData];
            
            if ([DB isTableExist:[DB tableNames][0]]) {
                [DB deleteTableWithName:[DB tableNames][0]];
            }
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([DATA firstPage]) { //如果已存在，添加信息
                NETResponse_FirstPage *res = [DATA firstPage];
                
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.mainTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_FirstPage *res = [[NETResponse_FirstPage alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [DATA setFirstPage:res];
                [self.mainTableView reloadData];
            }
        }
        [self resetFooterStyle];
    }
    [self deleteOfflineData];
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self setLoadingFail];
    
    if ([port isEqualToString:YFY_NET_PORT_FIRST_PAGE_HEADER]) {
        NETResponse_FirstPageHeader *response = [[NETResponse_FirstPageHeader alloc] init];
        response.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = response.responseHeader.rspDesc.length ? response.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
    }
    else if ([port isEqualToString:YFY_NET_PORT_FIRST_PAGE]) {
        NETResponse_FirstPage *res = [[NETResponse_FirstPage alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _pageIndex--;
        }
    }
}


@end








