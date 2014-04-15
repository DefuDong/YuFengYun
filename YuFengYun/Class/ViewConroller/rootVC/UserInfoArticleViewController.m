//
//  UserInfoArticleViewController.m
//  YuFengYun
//
//  Created by 董德富 on 14-1-3.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import "UserInfoArticleViewController.h"
#import "PullUpView.h"
#import "RefreshView.h"

#import "NetworkCenter.h"
#import "NETRequest_UserArticle.h"
#import "NETResponse_UserArcitle.h"

#import "UITableViewCell+Nib.h"
#import "CollectionArticle_Cell.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"


#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"


@interface UserInfoArticleViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  NetworkCenterDelegate
>
{
    unsigned _index;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PullUpView *pullUpView;
@property (nonatomic, strong) RefreshView *refreshView;


@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NETResponse_UserArcitle *article;

@end

@implementation UserInfoArticleViewController


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
    self.navigationBar.title = @"发表的文章";
    [self setBackNavButtonActionPop];
    
    __weak UserInfoArticleViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.tableView callBack:^{
        [wself requestArticle:kRequestTagNew];
    }];
    
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.tableView complete:^{
        int count = [self article].results.count;
        int total = [[self article].totalSize integerValue];
        if (count < total) {
            _index++;
            [wself requestArticle:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
    
    [self requestArticle:kRequestTagNew];
    [self showLoadingViewBelow:nil];
}
- (void)clearMemory {
    self.pullUpView = nil;
    self.refreshView = nil;
}
- (void)clickLoadingViewToRefresh {
    [self requestArticle:kRequestTagNew];
}


#pragma mark - private
- (void)requestArticle:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _index = 1;
    }
    
    NETRequest_UserArticle *request = [[NETRequest_UserArticle alloc] init];
    [request loadUserId:self.userId
              pageIndex:[NSNumber numberWithInt:_index]
               pageSize:@20];
    
    [NET startRequestWithPort:YFY_NET_PORT_USER_ARTICLE
                         code:YFY_NET_CODE_USER_ARTICLE
                   parameters:request.requestDic
                          tag:tag
                      reciver:self];
    self.pullUpView.type = PullUpViewTypeLoading;
}
- (void)resetFooterStyle {
    int count = self.article.results.count;
    int total = [self.article.totalSize integerValue];
    
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}


#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.article.results.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CollectionArticleCellCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = CollectionArticleCellIdentifier;
    
    CollectionArticle_Cell *cell = (CollectionArticle_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (CollectionArticle_Cell *)[UITableViewCell cellWithNibName:@"CollectionArticle_Cell"];
    }
    
    NETResponse_UserArcitle_Result *result = self.article.results[indexPath.row];
    [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.articleDeckblatt]];
    cell.titleLabel_.text = result.articleShortTitle;
    cell.userLabel.text = result.articleAuthorName;
    cell.longPress.enabled = NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NETResponse_UserArcitle_Result *result = self.article.results[indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:result.articleId];
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
    
    if ([port isEqualToString:YFY_NET_PORT_USER_ARTICLE]) {
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_UserArcitle *res = [[NETResponse_UserArcitle alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            self.article = res;
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.tableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if (self.article) { //如果已存在，添加信息
                NETResponse_UserArcitle *res = self.article;
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.tableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_UserArcitle *res = [[NETResponse_UserArcitle alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                self.article = res;
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
    
    if ([port isEqualToString:YFY_NET_PORT_USER_ARTICLE]) {
        
        NSString *errorText = header.rspDesc.length ? header.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _index--;
        }
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}



@end
