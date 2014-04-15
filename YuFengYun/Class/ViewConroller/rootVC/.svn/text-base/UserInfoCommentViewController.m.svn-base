//
//  UserInfoCommentViewController.m
//  YuFengYun
//
//  Created by 董德富 on 14-1-3.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import "UserInfoCommentViewController.h"
#import "PullUpView.h"
#import "RefreshView.h"

#import "NetworkCenter.h"
#import "NETRequest_Disscuss.h"
#import "NETResponse_Disscuss.h"

#import "UITableViewCell+Nib.h"
#import "Discuss_Title_Cell.h"
#import "UIButton+WebCache.h"

#import "DetailViewController.h"
#import "UserInfoViewController.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface UserInfoCommentViewController ()
<
 UITableViewDataSource,
 UITableViewDelegate,
 NetworkCenterDelegate,
 NameReplayViewDelegate
>
{
    unsigned _discussPageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PullUpView *pullUpView;
@property (nonatomic, strong) RefreshView *refreshView;


@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NETResponse_Disscuss *discuss;


@end

@implementation UserInfoCommentViewController

- (id)initWithUserId:(NSNumber *)userId {
    self = [super initFromNib];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = @"参与的评论";
    [self setBackNavButtonActionPop];
    
    __weak UserInfoCommentViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.tableView callBack:^{
        [wself requestDiscuss:kRequestTagNew];
    }];
    
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.tableView complete:^{
        int count = [self discuss].results.count;
        int total = [[self discuss].totalSize integerValue];
        if (count < total) {
            _discussPageIndex++;
            [wself requestDiscuss:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
    
    [self requestDiscuss:kRequestTagNew];
    [self showLoadingViewBelow:nil];
}
- (void)clearMemory {
    self.pullUpView = nil;
    self.refreshView = nil;
}
- (void)clickLoadingViewToRefresh {
    [self requestDiscuss:kRequestTagNew];
}


#pragma mark - private
- (void)requestDiscuss:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _discussPageIndex = 1;
    }
    
    NETRequest_Disscuss *request = [[NETRequest_Disscuss alloc] init];
    [request loadUserId:self.userId
            commentType:@"1"
              pageIndex:[NSNumber numberWithInt:_discussPageIndex]
               pageSize:@20];
    
    [NET startRequestWithPort:YFY_NET_PORT_MY_DISSCUSS
                         code:YFY_NET_CODE_MY_DISSCUSS
                   parameters:request.requestDic
                          tag:tag
                      reciver:self];
    self.pullUpView.type = PullUpViewTypeLoading;
}
- (void)resetFooterStyle {
    int count = self.discuss.results.count;
    int total = [self.discuss.totalSize integerValue];
    
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}


#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.discuss.results.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NETResponse_Disscuss_Result *result = self.discuss.results[indexPath.row];
    return [Discuss_Title_Cell cellHeight:result.commentText];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = DiscussTitleCellIdentifier;
    
    Discuss_Title_Cell *cell = (Discuss_Title_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (Discuss_Title_Cell *)[UITableViewCell cellWithNibName:@"Discuss_Title_Cell"];
        cell.headButton.enabled = NO;
        cell.headButton.adjustsImageWhenDisabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *image = [UIImage imageNamed:@"article_button_back.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [cell.articleTitleButton setBackgroundImage:image forState:UIControlStateNormal];
        cell.articleTitleButton.tag = indexPath.row;
        [cell.articleTitleButton addTarget:self
                                    action:@selector(articleTitleButtonPressed:)
                          forControlEvents:UIControlEventTouchUpInside];
    }
    
    NETResponse_Disscuss_Result *replay = self.discuss.results[indexPath.row];
    [cell.headButton setImageWithURL:[NSURL URLWithString:replay.userIcon] forState:UIControlStateNormal];
    cell.nameView.tag = indexPath.row;
    cell.nameView.name = replay.commentUserName;
    cell.nameView.replayName = replay.commentObjUserName;
    cell.timeLabel.text = replay.commentTime;
    
    NSMutableAttributedString *_msgtext = [OHASFaceImageParser attributedStringByProcessingMarkupInString:replay.commentText];
    [_msgtext setFont:[UIFont systemFontOfSize:16]];
    cell.detailLabel.attributedText = _msgtext;
    cell.nameView.delegate = self;
    cell.longPress.enabled = NO;
    cell.articleTitleLabel.text = [NSString stringWithFormat:@"原文：%@", replay.articleShortTitle];
    cell.articleTitleButton.tag = indexPath.row;
    
    return cell;

}
- (void)nameReplayView:(NameReplayView *)replayView index:(unsigned int)index {
    if (index == 1) {
        NETResponse_Disscuss_Result *result = self.discuss.results[replayView.tag];
        
        UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:result.commentObjectId];
        [self.navigationController pushViewController:user animated:YES];
    }
}
- (void)articleTitleButtonPressed:(UIButton *)button {
    NETResponse_Disscuss_Result *replay = self.discuss.results[button.tag];
    DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:replay.articleId];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.refreshView scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshView scrollViewDidScroll:scrollView];
    [self.pullUpView tableViewDidScroll:(UITableView *)scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - network delegate
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self hideLoadingView];
    
    if ([port isEqualToString:YFY_NET_PORT_MY_DISSCUSS]) {
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_Disscuss *res = [[NETResponse_Disscuss alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            self.discuss = res;
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.tableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if (self.discuss) { //如果已存在，添加信息
                NETResponse_Disscuss *res = self.discuss;
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.tableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_Disscuss *res = [[NETResponse_Disscuss alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                self.discuss = res;
                [self.tableView reloadData];
            }
        }
        [self resetFooterStyle];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self setLoadingFail];
    
    NETResponse_Header *header = [[NETResponse_Header alloc] init];
    header.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    if ([port isEqualToString:YFY_NET_PORT_MY_DISSCUSS]) {
        
        NSString *errorText = header.rspDesc.length ? header.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _discussPageIndex--;
        }
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}


@end
