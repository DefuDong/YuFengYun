//
//  NotificationViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-25.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NotificationViewController.h"
#import "Notification_Cell.h"
#import "UITableViewCell+Nib.h"
#import "RefreshView.h"
#import "PullUpView.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_Notification.h"
#import "NETResponse_Notification.h"
#import "NETResponse_Login.h"
#import "NETRequest_DeleNotification.h"
#import "NETResponse_DeleNotification.h"


#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface NotificationViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  NetworkCenterDelegate,
  NotificationCellDelegate
>
{
    unsigned int _pageIndex;
}

@property (nonatomic, weak) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) PullUpView *pullUpView;

@end

@implementation NotificationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBar.title = @"通知";
    [self setBackNavButtonActionPop];
    
    __weak NotificationViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.mainTableView callBack:^{
        [wself requestDataTag:kRequestTagNew];
    }];
    
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.mainTableView complete:^{
        int count = [DATA myNotification].results.count;
        int total = [[DATA myNotification].totalSize integerValue];
        if (count < total) {
            _pageIndex++;
            [wself requestDataTag:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
    [self requestDataTag:kRequestTagNew];
    [self showLoadingViewBelow:nil];
}
- (void)clearMemory {
    self.refreshView = nil;
    self.pullUpView = nil;
}
- (void)clickLoadingViewToRefresh {
    [self requestDataTag:kRequestTagNew];
}

#pragma mark - private
- (void)requestDataTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _pageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_Notification *request = [[NETRequest_Notification alloc] init];
    [request loadUserId:[DATA loginData].userId
              pageIndex:[NSNumber numberWithInt:_pageIndex]
               pageSize:@20];
    [NET startRequestWithPort:YFY_NET_PORT_READ_NOTIF
                         code:YFY_NET_CODE_READ_NOTIF
                   parameters:request.requestDic
                          tag:tag reciver:self];
}
- (void)requestDeleteNotification:(NSNumber *)noticeId row:(int)row {
    NETRequest_DeleNotification *dele = [[NETRequest_DeleNotification alloc] init];
    [dele loadUserId:[DATA loginData].userId noticeId:noticeId];
    
    [NET startRequestWithPort:YFY_NET_PORT_DELE_NOTIF
                         code:YFY_NET_CODE_DELE_NOTIF
                   parameters:dele.requestDic
                          tag:[[NSNumber numberWithInt:row] stringValue]
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)resetFooterStyle {
    int count = [DATA myNotification].results.count;
    int total = [[DATA myNotification].totalSize integerValue];
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}
- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [DATA myNotification].results.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NETResponse_Notification_Result *result = [DATA myNotification].results[indexPath.row];
    return [Notification_Cell cellHeight:result.noticeText];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = NotificationCellIdentifier;
	
	Notification_Cell *cell = (Notification_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = (Notification_Cell *)[UITableViewCell cellWithNibName:@"Notification_Cell"];
	}
    
    NETResponse_Notification_Result *result = [DATA myNotification].results[indexPath.row];
    cell.detailLabel.text = result.noticeText;
    cell.timeLabel.text = result.releaseTime;
    cell.delegate = self;
        
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)notificationCellDeleteDelegate:(Notification_Cell *)cell {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    NETResponse_Notification_Result *result = [DATA myNotification].results[indexPath.row];
    
    [self requestDeleteNotification:result.noticeId row:indexPath.row];
}


#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.mainTableView) {
        [self.refreshView scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainTableView) {
        [self.refreshView scrollViewDidScroll:scrollView];
        [self.pullUpView tableViewDidScroll:(UITableView *)scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.mainTableView) {
        [self.refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_READ_NOTIF]) {
        [self.refreshView stopLoading];
        [self hideLoadingView];
        
        NETResponse_Login *loginData = [DATA loginData];
        loginData.noticeCount = @0;
        
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_Notification *res = [[NETResponse_Notification alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [DATA setMyNotification:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
                [self performSelector:@selector(popVC) withObject:nil afterDelay:1];
            }
            
            [self.mainTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([DATA myNotification]) { //如果已存在，添加信息
                NETResponse_Notification *res = [DATA myNotification];
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.mainTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_Notification *res = [[NETResponse_Notification alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [DATA setMyNotification:res];
                [self.mainTableView reloadData];
            }
        }
        [self resetFooterStyle];
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_NOTIF]) {
        [self hideHUD:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tag intValue] inSection:0];
        NSMutableArray *results = [DATA myNotification].results;
        
        [results removeObjectAtIndex:[tag intValue]];
        
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_READ_NOTIF]) {
        [self.refreshView stopLoading];
        [self setLoadingFail];
        
        NETResponse_Notification *res = [[NETResponse_Notification alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _pageIndex--;
        }
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_NOTIF]) {
        [self hideHUD:0];
        
        NETResponse_DeleNotification *res = [[NETResponse_DeleNotification alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        [HUD showFaceText:res.responseHeader.rspDesc];
    }
}


@end
