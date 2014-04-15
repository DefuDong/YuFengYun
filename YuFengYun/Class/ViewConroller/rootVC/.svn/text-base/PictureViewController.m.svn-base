//
//  PictureViewController.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-5.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "PictureViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "PictureCell.h"
#import "UITableViewCell+Nib.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
#import "RefreshView.h"
#import "PullUpView.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_PictureIndex.h"
#import "NETResponse_PictureIndex.h"
#import "NETResponse_Login.h"
#import "NETRequest_Picture.h"
#import "NETResponse_Picture.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface PictureViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  PictureCellDelegate,
  NetworkCenterDelegate
>{
    unsigned int _pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) PullUpView *pullUpView;

@end

@implementation PictureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self presetNav];
    
    __weak PictureViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.mainTableView callBack:^{
        [wself requestPageTag:kRequestTagNew];
    }];
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.mainTableView complete:^{
        int count = [DATA picturePage].results.count;
        int total = [[DATA picturePage].totalSize integerValue];
        if (count < total) {
            _pageIndex++;
            [wself requestPageTag:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
    if ([DATA picturePage]) {
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
    self.pullUpView = nil;
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

    self.navigationBar.title = @"图集";
    
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
    
    NETRequest_PictureIndex *req = [[NETRequest_PictureIndex alloc] init];
    [req loadUserId:[DATA loginData].userId
          pageIndex:[NSNumber numberWithUnsignedInt:_pageIndex]
           pageSize:@20];
    
    [NET startRequestWithPort:YFY_NET_PORT_PICTURE_INDEX
                         code:nil
                   parameters:req.requestDic
                          tag:tag
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
    int count = [DATA picturePage].results.count;
    int total = [[DATA picturePage].totalSize integerValue];
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
    int count = [DATA picturePage].results.count;
    return count/2 + count%2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PictureCellCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = PictureCellIdentifier;
    PictureCell *cell = (PictureCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (PictureCell *)[UITableViewCell cellWithNibName:@"PictureCell"];
    }
    
    int index = indexPath.row * 2;
    NSArray *results = [[DATA picturePage] results];
    NETResponse_PictureIndex_Result *result1 = [results objectAtIndex:index];
    NETResponse_PictureIndex_Result *result2 = nil;
    if (results.count > index+1) {
        result2 = [results objectAtIndex:index+1];
    }
    
    [cell.imageView_1 setImageWithURL:[NSURL URLWithString:result1.coverPhotoUrl]];
    cell.titleLabel_1.text = result1.atlasName;
    cell.pictureNumLabel_1.text = [result1.pics stringValue];
    cell.discussLabel_1.text = [result1.commentNum stringValue];
    
    if (result2) {
        
        [cell setBViewHidden:NO];
        
        [cell.imageView_2 setImageWithURL:[NSURL URLWithString:result2.coverPhotoUrl]];
        cell.titleLabel_2.text = result2.atlasName;
        cell.pictureNumLabel_2.text = [result2.pics stringValue];
        cell.discussLabel_2.text = [result2.commentNum stringValue];
    }else {
        [cell setBViewHidden:YES];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)pictureCell:(PictureCell *)cell tapAtIndex:(unsigned int)index {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    int picIndex = indexPath.row * 2 + index;
    
    NETResponse_PictureIndex_Result *result = [DATA picturePage].results[picIndex];
    [self requestPictures:result.atlasId];
    
    
    
//    PictureCell *cell = (PictureCell *)[tableView cellForRowAtIndexPath:indexPath];
//    
//    int count = _urls.count;
//    // 1.封装图片数据
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        // 替换为中等尺寸图片
//        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:url]; // 图片路径
//        photo.placeholder = cell.imageView_1.image;
//        [photos addObject:photo];
//    }
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    //    [browser show];
//    [self.navigationController pushViewController:browser animated:YES];

}


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self hideLoadingView];
    
    if ([port isEqualToString:YFY_NET_PORT_PICTURE_INDEX]) {
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_PictureIndex *res = [[NETResponse_PictureIndex alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [DATA setPicturePage:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.mainTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([DATA picturePage]) { //如果已存在，添加信息
                NETResponse_PictureIndex *res = [DATA picturePage];
                
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.mainTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_PictureIndex *res = [[NETResponse_PictureIndex alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [DATA setPicturePage:res];
                [self.mainTableView reloadData];
            }
        }
        [self resetFooterStyle];
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
    
    if ([port isEqualToString:YFY_NET_PORT_PICTURE_INDEX]) {
        [self.refreshView stopLoading];
        [self setLoadingFail];
        
        NETResponse_PictureIndex *res = [[NETResponse_PictureIndex alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _pageIndex--;
        }
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
