//
//  SearchViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "SearchViewController.h"
#import "PullUpView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "DetailViewController.h"
#import "UserInfoViewController.h"
#import "VideoDetailViewController.h"
#import "MJPhotoBrowser.h"

#import "UITableViewCell+Nib.h"
#import "SearchUser_Cell.h"
#import "CollectionArticle_Cell.h"
#import "CollectionVideo_Cell.h"

#import "DataCenter.h"
#import "NETResponse_Login.h"
#import "NetworkCenter.h"
#import "NETRequest_SearchArticle.h"
#import "NETRequest_SearchUser.h"
#import "NETResponse_SearchArticle.h"
#import "NETResponse_SearchUser.h"
#import "NETRequest_SearchMedia.h"
#import "NETResponse_SearchMedia.h"
#import "NETRequest_Picture.h"
#import "NETResponse_Picture.h"


#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface SearchViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  UISearchDisplayDelegate,
  NetworkCenterDelegate
>
{
    unsigned _articlePageIndex;
    unsigned _userPageIndex;
    unsigned _pictureIndex;
    unsigned _videoIndex;
}

@property (nonatomic, strong) NETResponse_SearchArticle *articleSearch;
@property (nonatomic, strong) NETResponse_SearchUser *userSearch;
@property (nonatomic, strong) NETResponse_SearchMedia *pictureSearch;
@property (nonatomic, strong) NETResponse_SearchMedia *videoSearch;

@property (nonatomic, strong) PullUpView *pullUpView;

@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBar.title = @"搜索";
    [self setBackNavButtonActionPop];
    
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.backgroundColor = kRGBColor(243, 243, 243);
    
    __weak SearchViewController *wself = self;
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.searchDisplayController.searchResultsTableView complete:^{
        
        int index = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
                                                   
       if (index == 0) {
           int count = wself.articleSearch.results.count;
           int total = [wself.articleSearch.totalSize integerValue];
           if (count < total) {
               _articlePageIndex++;
               [wself searchArticle:wself.searchDisplayController.searchBar.text tag:kRequestTagAdd];
               wself.pullUpView.type = PullUpViewTypeLoading;
           }
       }
       else if (index == 1) {
           int count = wself.userSearch.results.count;
           int total = [wself.userSearch.totalSize integerValue];
           if (count < total) {
               _userPageIndex++;
               [wself searchUser:wself.searchDisplayController.searchBar.text tag:kRequestTagAdd];
               wself.pullUpView.type = PullUpViewTypeLoading;
           }
       }
       else if (index == 2) {
           int count = wself.pictureSearch.results.count;
           int total = [wself.pictureSearch.totalSize integerValue];
           if (count < total) {
               _pictureIndex++;
               [wself searchPicture:wself.searchDisplayController.searchBar.text tag:kRequestTagAdd];
               wself.pullUpView.type = PullUpViewTypeLoading;
           }
       }
       else if (index == 3) {
           int count = wself.videoSearch.results.count;
           int total = [wself.videoSearch.totalSize integerValue];
           if (count < total) {
               _videoIndex++;
               [wself searchVideo:wself.searchDisplayController.searchBar.text tag:kRequestTagAdd];
               wself.pullUpView.type = PullUpViewTypeLoading;
           }
       }
    }];
}



#pragma mark - private
- (void)searchArticle:(NSString *)text tag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _articlePageIndex = 1;
        [self showHUDTitle:nil];
    }
    NETRequest_SearchArticle *request = [[NETRequest_SearchArticle alloc] init];
    [request loadUserId:[DATA loginData].userId
                keyword:text
              pageIndex:[NSNumber numberWithInt:_articlePageIndex]
               pageSize:@20];
    [NET startRequestWithPort:YFY_NET_PORT_SEARCH_ARTICLE
                         code:YFY_NET_CODE_SEARCH_ARTICLE
                   parameters:request.requestDic
                          tag:tag
                      reciver:self];
}
- (void)searchUser:(NSString *)text tag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _userPageIndex = 1;
        [self showHUDTitle:nil];
    }
    NETRequest_SearchUser *request = [[NETRequest_SearchUser alloc] init];
    [request loadUserId:[DATA loginData].userId
                keyword:text
              pageIndex:[NSNumber numberWithInt:_userPageIndex]
               pageSize:@20];
    [NET startRequestWithPort:YFY_NET_PORT_SEARCH_USER
                         code:YFY_NET_CODE_SEARCH_USER
                   parameters:request.requestDic
                          tag:tag
                      reciver:self];
}
- (void)searchPicture:(NSString *)text tag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _pictureIndex = 1;
        [self showHUDTitle:nil];
    }
    NETRequest_SearchMedia *request = [[NETRequest_SearchMedia alloc] init];
    [request loadKeyword:text
                    type:@"3"
               pageIndex:[NSNumber numberWithInt:_pictureIndex]
                pageSize:@20];
    
    NSString *newTag = [NSString stringWithFormat:@"3,%@", tag];
    
    [NET startRequestWithPort:YFY_NET_PORT_SEARCH_MEDIA
                         code:nil
                   parameters:request.requestDic
                          tag:newTag
                      reciver:self];
}
- (void)searchVideo:(NSString *)text tag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _videoIndex = 1;
        [self showHUDTitle:nil];
    }
    NETRequest_SearchMedia *request = [[NETRequest_SearchMedia alloc] init];
    [request loadKeyword:text
                    type:@"4"
               pageIndex:[NSNumber numberWithInt:_videoIndex]
                pageSize:@20];
    
    NSString *newTag = [NSString stringWithFormat:@"4,%@", tag];
    
    [NET startRequestWithPort:YFY_NET_PORT_SEARCH_MEDIA
                         code:nil
                   parameters:request.requestDic
                          tag:newTag
                      reciver:self];
}

- (void)requestPictures:(NSNumber *)atlasId  {
    NETRequest_Picture *req = [[NETRequest_Picture alloc] init];
    [req loadAtlasId:atlasId];
    [NET startRequestWithPort:YFY_NET_PORT_PICTURE
                         code:nil
                   parameters:req.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}


- (void)resetFooterStyle {
    int count = 0;
    int total = 0;
    
    int index = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    
    if (index == 0) {
        count = self.articleSearch.results.count;
        total = [self.articleSearch.totalSize integerValue];
    }
    else if (index == 1) {
        count = self.userSearch.results.count;
        total = [self.userSearch.totalSize integerValue];
    }
    else if (index == 2) {
        count = self.pictureSearch.results.count;
        total = [self.pictureSearch.totalSize integerValue];
    }
    else if (index == 3) {
        count = self.videoSearch.results.count;
        total = [self.videoSearch.totalSize integerValue];
    }

    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}
- (NSString *)timeWithString:(NSString *)string {
    if (string.length == 0) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSDate *date = [formatter dateFromString:string];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd  HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}


#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int index = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    if (index == 0) 
        return self.articleSearch.results.count;
    else if (index == 1)
        return self.userSearch.results.count;
    else if (index == 2)
        return self.pictureSearch.results.count;
    else if (index == 3)
        return self.videoSearch.results.count;
    else return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    if (index == 0) return CollectionArticleCellCellHeight;
    else if (index == 1) return SearchUserCellHeight;
    else if (index == 2) return CollectionVideoCellCellHeight;
    else if (index == 3) return CollectionVideoCellCellHeight;
    else return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    if (index == 0) {
        static NSString *CellIdentifier = CollectionArticleCellIdentifier;
        
        CollectionArticle_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = (CollectionArticle_Cell *)[UITableViewCell cellWithNibName:@"CollectionArticle_Cell"];
        }
        
        NETResponse_SearchArticle_Result *result = self.articleSearch.results[indexPath.row];
    
        [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.articleDeckblatt]];
        cell.titleLabel_.text = result.articleShortTitle;
        cell.userLabel.text = result.articleAuthor;
        cell.longPress.enabled = NO;
        
        return cell;
    }
    else if (index == 1) {
        static NSString *cellId = SearchUserCellIdentifier;
        
        SearchUser_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (SearchUser_Cell *)[UITableViewCell cellWithNibName:@"SearchUser_Cell"];
        }
        
        NETResponse_SearchUser_Result *result = self.userSearch.results[indexPath.row];
        [cell.headButtn setImageWithURL:[NSURL URLWithString:result.userIcon] forState:UIControlStateNormal];
        cell.nameLabel.text = result.userNickName;
        cell.userTitleLabel.text = result.userTitle;
        
        return cell;
    }
    else if (index == 2) {
        static NSString *cellId = @"CollectionVideoCellIdentifier_3";
        
        CollectionVideo_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (CollectionVideo_Cell *)[UITableViewCell cellWithNibName:@"CollectionVideo_Cell"];
        }
        
        NETResponse_SearchMedia_Result *result = self.pictureSearch.results[indexPath.row];
        
        [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.mediaDeckblatt]];
        cell.titleLabel_.text = result.mediaTitle;
        cell.timeLabel.text = nil;
        cell.longPress.enabled = NO;
        cell.tagImageView.hidden = YES;
        
        return cell;
    }
    else if (index == 3) {
        static NSString *cellId = CollectionVideoCellIdentifier;
        
        CollectionVideo_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (CollectionVideo_Cell *)[UITableViewCell cellWithNibName:@"CollectionVideo_Cell"];
        }
        
        NETResponse_SearchMedia_Result *result = self.videoSearch.results[indexPath.row];
        
        [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.mediaDeckblatt]];
        cell.titleLabel_.text = result.mediaTitle;
        cell.timeLabel.text = result.vidDuration;
        cell.longPress.enabled = NO;
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    if (index == 0) {
        NETResponse_SearchArticle_Result *result = self.articleSearch.results[indexPath.row];
        DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:result.articleId];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (index == 1) {
        NETResponse_SearchUser_Result *result = self.userSearch.results[indexPath.row];
        UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:result.userId];
        [self.navigationController pushViewController:user animated:YES];
    }
    else if (index == 2) {
        NETResponse_SearchMedia_Result *result = self.pictureSearch.results[indexPath.row];
        [self requestPictures:result.mediaId];
    }
    else if (index == 3) {
        NETResponse_SearchMedia_Result *result = self.videoSearch.results[indexPath.row];
        VideoDetailViewController *video = [[VideoDetailViewController alloc] initWithVideoId:result.mediaId];
        [self.navigationController pushViewController:video animated:YES];
    }
}


#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullUpView tableViewDidScroll:self.searchDisplayController.searchResultsTableView];
}



#pragma mark - search bar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    int index = searchBar.selectedScopeButtonIndex;
    if (index == 0) {
        [self searchArticle:searchBar.text tag:kRequestTagNew];
    }else if (index == 1) {
        [self searchUser:searchBar.text tag:kRequestTagNew];
    }
    else if (index == 2) {
        [self searchPicture:searchBar.text tag:kRequestTagNew];
    }
    else if (index == 3) {
        [self searchVideo:searchBar.text tag:kRequestTagNew];
    }
}


#pragma mark - search display
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect navFrame = self.navigationBar.frame;
        navFrame.origin.y = -navFrame.size.height;
        self.navigationBar.frame = navFrame;
        
        CGRect searBarFrame = self.searchDisplayController.searchBar.frame;
        searBarFrame.origin.y = SYSTEM_VERSION_MOER_THAN_7 ? 20 : 0;
        self.searchDisplayController.searchBar.frame = searBarFrame;
    }];
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    CGRect navFrame = self.navigationBar.frame;
    navFrame.origin.y = 0;
    self.navigationBar.frame = navFrame;
    
    CGRect searBarFrame = self.searchDisplayController.searchBar.frame;
    searBarFrame.origin.y = navFrame.size.height;
    self.searchDisplayController.searchBar.frame = searBarFrame;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return NO;
}



#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self hideHUD:0];
    
    if ([port isEqualToString:YFY_NET_PORT_SEARCH_ARTICLE]) {

        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_SearchArticle *res = [[NETResponse_SearchArticle alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            self.articleSearch = res;
                        
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if (self.articleSearch) { //如果已存在，添加信息
                NETResponse_SearchArticle *res = self.articleSearch;
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.searchDisplayController.searchResultsTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_SearchArticle *res = [[NETResponse_SearchArticle alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                self.articleSearch = res;
                [self.searchDisplayController.searchResultsTableView reloadData];
            }
        }
        [self resetFooterStyle];
        
//        DEBUG_LOG(@"%@", self.articleSearch.results);
    }
    else if ([port isEqualToString:YFY_NET_PORT_SEARCH_USER]) {
        
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_SearchUser *res = [[NETResponse_SearchUser alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            self.userSearch = res;
            
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if (self.userSearch) { //如果已存在，添加信息
                NETResponse_SearchUser *res = self.userSearch;
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.searchDisplayController.searchResultsTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_SearchUser *res = [[NETResponse_SearchUser alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                self.userSearch = res;
                [self.searchDisplayController.searchResultsTableView reloadData];
            }
        }
        [self resetFooterStyle];
        
//        DEBUG_LOG(@"%@", self.userSearch.results);
    }
    else if ([port isEqualToString:YFY_NET_PORT_SEARCH_MEDIA]) {
        if ([tag hasPrefix:@"3"]) {
            
            if ([tag hasSuffix:kRequestTagNew]) {
                NETResponse_SearchMedia *res = [[NETResponse_SearchMedia alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                self.pictureSearch = res;
                
                [self.searchDisplayController.searchResultsTableView reloadData];
            }
            else if ([tag hasSuffix:kRequestTagAdd]) {
                if (self.pictureSearch) { //如果已存在，添加信息
                    NETResponse_SearchMedia *res = self.pictureSearch;
                    [res addResponseDic:dic[YFY_NET_DATA]];
                    res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                    
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }else {//不存在，第一次请求，
                    NETResponse_SearchMedia *res = [[NETResponse_SearchMedia alloc] init];
                    res.responseDic = [dic objectForKey:YFY_NET_DATA];
                    res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                    
                    self.pictureSearch = res;
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }
            }
            [self resetFooterStyle];
            
        }else if ([tag hasPrefix:@"4"]) {
            
            if ([tag hasSuffix:kRequestTagNew]) {
                NETResponse_SearchMedia *res = [[NETResponse_SearchMedia alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                self.videoSearch = res;
                
                [self.searchDisplayController.searchResultsTableView reloadData];
            }
            else if ([tag hasSuffix:kRequestTagAdd]) {
                if (self.videoSearch) { //如果已存在，添加信息
                    NETResponse_SearchMedia *res = self.videoSearch;
                    [res addResponseDic:dic[YFY_NET_DATA]];
                    res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                    
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }else {//不存在，第一次请求，
                    NETResponse_SearchMedia *res = [[NETResponse_SearchMedia alloc] init];
                    res.responseDic = [dic objectForKey:YFY_NET_DATA];
                    res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                    
                    self.videoSearch = res;
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }
            }
            [self resetFooterStyle];
            
        }
    }
    else if ([port isEqualToString:YFY_NET_PORT_PICTURE]) {
        [self hideHUD:0];
        
        NETResponse_Picture *rsp = [[NETResponse_Picture alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_DATA];
        rsp.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] initWithPictures:rsp];
        browser.currentPhotoIndex = 0;
        [self.navigationController pushViewController:browser animated:YES];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self hideHUD:0];
    
    NETResponse_Header *header = [[NETResponse_Header alloc] init];
    header.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    NSString *errorText = header.rspDesc.length ? header.rspDesc : @"加载失败";
    [HUD showFaceText:errorText];
    
    self.pullUpView.type = PullUpViewTypeNormal;
    
    if ([tag isEqualToString:kRequestTagAdd] || [tag hasSuffix:kRequestTagAdd]) {
        if ([port isEqualToString:YFY_NET_PORT_SEARCH_ARTICLE]) 
            _articlePageIndex--;
        else if ([port isEqualToString:YFY_NET_PORT_SEARCH_USER]) 
            _userPageIndex--;
        else if ([port isEqualToString:YFY_NET_PORT_SEARCH_MEDIA]) {
            if ([tag hasPrefix:@"3"]) _pictureIndex--;
            if ([tag hasPrefix:@"4"]) _videoIndex--;
        }
    }
}



@end










