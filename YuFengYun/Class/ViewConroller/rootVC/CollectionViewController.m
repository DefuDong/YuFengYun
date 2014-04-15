//
//  CollectionViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-25.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionArticle_Cell.h"
#import "CollectionVideo_Cell.h"

#import "UITableViewCell+Nib.h"
#import "UIImageView+WebCache.h"
#import "RefreshView.h"
#import "PullUpView.h"
#import "DetailViewController.h"
#import "DDFSegmentControl.h"
#import "MJPhotoBrowser.h"
#import "VideoDetailViewController.h"


#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_Collections.h"
#import "NETResponse_Collections.h"
#import "NETResponse_Login.h"
#import "NETRequest_DeleCollection.h"
#import "NETResponse_DeleCollection.h"
#import "NETRequest_Media_Collections.h"
#import "NETResponse_Media_Collections.h"
#import "NETRequest_Media_UnCollect.h"
#import "NETRequest_Picture.h"
#import "NETResponse_Picture.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface CollectionViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  DDFSegmentControlDelegate,
  NetworkCenterDelegate,
  CollectionArticleCellDelegate,
  CollectionVideoCellDelegate
>
{
    unsigned _currentPage; // 0, 1, 2
    
    unsigned _articlePageIndex;
    unsigned _picturePageIndex;
    unsigned _videoPageIndex;
}

@property (nonatomic, strong) NSNumber *userId;

@property (weak, nonatomic) IBOutlet DDFSegmentControl *segmentControl;
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) PullUpView *pullUpView;

@property (nonatomic, strong) NETResponse_Collections *myCollections;
@property (nonatomic, strong) NETResponse_Media_Collections *pictureCollections;
@property (nonatomic, strong) NETResponse_Media_Collections *videoCollections;

@end
 
@implementation CollectionViewController

- (id)initWithUserId:(NSNumber *)userId {
    self = [super initFromNib];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBar.title = @"收藏";
    [self setBackNavButtonActionPop];
    
    self.segmentControl.titles = @[@"文章", @"图集", @"视频"];
    
    __weak CollectionViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.mainTableView callBack:^{
        if (_currentPage == 0) {
            [wself requestArticlePageTag:kRequestTagNew];
        }else if (_currentPage == 1) {
            [wself requestPicturePageTag:kRequestTagNew];
        }else if (_currentPage == 2) {
            [wself requestVideoPageTag:kRequestTagNew];
        }
        
    }];
    
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.mainTableView complete:^{
        if (_currentPage == 0) {
            int count = [self myCollections].results.count;
            int total = [[self myCollections].totalSize integerValue];
            if (count < total) {
                _articlePageIndex++;
                [wself requestArticlePageTag:kRequestTagAdd];
                wself.pullUpView.type = PullUpViewTypeLoading;
            }
        }else if (_currentPage == 1) {
            int count = [self pictureCollections].results.count;
            int total = [[self pictureCollections].totalSize integerValue];
            if (count < total) {
                _picturePageIndex++;
                [wself requestPicturePageTag:kRequestTagAdd];
                wself.pullUpView.type = PullUpViewTypeLoading;
            }
        }else if (_currentPage == 2) {
            int count = [self videoCollections].results.count;
            int total = [[self videoCollections].totalSize integerValue];
            if (count < total) {
                _videoPageIndex++;
                [wself requestVideoPageTag:kRequestTagAdd];
                wself.pullUpView.type = PullUpViewTypeLoading;
            }
        }
    }];
    
    if (self.userId) {
        [self requestArticlePageTag:kRequestTagNew];
        [self showLoadingViewBelow:nil];
    }else {
        if (![self myCollections]) {
            [self requestArticlePageTag:kRequestTagNew];
            [self showLoadingViewBelow:nil];
        }else {
            [self.mainTableView reloadData];
            [self resetFooterStyle];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *selectedIndexPath = [self.mainTableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.mainTableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
    }
}
- (void)clearMemory {
    self.refreshView = nil;
    self.pullUpView = nil;
}
- (void)clickLoadingViewToRefresh {
    [self requestArticlePageTag:kRequestTagNew];
}


#pragma mark - private
- (void)requestArticlePageTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _articlePageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_Collections *collect = [[NETRequest_Collections alloc] init];
    [collect loadUserId:(self.userId ? self.userId : [DATA loginData].userId)
              pageIndex:[NSNumber numberWithInt:_articlePageIndex]
               pageSize:@20];
    [NET startRequestWithPort:YFY_NET_PORT_COLLECTION
                         code:YFY_NET_CODE_COLLECTION
                   parameters:collect.requestDic
                          tag:tag reciver:self];
}
- (void)requestDeleteArticleCollection:(NSNumber *)articleId row:(int)row {
    NETRequest_DeleCollection *dele = [[NETRequest_DeleCollection alloc] init];
    [dele loadUserId:[DATA loginData].userId articleId:articleId];
    [NET startRequestWithPort:YFY_NET_PORT_DELE_COLLECTION
                         code:YFY_NET_CODE_DELE_COLLECTION
                   parameters:dele.requestDic
                          tag:[[NSNumber numberWithInt:row] stringValue]
                      reciver:self];
    [self showHUDTitle:nil];
}

- (void)requestPicturePageTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _picturePageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_Media_Collections *collect = [[NETRequest_Media_Collections alloc] init];
    [collect loadUserId:(self.userId ? self.userId : [DATA loginData].userId)
                   type:@"3"
              pageIndex:[NSNumber numberWithInt:_picturePageIndex]
               pageSize:@20];
    
    NSString *newTag = [NSString stringWithFormat:@"%@,3", tag];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_READ_COLLECT
                         code:nil
                   parameters:collect.requestDic
                          tag:newTag
                      reciver:self];
}
- (void)requestDeletePictureCollection:(NSNumber *)picId row:(int)row {
    
    NETRequest_Media_UnCollect *req = [[NETRequest_Media_UnCollect alloc] init];
    [req loadMediaId:picId type:@"3"];
    
    NSString *newTag = [NSString stringWithFormat:@"3,%d", row];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_DELE_COLLECT
                         code:nil
                   parameters:req.requestDic
                          tag:newTag
                      reciver:self];
    [self showHUDTitle:nil];
}

- (void)requestVideoPageTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _videoPageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_Media_Collections *collect = [[NETRequest_Media_Collections alloc] init];
    [collect loadUserId:(self.userId ? self.userId : [DATA loginData].userId)
                   type:@"4"
              pageIndex:[NSNumber numberWithInt:_videoPageIndex]
               pageSize:@20];
    
    NSString *newTag = [NSString stringWithFormat:@"%@,4", tag];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_READ_COLLECT
                         code:nil
                   parameters:collect.requestDic
                          tag:newTag
                      reciver:self];
}
- (void)requestDeleteVideoCollection:(NSNumber *)videoId row:(int)row {
    
    NETRequest_Media_UnCollect *req = [[NETRequest_Media_UnCollect alloc] init];
    [req loadMediaId:videoId type:@"4"];
    
    NSString *newTag = [NSString stringWithFormat:@"4,%d", row];
    
    [NET startRequestWithPort:YFY_NET_PORT_MEDIA_DELE_COLLECT
                         code:nil
                   parameters:req.requestDic
                          tag:newTag
                      reciver:self];
    [self showHUDTitle:nil];
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
    int count = 0, total = 0;
    if (_currentPage == 0) {
        count = [self myCollections].results.count;
        total = [[self myCollections].totalSize integerValue];
    }else if(_currentPage == 1) {
        count = [self pictureCollections].results.count;
        total = [[self pictureCollections].totalSize integerValue];
    }else if(_currentPage == 2) {
        count = [self videoCollections].results.count;
        total = [[self videoCollections].totalSize integerValue];
    }
    
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}


#pragma mark - segment delegate
- (void)DDFSegmentPressedIndex:(int)index {
    _currentPage = index;
    [self.mainTableView reloadData];
    if (_currentPage == 0) {
        if (![self myCollections]) {
            [self requestArticlePageTag:kRequestTagNew];
        }else {
            [self.mainTableView reloadData];
        }
    }else if (_currentPage == 1) {
        if (![self pictureCollections]) {
            [self requestPicturePageTag:kRequestTagNew];
        }else {
            [self.mainTableView reloadData];
        }
    }else if (_currentPage == 2) {
        if (![self videoCollections]) {
            [self requestVideoPageTag:kRequestTagNew];
        }else {
            [self.mainTableView reloadData];
        }
    }
}


#pragma mark - UITableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_currentPage == 0) {
        return [self myCollections].results.count;
    }else if (_currentPage == 1) {
        return [self pictureCollections].results.count;
    }else if (_currentPage == 2) {
        return [self videoCollections].results.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentPage == 0) {
        return CollectionArticleCellCellHeight;
    }else if (_currentPage == 1) {
        return CollectionVideoCellCellHeight;
    }else if (_currentPage == 2) {
        return CollectionVideoCellCellHeight;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_currentPage == 0) {
        static NSString *cellId = CollectionArticleCellIdentifier;
        CollectionArticle_Cell *cell = (CollectionArticle_Cell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (CollectionArticle_Cell *)[UITableViewCell cellWithNibName:@"CollectionArticle_Cell"];
        }
        
        NETResponse_Collections_Result *result = [self myCollections].results[indexPath.row];
        cell.titleLabel_.text = result.articleShortTitle;
        [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.articleDeckblatt]];
        cell.userLabel.text = result.articleAuthorName;
        
        if (!self.userId) {
            cell.delegate = self;
            cell.longPress.enabled = YES;
        }else {
            cell.longPress.enabled = NO;
        }
        
        return cell;
    }else {
        static NSString *cellId = CollectionVideoCellIdentifier;
        CollectionVideo_Cell *cell = (CollectionVideo_Cell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (CollectionVideo_Cell *)[UITableViewCell cellWithNibName:@"CollectionVideo_Cell"];
        }
        
        NETResponse_Media_Collections_Result *result = nil;
        if (_currentPage == 1) {
            result = [self pictureCollections].results[indexPath.row];
            cell.tagImageView.image = [UIImage imageNamed:@"picture_page_picture.png"];
        }else {
            result = [self videoCollections].results[indexPath.row];
            cell.tagImageView.image = [UIImage imageNamed:@"video_clock.png"];
        }
        [cell.imageView_ setImageWithURL:[NSURL URLWithString:result.objImage]];
        cell.titleLabel_.text = result.title;
        cell.timeLabel.text = result.obj;
        
        if (!self.userId) {
            cell.delegate = self;
            cell.longPress.enabled = YES;
        }else {
            cell.longPress.enabled = NO;
        }
        
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_currentPage == 0) {
        NETResponse_Collections_Result *result = [self myCollections].results[indexPath.row];
        DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:result.articleId];
        [self.navigationController pushViewController:detail animated:YES];
    }else if (_currentPage == 1) {
        
        NETResponse_Media_Collections_Result *result = [self pictureCollections].results[indexPath.row];
        [self requestPictures:result.articleId];
        
    }else if (_currentPage == 2) {
        NETResponse_Media_Collections_Result *result = [self videoCollections].results[indexPath.row];
        
        VideoDetailViewController *video = [[VideoDetailViewController alloc] initWithVideoId:result.articleId];
        [self.navigationController pushViewController:video animated:YES];
    }
}

- (void)collectionArticleCellDelete:(CollectionArticle_Cell *)cell {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    NETResponse_Collections_Result *discuss = [self myCollections].results[indexPath.row];
    
    [self requestDeleteArticleCollection:discuss.articleId row:indexPath.row];
}
- (void)collectionVideoCellDelete:(CollectionVideo_Cell *)cell {
    if (_currentPage == 1) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
        NETResponse_Media_Collections_Result *pic = [self pictureCollections].results[indexPath.row];
        
        [self requestDeletePictureCollection:pic.articleId row:indexPath.row];
    }else if (_currentPage == 2) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
        NETResponse_Media_Collections_Result *video = [self videoCollections].results[indexPath.row];
        
        [self requestDeleteVideoCollection:video.articleId row:indexPath.row];
    }
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
    
    if ([port isEqualToString:YFY_NET_PORT_COLLECTION]) {
        [self.refreshView stopLoading];
        [self hideLoadingView];
        
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_Collections *res = [[NETResponse_Collections alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [self setMyCollections:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.mainTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([self myCollections]) { //如果已存在，添加信息
                NETResponse_Collections *res = [self myCollections];
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.mainTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_Collections *res = [[NETResponse_Collections alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [self setMyCollections:res];
                [self.mainTableView reloadData];
            }
        }
        [self resetFooterStyle];
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_READ_COLLECT]) {
        [self.refreshView stopLoading];
        
        if ([tag hasSuffix:@"3"]) {
            if ([tag hasPrefix:kRequestTagNew]) {
                NETResponse_Media_Collections *res = [[NETResponse_Media_Collections alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                [self setPictureCollections:res];
                
                if ([res.totalSize intValue] == 0) {
                    [HUD showText:@"没有更多"];
                }
                
                [self.mainTableView reloadData];
            }
            else if ([tag hasPrefix:kRequestTagAdd]) {
                if ([self pictureCollections]) { //如果已存在，添加信息
                    NETResponse_Media_Collections *res = [self pictureCollections];
                    [res addResponseDic:dic[YFY_NET_DATA]];
                    res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                    
                    [self.mainTableView reloadData];
                }else {//不存在，第一次请求，
                    NETResponse_Media_Collections *res = [[NETResponse_Media_Collections alloc] init];
                    res.responseDic = [dic objectForKey:YFY_NET_DATA];
                    res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                    
                    [self setPictureCollections:res];
                    [self.mainTableView reloadData];
                }
            }
        }else if ([tag hasSuffix:@"4"]) {
            if ([tag hasPrefix:kRequestTagNew]) {
                NETResponse_Media_Collections *res = [[NETResponse_Media_Collections alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                [self setVideoCollections:res];
                
                if ([res.totalSize intValue] == 0) {
                    [HUD showText:@"没有更多"];
                }
                
                [self.mainTableView reloadData];
            }
            else if ([tag hasPrefix:kRequestTagAdd]) {
                if ([self videoCollections]) { //如果已存在，添加信息
                    NETResponse_Media_Collections *res = [self videoCollections];
                    [res addResponseDic:dic[YFY_NET_DATA]];
                    res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                    
                    [self.mainTableView reloadData];
                }else {//不存在，第一次请求，
                    NETResponse_Media_Collections *res = [[NETResponse_Media_Collections alloc] init];
                    res.responseDic = [dic objectForKey:YFY_NET_DATA];
                    res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                    
                    [self setVideoCollections:res];
                    [self.mainTableView reloadData];
                }
            }
            [self resetFooterStyle];
        }
        
    }
    
    else if ([port isEqualToString:YFY_NET_PORT_DELE_COLLECTION]) {
        [self hideHUD:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tag intValue] inSection:0];
        NSMutableArray *results = [self myCollections].results;
        
        [results removeObjectAtIndex:[tag intValue]];
        
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_DELE_COLLECT]) {
        [self hideHUD:0];
        
        NSArray *arr = [tag componentsSeparatedByString:@","];
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[arr[1] intValue] inSection:0];
        
        if ([arr[0] isEqualToString:@"3"]) {
            NSMutableArray *results = [self pictureCollections].results;
            [results removeObjectAtIndex:[arr[1] intValue]];

        }else if ([arr[0] isEqualToString:@"4"]) {
            NSMutableArray *results = [self videoCollections].results;
            [results removeObjectAtIndex:[arr[1] intValue]];
        }
        
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
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
    
    if ([port isEqualToString:YFY_NET_PORT_COLLECTION]) {
        [self.refreshView stopLoading];
        [self setLoadingFail];
        
        NETResponse_Collections *res = [[NETResponse_Collections alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _articlePageIndex--;
        }
    }
    else if ([port isEqualToString:YFY_NET_PORT_MEDIA_READ_COLLECT]) {
        [self.refreshView stopLoading];
        
        NETResponse_Media_Collections *collections = [[NETResponse_Media_Collections alloc] init];
        collections.responseDic = [dic objectForKey:YFY_NET_DATA];
        collections.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        [HUD showFaceText:collections.responseHeader.rspDesc];
        
        if ([tag hasSuffix:@"3"]) {
            if ([tag isEqualToString:kRequestTagAdd]) {
                _picturePageIndex--;
            }
        }else if ([tag hasSuffix:@"4"]) {
            if ([tag isEqualToString:kRequestTagAdd]) {
                _videoPageIndex--;
            }
        }
    }
    
    else if ([port isEqualToString:YFY_NET_PORT_DELE_COLLECTION] ||
             [port isEqualToString:YFY_NET_PORT_MEDIA_DELE_COLLECT]) {
        [self hideHUD:0];
        
        NETResponse_Header *res = [[NETResponse_Header alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        [HUD showFaceText:res.rspDesc];
    }
    else if ([port isEqualToString:YFY_NET_PORT_PICTURE]) {
        [self hideHUD:0];
        
        NETResponse_Header *rsp = [[NETResponse_Header alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *error = rsp.rspDesc.length ? rsp.rspDesc : @"没有数据";
        [HUD showFaceText:error];
    }
}


@end
