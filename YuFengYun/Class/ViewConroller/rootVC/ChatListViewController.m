//
//  ChatListViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-12.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatList_Cell.h"
#import "UITableViewCell+Nib.h"
#import "UIImageView+WebCache.h"
#import "RefreshView.h"
#import "PullUpView.h"
#import "ChatLetterViewController.h"
#import "UIButton+WebCache.h"
#import "UserInfoViewController.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_ChatList.h"
#import "NETResponse_ChatList.h"
#import "NETResponse_Login.h"
#import "NETRequest_DeleChat.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface ChatListViewController ()
<
  NetworkCenterDelegate,
  ChatListCellDelegate
>
{
    unsigned _pageIndex;
}
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) PullUpView *pullUpView;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"私信";
    
    __weak ChatListViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.mainTableView callBack:^{
        [wself requestPageTag:kRequestTagNew];
    }];
    
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.mainTableView complete:^{
        int count = [DATA chatList].results.count;
        int total = [[DATA chatList].totalSize integerValue];
        if (count < total) {
            _pageIndex++;
            [wself requestPageTag:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
//    if (![DATA chatList]) {
//        [self requestPageTag:kRequestTagNew];
//        [self.refreshView startLoading];
//    }else {
//        [self resetFooterStyle];
//    }
    [self showLoadingViewBelow:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestPageTag:kRequestTagNew];
//    [self.refreshView startLoading];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *selectedIndexPath = [self.mainTableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.mainTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
}
- (void)clearMemory {
    self.refreshView = nil;
    self.pullUpView = nil;
}
- (void)clickLoadingViewToRefresh {
    [self requestPageTag:kRequestTagNew];
}


#pragma mark - UITableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DATA chatList].results.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChatListCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = ChatListCellIdentifier;
    ChatList_Cell *cell = (ChatList_Cell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (ChatList_Cell *)[UITableViewCell cellWithNibName:@"ChatList_Cell"];
    }
    
    NETResponse_ChatList_Result *result = [DATA chatList].results[indexPath.row];
    [cell.headButtn setImageWithURL:[NSURL URLWithString:result.userIcon] forState:UIControlStateNormal];
    cell.headButtn.tag = indexPath.row;
    [cell.headButtn addTarget:self
                       action:@selector(headButtnPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    NSString *name = [[DATA loginData].userNickname isEqualToString:result.letterReceiveUserName] ? result.letterSendUserName : result.letterReceiveUserName;
    cell.nameLabel.text = name;
   
    NSMutableAttributedString *_msgtext = [OHASFaceImageParser attributedStringByProcessingMarkupInString:result.letterText];
    [_msgtext setFont:[UIFont systemFontOfSize:16]];
    cell.messageLabel.attributedText = _msgtext;
    
    cell.numberView.value = [result.childCount intValue];
    [cell.numberView setValueAnimated:[result.childCount integerValue]
                                style:NumberTransformStyleShake
                             duration:1];
    cell.timeLabel.text = result.sendTime;
    
    cell.delegate = self;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NETResponse_ChatList_Result *result = [DATA chatList].results[indexPath.row];
    NSString *name = [[DATA loginData].userNickname isEqualToString:result.letterReceiveUserName] ? result.letterSendUserName : result.letterReceiveUserName;
    
    ChatLetterViewController *chat = [[ChatLetterViewController alloc] initWithUserId:result.letterSendUserId
                                                                             nickName:name];
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)headButtnPressed:(UIButton *)button {
    NETResponse_ChatList_Result *result = [DATA chatList].results[button.tag];
    UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:result.letterSendUserId];
    [self.navigationController pushViewController:user animated:YES];
}


#pragma mark - chat cell delegate
- (void)chatListCellDeleteDelegate:(ChatList_Cell *)cell {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    NETResponse_ChatList_Result *chat = [DATA chatList].results[indexPath.row];
    
    [self requestDeleteChat:chat.letterId row:indexPath.row];
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


#pragma mark - private
- (void)requestPageTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _pageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_ChatList *collect = [[NETRequest_ChatList alloc] init];
    [collect loadPageIndex:[NSNumber numberWithInt:_pageIndex]
               pageSize:@20];
    [NET startRequestWithPort:YFY_NET_PORT_MESSAGE_LIST
                         code:YFY_NET_CODE_MESSAGE_LIST
                   parameters:collect.requestDic
                          tag:tag
                      reciver:self];
}
- (void)requestDeleteChat:(NSNumber *)letterId row:(int)row {
    NETRequest_DeleChat *dele = [[NETRequest_DeleChat alloc] init];
    [dele loadUserId:[DATA loginData].userId letterId:letterId];
    [NET startRequestWithPort:YFY_NET_PORT_DELE_MESSAGE
                         code:YFY_NET_CODE_DELE_MESSAGE
                   parameters:dele.requestDic
                          tag:[[NSNumber numberWithInt:row] stringValue]
                      reciver:self];
    [self showHUDTitle:nil];
}

- (void)resetFooterStyle {
    int count = [DATA chatList].results.count;
    int total = [[DATA chatList].totalSize integerValue];
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}


#pragma mark - network delegate
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_MESSAGE_LIST]) {
        [self.refreshView stopLoading];
        [self hideLoadingView];
        
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_ChatList *res = [[NETResponse_ChatList alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [DATA setChatList:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.mainTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([DATA chatList]) { //如果已存在，添加信息
                NETResponse_ChatList *res = [DATA chatList];
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.mainTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_ChatList *res = [[NETResponse_ChatList alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [DATA setChatList:res];
                [self.mainTableView reloadData];
            }
        }
        [self resetFooterStyle];
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_MESSAGE]) {
        [self hideHUD:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tag intValue] inSection:0];
        NSMutableArray *results = [DATA chatList].results;
        
        [results removeObjectAtIndex:[tag intValue]];
        
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_MESSAGE_LIST]) {
        [self.refreshView stopLoading];
        [self setLoadingFail];
        
        NETResponse_ChatList *res = [[NETResponse_ChatList alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _pageIndex--;
        }
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_MESSAGE]) {
        [self hideHUD:0];
        
        NETResponse_Header *res = [[NETResponse_Header alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        [HUD showFaceText:res.rspDesc];
    }
}



@end








