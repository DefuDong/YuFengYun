//
//  UserDiscussReplayViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-17.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "UserDiscussReplayViewController.h"
#import "DDFSegmentControl.h"
#import "Discuss_Title_Cell.h"
#import "UITableViewCell+Nib.h"
#import "UIButton+WebCache.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "DetailViewController.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_Disscuss.h"
#import "NETResponse_Disscuss.h"
#import "NETRequest_ReplayMe.h"
#import "NETResponse_ReplayMe.h"
#import "NETResponse_Login.h"
#import "NETRequest_DeleDisscuss.h"
#import "NETResponse_DeleDisscuss.h"
#import "NETRequest_AddDisscuss.h"
#import "NETResponse_AddDisscuss.h"

#import "RefreshView.h"
#import "PullUpView.h"
#import "UIInputToolbar.h"
#import "FaceBoard.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

#define kDefaultToolbarHeight 40
#define kDefaultTableHeight (self.view.frame.size.height - 44)

@interface UserDiscussReplayViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  DDFSegmentControlDelegate,
  NameReplayViewDelegate,
  NetworkCenterDelegate,
  DiscussCellDelegate,
  UIInputToolbarDelegate
>
{
    unsigned _currentPage; // 1, 2
    unsigned _discussPageIndex;
    unsigned _replayPageIndex;
}

@property (nonatomic, weak) IBOutlet DDFSegmentControl *discussReplayView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITableView *discussTableView;
@property (nonatomic, weak) IBOutlet UITableView *replayTableView;

@property (nonatomic, strong) RefreshView *discussRefreshView;
@property (nonatomic, strong) RefreshView *replayRefreshView;
@property (nonatomic, strong) PullUpView *discussPullUpView;
@property (nonatomic, strong) PullUpView *replayPullUpView;

@property (nonatomic, strong) UIInputToolbar *inputView;
@property (nonatomic, assign) BOOL isKeyboardShow;//键盘是否显示
@property (nonatomic, strong) FaceBoard *faceboard;

@property (nonatomic, strong) NETResponse_Disscuss_Result *replayDiscussResult;
@property (nonatomic, strong) NETResponse_ReplayMe_Result *replayReplayResult;

@end

@implementation UserDiscussReplayViewController
- (UIInputToolbar *)inputView {
    if (!_inputView) {
        _inputView = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height,
                                                                      self.view.frame.size.width,
                                                                      kDefaultToolbarHeight)];
        _inputView.delegate = self;
        _inputView.textView.placeholder = @"输入评论";
        _inputView.textView.maximumNumberOfLines = 5;
        _inputView.delegate = self;
    }
    return _inputView;
}
- (FaceBoard *)faceboard {
    if (!_faceboard) {
        _faceboard = [[FaceBoard alloc] init];
        _faceboard.inputTextView = self.inputView.textView.internalTextView;
    }
    return _faceboard;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"评论";
    self.view.backgroundColor = kRGBAColor(0, 147, 218, .99);
    
    [self.view addSubview:self.inputView];
    
    self.discussReplayView.titles = @[@"我的评论", @"回复我的"];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
    _currentPage = 1;
    
    __weak UserDiscussReplayViewController *wself = self;
    self.discussRefreshView = [[RefreshView alloc] initWithOwner:self.discussTableView callBack:^{
        [wself requestDisscussTag:kRequestTagNew];
    }];
    self.replayRefreshView = [[RefreshView alloc] initWithOwner:self.replayTableView callBack:^{
        [wself requestReplayTag:kRequestTagNew];
    }];
    
    self.discussPullUpView = [[PullUpView alloc] initWithOwner:self.discussTableView complete:^{
        int count = [DATA myDisscusses].results.count;
        int total = [[DATA myDisscusses].totalSize integerValue];
        if (count < total) {
            _discussPageIndex++;
            [wself requestDisscussTag:kRequestTagAdd];
            wself.discussPullUpView.type = PullUpViewTypeLoading;
        }
    }];
    self.replayPullUpView = [[PullUpView alloc] initWithOwner:self.replayTableView complete:^{
        int count = [DATA replayMe].results.count;
        int total = [[DATA replayMe].totalSize integerValue];
        if (count < total) {
            _replayPageIndex++;
            [wself requestReplayTag:kRequestTagAdd];
            wself.replayPullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
    [self requestDisscussTag:kRequestTagNew];
    [self showLoadingViewBelow:nil];
    [self performSelector:@selector(requestReplayTag:) withObject:kRequestTagNew afterDelay:.7];
//    [self performSelector:@selector(firstRequest) withObject:nil afterDelay:.5];
}
- (void)viewWillAppear:(BOOL)animated  {
	[super viewWillAppear:animated];
	/* Listen for keyboard */
	[NOTI_CENTER addObserver:self
                    selector:@selector(keyboardWillShow:)
                        name:UIKeyboardWillShowNotification
                      object:nil];
	[NOTI_CENTER addObserver:self
                    selector:@selector(keyboardWillHide:)
                        name:UIKeyboardWillHideNotification
                      object:nil];
    [NOTI_CENTER addObserver:self
                    selector:@selector(keyboardWillChange:)
                        name:UIKeyboardWillChangeFrameNotification
                      object:nil];
    
    CGRect rect = self.inputView.frame;
    rect.origin.y = self.view.frame.size.height;
    self.inputView.frame = rect;
}
- (void)viewWillDisappear:(BOOL)animated  {
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
	[NOTI_CENTER removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[NOTI_CENTER removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NOTI_CENTER removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)clearMemory {
    self.discussRefreshView = nil;
    self.replayRefreshView = nil;
    self.discussPullUpView = nil;
    self.replayPullUpView = nil;
    self.inputView = nil;
    self.faceboard = nil;
}
- (void)clickLoadingViewToRefresh {
    [self requestDisscussTag:kRequestTagNew];
}


#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    if (tableView == self.discussTableView) {
        return [DATA myDisscusses].results.count;
    }
    if (tableView == self.replayTableView) {
        return [DATA replayMe].results.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.discussTableView) {
        NETResponse_Disscuss_Result *discuss = [DATA myDisscusses].results[indexPath.row];
        return [Discuss_Title_Cell cellHeight:discuss.commentText];
    }
    if (tableView == self.replayTableView) {
        NETResponse_ReplayMe_Result *replay = [DATA replayMe].results[indexPath.row];
        return [Discuss_Title_Cell cellHeight:replay.commentText];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = DiscussTitleCellIdentifier;
	
	Discuss_Title_Cell *cell = (Discuss_Title_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = (Discuss_Title_Cell *)[UITableViewCell cellWithNibName:@"Discuss_Title_Cell"];
        UIImage *image = [UIImage imageNamed:@"article_button_back.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [cell.articleTitleButton setBackgroundImage:image forState:UIControlStateNormal];
        cell.articleTitleButton.tag = indexPath.row;
        [cell.articleTitleButton addTarget:self
                                    action:@selector(articleTitleButtonPressed:)
                          forControlEvents:UIControlEventTouchUpInside];
	}
    
    if (tableView == self.discussTableView) {
        NETResponse_Disscuss_Result *discuss = [DATA myDisscusses].results[indexPath.row];
        [cell.headButton setImageWithURL:[NSURL URLWithString:discuss.userIcon] forState:UIControlStateNormal];
        cell.headButton.tag = indexPath.row;
        [cell.headButton addTarget:self
                            action:@selector(headButtonPressed_1:)
                  forControlEvents:UIControlEventTouchUpInside];
        cell.nameView.tag = indexPath.row;
        cell.nameView.name = discuss.commentUserName;
        cell.nameView.replayName = discuss.commentObjUserName;
        cell.timeLabel.text = discuss.commentTime;
       
        NSMutableAttributedString *_msgtext = [OHASFaceImageParser attributedStringByProcessingMarkupInString:discuss.commentText];
        [_msgtext setFont:[UIFont systemFontOfSize:16]];
        cell.detailLabel.attributedText = _msgtext;
        
        cell.nameView.delegate = self;
        cell.longPress.enabled = YES;
        cell.articleTitleLabel.text = [NSString stringWithFormat:@"原文：%@", discuss.articleShortTitle];
        
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else if (tableView == self.replayTableView) {
        NETResponse_ReplayMe_Result *replay = [DATA replayMe].results[indexPath.row];
        [cell.headButton setImageWithURL:[NSURL URLWithString:replay.userIcon] forState:UIControlStateNormal];
        cell.headButton.tag = indexPath.row;
        [cell.headButton addTarget:self
                            action:@selector(headButtonPressed_2:)
                  forControlEvents:UIControlEventTouchUpInside];
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
        
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.delegate = self;
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-300);
    [dismissButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventAllEvents];
    [self.view insertSubview:dismissButton belowSubview:self.inputView];
    
    if (tableView == self.discussTableView) {
        
        NETResponse_Disscuss_Result *result = [DATA myDisscusses].results[indexPath.row];
        self.replayDiscussResult = result;        
        
        self.inputView.textView.text = [NSString stringWithFormat:@"@%@:", result.commentUserName];
        
        [self.discussTableView scrollToRowAtIndexPath:indexPath
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:YES];
    }
    if (tableView == self.replayTableView) {
        
        NETResponse_ReplayMe_Result *result = [DATA replayMe].results[indexPath.row];
        self.replayReplayResult = result;
        
        self.inputView.textView.text = [NSString stringWithFormat:@"@%@:", result.commentUserName];
        
        [self.replayTableView scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
    }
    
    [self.inputView.textView.internalTextView becomeFirstResponder];
}

#pragma mark cell content  
- (void)headButtonPressed_1:(id)sender {
    HeadRoundButton *head = (HeadRoundButton *)sender;
    NETResponse_Disscuss_Result *discuss = [DATA myDisscusses].results[head.tag];
    
    UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:discuss.commentUserId];
    [self.navigationController pushViewController:user animated:YES];
}
- (void)headButtonPressed_2:(id)sender {
    HeadRoundButton *head = (HeadRoundButton *)sender;
    NETResponse_ReplayMe_Result *replay = [DATA replayMe].results[head.tag];
    
    UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:replay.commentUserId];
    [self.navigationController pushViewController:user animated:YES];
}
- (void)articleTitleButtonPressed:(UIButton *)button {
    if (_currentPage == 1) {
        NETResponse_Disscuss_Result *discuss = [DATA myDisscusses].results[button.tag];
        DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:discuss.articleId];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (_currentPage == 2) {
        NETResponse_ReplayMe_Result *replay = [DATA replayMe].results[button.tag];
        DetailViewController *detail = [[DetailViewController alloc] initWithArticleId:replay.articleId];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)nameReplayView:(NameReplayView *)replayView index:(unsigned int)index {
    if (_currentPage == 1) {
        NETResponse_Disscuss_Result *discuss = [DATA myDisscusses].results[replayView.tag];
        
        NSNumber *userId = index ? discuss.commentObjectId : discuss.commentUserId;
        UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:userId];
        [self.navigationController pushViewController:user animated:YES];
    }
    else if (_currentPage == 2) {
        NETResponse_ReplayMe_Result *replay = [DATA replayMe].results[replayView.tag];
        
        NSNumber *userId = index ? replay.commentObjectId : replay.commentUserId;
        UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:userId];
        [self.navigationController pushViewController:user animated:YES];
    }
}

- (void)dismissKeyboard:(UIButton *)button {
    [self.inputView.textView resignFirstResponder];
    [button removeFromSuperview];
}

- (void)discussCellDeleteDelegate:(Discuss_Title_Cell *)cell {
    if (_currentPage == 1) {
        NSIndexPath *indexPath = [self.discussTableView indexPathForCell:cell];
        NETResponse_Disscuss_Result *discuss = [DATA myDisscusses].results[indexPath.row];
        
        [self requestDeleteDiscuss:discuss.commentId row:indexPath.row];
    }else if (_currentPage == 2) {
//        NSIndexPath *indexPath = [self.replayTableView indexPathForCell:cell];
//        NETResponse_ReplayMe_Result *replay = [DATA replayMe].results[indexPath.row];
//        
//        [self requestDeleteDiscuss:replay.commentId row:indexPath.row];
    }
}


#pragma mark - header delegate
- (void)DDFSegmentPressedIndex:(int)index {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*index, 0) animated:YES];
    _currentPage = index+1;
}

#pragma mark - input delegate
- (void)inputButtonPressed:(NSString *)inputText {
    
    if (_currentPage == 1) {
        if (self.replayDiscussResult) { //回复评论
            
            NSString *head = [NSString stringWithFormat:@"@%@:", self.replayDiscussResult.commentUserName];
            if ([inputText hasPrefix:head]) {
                inputText = [inputText stringByReplacingCharactersInRange:NSMakeRange(0, head.length) withString:@""];
                if (inputText.length == 0) {
                    [HUD showFaceText:@"输入不能为空"];
                    return;
                }
            }
            
            [self requestAddReplay_to_discuss:inputText];
            [self.inputView.textView resignFirstResponder];
            
        }
    }else if (_currentPage == 2) {
        if (self.replayReplayResult) { //回复评论
            
            NSString *head = [NSString stringWithFormat:@"@%@:", self.replayReplayResult.commentUserName];
            if ([inputText hasPrefix:head]) {
                inputText = [inputText stringByReplacingCharactersInRange:NSMakeRange(0, head.length) withString:@""];
                if (inputText.length == 0) {
                    [HUD showFaceText:@"输入不能为空"];
                    return;
                }
            }
            
            [self requestAddReplay_to_replay:inputText];
            [self.inputView.textView resignFirstResponder];
        }
    }
}
- (void)faceoboardButtonPressed:(kInputType)type {
    if (type == kInputTypeKeyboard) {
        self.inputView.textView.inputView = nil;
    }else {
        self.inputView.textView.inputView = self.faceboard;
    }
    [self.inputView.textView reloadInputViews];
}


#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.discussTableView) {
        [self.discussRefreshView scrollViewWillBeginDragging:scrollView];
    }
    else if (scrollView == self.replayTableView) {
        [self.replayRefreshView scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self.discussReplayView setPercent:(scrollView.contentOffset.x / scrollView.contentSize.width)];
    }
    else if (scrollView == self.discussTableView) {
        [self.discussRefreshView scrollViewDidScroll:scrollView];
        [self.discussPullUpView tableViewDidScroll:(UITableView *)scrollView];
    }
    else if (scrollView == self.replayTableView) {
        [self.replayRefreshView scrollViewDidScroll:scrollView];
        [self.replayPullUpView tableViewDidScroll:(UITableView *)scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.discussTableView) {
        [self.discussRefreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    else if (scrollView == self.replayTableView) {
        [self.replayRefreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)note {
    //    NSLog(@"%s", __func__);
    if (self.isKeyboardShow) {
        return;
    }
    NSDictionary *info = note.userInfo;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect frame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0
                        options:[curve intValue]
                     animations:^{
//                         CGRect rect = self.scrollView.frame;
//                         rect.size.height = kDefaultTableHeight - frame.size.height;
//                         self.scrollView.frame = rect;
                         
                         CGRect inputRect = self.inputView.frame;
                         inputRect.origin.y = self.view.frame.size.height - frame.size.height - inputRect.size.height;
                         self.inputView.frame = inputRect;
                     }
                     completion:^(BOOL finished) {
                         //                         [self scrollToBottomAnimated:YES];
                         self.isKeyboardShow = YES;
                     }];
}
- (void)keyboardWillHide:(NSNotification *)note {
    //    NSLog(@"%s", __func__);
    if (!self.isKeyboardShow) {
        return;
    }
    NSDictionary *info = note.userInfo;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    //    CGRect frame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0
                        options:[curve intValue]
                     animations:^{
//                         CGRect rect = self.scrollView.frame;
//                         rect.size.height = kDefaultTableHeight;
//                         self.scrollView.frame = rect;
                         
                         CGRect inputRect = self.inputView.frame;
                         inputRect.origin.y = self.view.frame.size.height;
                         self.inputView.frame = inputRect;
                     }
                     completion:NULL];
    self.isKeyboardShow = NO;
}
- (void)keyboardWillChange:(NSNotification *)note {
    //    NSLog(@"%s", __func__);
    if (self.isKeyboardShow) {
        NSDictionary *info = note.userInfo;
        CGRect frame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
//        CGRect rect = self.scrollView.frame;
//        rect.size.height = kDefaultTableHeight - frame.size.height;
//        self.scrollView.frame = rect;
        
        CGRect inputRect = self.inputView.frame;
        inputRect.origin.y = self.view.frame.size.height - frame.size.height - inputRect.size.height;
        self.inputView.frame = inputRect;        
    }
}


#pragma mark - private
/*
- (void)firstRequest {
    if ([DATA isLogin]) {
        [self requestDisscussTag:kRequestTagNew];
        [self requestReplayTag:kRequestTagNew];
    }else {
        __weak UserDiscussReplayViewController *wself = self;
        [LoginViewController login:^(BOOL flag) {
            if (flag) {
                [wself requestDisscussTag:kRequestTagNew];
                [wself requestReplayTag:kRequestTagNew];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
 */
- (void)requestDisscussTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _discussPageIndex = 1;
        self.discussPullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_Disscuss *discuss = [[NETRequest_Disscuss alloc] init];
    [discuss loadUserId:[DATA loginData].userId
            commentType:@"1"
              pageIndex:[NSNumber numberWithInt:_discussPageIndex]
               pageSize:@20];
    [NET startRequestWithPort:YFY_NET_PORT_MY_DISSCUSS
                         code:YFY_NET_CODE_MY_DISSCUSS
                   parameters:discuss.requestDic
                          tag:tag
                      reciver:self];
}
- (void)requestReplayTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _replayPageIndex = 1;
        self.replayPullUpView.type = PullUpViewTypeNoMore;
    }
    
    NETRequest_ReplayMe *replay = [[NETRequest_ReplayMe alloc] init];
    [replay loadUserId:[DATA loginData].userId
           commentType:@"1"
             pageIndex:[NSNumber numberWithInt:_replayPageIndex]
              pageSize:@20];
    [NET startRequestWithPort:YFY_NET_PORT_REPLY_ME
                         code:YFY_NET_CODE_REPLY_ME
                   parameters:replay.requestDic
                          tag:tag
                      reciver:self];
}
- (void)requestDeleteDiscuss:(NSNumber *)commentId row:(int)row {
    NETRequest_DeleDisscuss *dele = [[NETRequest_DeleDisscuss alloc] init];
    [dele loadUserId:[DATA loginData].userId commentId:commentId];
    [NET startRequestWithPort:YFY_NET_PORT_DELE_DISSCUSS
                         code:YFY_NET_CODE_DELE_DISSCUSS
                   parameters:dele.requestDic
                          tag:[[NSNumber numberWithInt:row] stringValue]
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)resetDiscussFooterStyle {
    int count = [DATA myDisscusses].results.count;
    int total = [[DATA myDisscusses].totalSize integerValue];
    if (count >= total) {
        self.discussPullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.discussPullUpView.type = PullUpViewTypeNormal;
    }
}
- (void)resetReplayFooterStyle {
    int count = [DATA replayMe].results.count;
    int total = [[DATA replayMe].totalSize integerValue];
    if (count >= total) {
        self.replayPullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.replayPullUpView.type = PullUpViewTypeNormal;
    }
}
- (void)requestAddReplay_to_discuss:(NSString *)text {
    NETRequest_AddDisscuss *request = [[NETRequest_AddDisscuss alloc] init];
    [request loadArticleId:self.replayDiscussResult.articleId
             commentUserId:[DATA loginData].userId
           commentObjectId:self.replayDiscussResult.commentUserId
               commentText:text
               commentType:@"1"];
    [NET startRequestWithPort:YFY_NET_PORT_ADD_DISSCUSS
                         code:YFY_NET_CODE_ADD_DISSCUSS
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)requestAddReplay_to_replay:(NSString *)text {
    NETRequest_AddDisscuss *request = [[NETRequest_AddDisscuss alloc] init];
    [request loadArticleId:self.replayReplayResult.articleId
             commentUserId:[DATA loginData].userId
           commentObjectId:self.replayReplayResult.commentUserId
               commentText:text
               commentType:@"1"];
    [NET startRequestWithPort:YFY_NET_PORT_ADD_DISSCUSS
                         code:YFY_NET_CODE_ADD_DISSCUSS
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.discussRefreshView stopLoading];
    [self.replayRefreshView stopLoading];
    
    if ([port isEqualToString:YFY_NET_PORT_MY_DISSCUSS]) {
        [self hideLoadingView];
        
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_Disscuss *res = [[NETResponse_Disscuss alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [DATA setMyDisscusses:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.discussTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([DATA myDisscusses]) { //如果已存在，添加信息
                NETResponse_Disscuss *res = [DATA myDisscusses];
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.discussTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_Disscuss *res = [[NETResponse_Disscuss alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [DATA setMyDisscusses:res];
                [self.discussTableView reloadData];
            }
        }
        [self resetDiscussFooterStyle];
    }
    else if ([port isEqualToString:YFY_NET_PORT_REPLY_ME]) {
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_ReplayMe *res = [[NETResponse_ReplayMe alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [DATA setReplayMe:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.replayTableView reloadData];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([DATA replayMe]) { //如果已存在，添加信息
                NETResponse_ReplayMe *res = [DATA replayMe];
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.replayTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_ReplayMe *res = [[NETResponse_ReplayMe alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [DATA setReplayMe:res];
                [self.replayTableView reloadData];
            }
        }
        [self resetReplayFooterStyle];
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_DISSCUSS]) {
        [self hideHUD:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tag intValue] inSection:0];
        NSMutableArray *results = [DATA myDisscusses].results;
        
        [results removeObjectAtIndex:[tag intValue]];
        
        [self.discussTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if ([port isEqualToString:YFY_NET_PORT_ADD_DISSCUSS]) {
        [self hideHUD:0];
        [HUD showText:@"评论成功"];
        
        self.replayDiscussResult = nil;
        self.replayReplayResult = nil;
//        [self requestDisscussTag:kRequestTagNew];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.discussRefreshView stopLoading];
    [self.replayRefreshView stopLoading];
    
    if ([port isEqualToString:YFY_NET_PORT_MY_DISSCUSS]) {
        [self setLoadingFail];
        
        NETResponse_Disscuss *res = [[NETResponse_Disscuss alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _discussPageIndex--;
        }
    }
    else if ([port isEqualToString:YFY_NET_PORT_REPLY_ME]) {
        NETResponse_ReplayMe *res = [[NETResponse_ReplayMe alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _replayPageIndex--;
        }
    }
    else if ([port isEqualToString:YFY_NET_PORT_DELE_DISSCUSS]) {
        [self hideHUD:0];
        [HUD showFaceText:@"删除操作失败"];
    }
    else if ([port isEqualToString:YFY_NET_PORT_ADD_DISSCUSS]) {
        [self hideHUD:0];
        
        NETResponse_AddDisscuss *res = [[NETResponse_AddDisscuss alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:res.responseHeader.rspDesc];
        
        self.replayReplayResult = nil;
        self.replayDiscussResult = nil;
    }
}



@end





