//
//  DiscussViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-15.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "DiscussViewController.h"
#import "UIInputToolbar.h"
#import "Discuss_Cell.h"
#import "UITableViewCell+Nib.h"
#import "UIInputToolbar.h"
#import "RefreshView.h"
#import "PullUpView.h"
#import "UIButton+WebCache.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "FaceBoard.h"
#import "NumberView.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_PageDiscuss.h"
#import "NETResponse_PageDiscuss.h"
#import "NETResponse_Login.h"
#import "NETRequest_AddDisscuss.h"
#import "NETResponse_AddDisscuss.h"
#import "NETRequest_Media_Disscuss.h"


#define kDefaultToolbarHeight 40
#define kDefaultTableHeight (self.view.frame.size.height - 44)

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface DiscussViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  NameReplayViewDelegate,
  UIInputToolbarDelegate,
  NetworkCenterDelegate
>
{
    unsigned int _pageIndex;
}
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) UIInputToolbar *inputView;
@property (nonatomic, assign) BOOL isKeyboardShow;//键盘是否显示
@property (nonatomic, strong) FaceBoard *faceboard;

@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) PullUpView *pullUpView;

@property (nonatomic, strong) NSNumber *articleId;
@property (nonatomic, copy) NSString *articleType;
@property (nonatomic, strong) NETResponse_PageDiscuss_Result *replayed; //要回复的评论的信息

@end

@implementation DiscussViewController

- (UIInputToolbar *)inputView {
    if (!_inputView) {
        _inputView = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0,
                                                                      self.view.frame.size.height - kDefaultToolbarHeight,
                                                                      self.view.frame.size.width,
                                                                      kDefaultToolbarHeight)];
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


- (id)initWithArticleId:(NSNumber *)articleId type:(NSString *)type {
    self = [super initFromNib];
    if (self) {
        self.articleId = articleId;
        self.articleType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
//    self.navigationBar.title = @"评论";
    [self setNavTitleView];
    
    [self.view addSubview:self.inputView];
    
    __weak DiscussViewController *wself = self;
    self.refreshView = [[RefreshView alloc] initWithOwner:self.mainTableView callBack:^{
        [wself requestWithTag:kRequestTagNew];
    }];
    
    self.pullUpView = [[PullUpView alloc] initWithOwner:self.mainTableView complete:^{
        int count = [DATA pageDiscuss].results.count;
        int total = [[DATA pageDiscuss].totalSize integerValue];
        if (count < total) {
            _pageIndex++;
            [wself requestWithTag:kRequestTagAdd];
            wself.pullUpView.type = PullUpViewTypeLoading;
        }
    }];
    
    [self requestWithTag:kRequestTagNew];
    [self showLoadingViewBelow:nil];
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
    rect.origin.y = self.view.frame.size.height-kDefaultToolbarHeight;
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
    self.inputView = nil;
    self.refreshView = nil;
    self.articleId = nil;
    self.faceboard = nil;
}
- (void)dealloc {
    [DATA setPageDiscuss:nil];
}
- (void)clickLoadingViewToRefresh {
    [self requestWithTag:kRequestTagNew];
}


#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [DATA pageDiscuss].results.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NETResponse_PageDiscuss_Result *result = [DATA pageDiscuss].results[indexPath.row];
    return [Discuss_Cell cellHeight:result.commentText];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = DiscussCellIdentifier;
	
	Discuss_Cell *cell = (Discuss_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = (Discuss_Cell *)[UITableViewCell cellWithNibName:@"Discuss_Cell"];
	}
    
    NETResponse_PageDiscuss_Result *result = [DATA pageDiscuss].results[indexPath.row];
    
    [cell.headButton setImageWithURL:[NSURL URLWithString:result.userIcon] forState:UIControlStateNormal];
    cell.headButton.tag = indexPath.row;
    [cell.headButton addTarget:self action:@selector(headButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.nameView.tag = indexPath.row;
    cell.nameView.name = result.commentUserName;
    cell.nameView.replayName = result.commentObjUserName;
   
    NSMutableAttributedString *_msgtext = [OHASFaceImageParser attributedStringByProcessingMarkupInString:result.commentText];
    [_msgtext setFont:[UIFont systemFontOfSize:16]];
    cell.detailLabel.attributedText = _msgtext;
    
    cell.timeLabel.text = result.commentTime;
    cell.nameView.delegate = self;
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NETResponse_PageDiscuss_Result *result = [DATA pageDiscuss].results[indexPath.row];
    self.replayed = result;
    
    [self.inputView.textView.internalTextView becomeFirstResponder];
    self.inputView.textView.text = [NSString stringWithFormat:@"@%@:", result.commentUserName];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-300);
    [dismissButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventAllEvents];
    [self.view insertSubview:dismissButton belowSubview:self.inputView];
}

- (void)headButtonPressed:(id)sender {
    HeadRoundButton *head = (HeadRoundButton *)sender;
    NETResponse_PageDiscuss_Result *result = [DATA pageDiscuss].results[head.tag];
    
    UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:result.commentUserId];
    [self.navigationController pushViewController:user animated:YES];
}
- (void)nameReplayView:(NameReplayView *)replayView index:(unsigned int)index {
    NETResponse_PageDiscuss_Result *result = [DATA pageDiscuss].results[replayView.tag];
    
    NSNumber *userId = index ? result.commentObjectId : result.commentUserId;
    UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:user animated:YES];
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
//                         CGRect rect = self.mainTableView.frame;
//                         rect.size.height = kDefaultTableHeight - frame.size.height;
//                         self.mainTableView.frame = rect;
                         
                         CGRect inputRect = self.inputView.frame;
                         inputRect.origin.y = self.view.frame.size.height - frame.size.height - inputRect.size.height;
                         self.inputView.frame = inputRect;
                     }
                     completion:^(BOOL finished) {
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
//                         CGRect rect = self.mainTableView.frame;
//                         rect.size.height = kDefaultTableHeight;
//                         self.mainTableView.frame = rect;
                         
                         CGRect inputRect = self.inputView.frame;
                         inputRect.origin.y = self.view.frame.size.height - inputRect.size.height;
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
        
//        CGRect rect = self.mainTableView.frame;
//        rect.size.height = kDefaultTableHeight - frame.size.height;
//        self.mainTableView.frame = rect;
        
        CGRect inputRect = self.inputView.frame;
        inputRect.origin.y = self.view.frame.size.height - frame.size.height - inputRect.size.height;
        self.inputView.frame = inputRect;
    }
}


#pragma mark - input delegate
- (void)inputButtonPressed:(NSString *)inputText {
    
    if (self.replayed) { //回复评论
        
        NSString *head = [NSString stringWithFormat:@"@%@:", self.replayed.commentUserName];
        if ([inputText hasPrefix:head]) {
            inputText = [inputText stringByReplacingCharactersInRange:NSMakeRange(0, head.length) withString:@""];
            if (inputText.length == 0) {
                [HUD showFaceText:@"输入不能为空"];
                return;
            }
        }
        
        if ([DATA isLogin]) {
            [self requestAddDiscuss_to_replay:inputText];
            [self.inputView.textView resignFirstResponder];
        }else {
            __weak DiscussViewController *wself = self;
            [LoginViewController login:^(BOOL flag) {
                if (flag) {
                    [wself requestAddDiscuss_to_replay:inputText];
                    [wself.inputView.textView resignFirstResponder];
                }else {
//                    [HUD showFaceText:@"登录失败"];
                }
            }];
        }
        
    }else { //回复文章
        
        if ([DATA isLogin]) {
            [self requestAddDiscuss:inputText];
            [self.inputView.textView resignFirstResponder];
        }else {
            __weak DiscussViewController *wself = self;
            [LoginViewController login:^(BOOL flag) {
                if (flag) {
                    [wself requestAddDiscuss:inputText];
                    [wself.inputView.textView resignFirstResponder];
                }else {
//                    [HUD showFaceText:@"登录失败"];
                }
            }];
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


#pragma mark - private
- (void)requestWithTag:(NSString *)tag {
    if ([tag isEqualToString:kRequestTagNew]) {
        _pageIndex = 1;
        self.pullUpView.type = PullUpViewTypeNoMore;
    }
    
    if ([self.articleType isEqualToString:@"1"]) {
        NETRequest_PageDiscuss *request = [[NETRequest_PageDiscuss alloc] init];
        [request loadUserId:[DATA loginData].userId
                  articleId:self.articleId
                commentType:self.articleType
                  pageIndex:[NSNumber numberWithInt:_pageIndex]
                   pageSize:@20];
        [NET startRequestWithPort:YFY_NET_PORT_PAGE_DISCUSS
                             code:YFY_NET_CODE_PAGE_DISCUSS
                       parameters:request.requestDic
                              tag:tag
                          reciver:self];
    }
    else if ([self.articleType isEqualToString:@"3"]||
             [self.articleType isEqualToString:@"4"]) {
        NETRequest_Media_Disscuss *request = [[NETRequest_Media_Disscuss alloc] init];
        [request loadMediaId:self.articleId
                        type:self.articleType
                   pageIndex:[NSNumber numberWithInt:_pageIndex]
                    pageSize:@20];
        [NET startRequestWithPort:YFY_NET_PORT_MEDIA_DISCUSS
                             code:nil
                       parameters:request.requestDic
                              tag:tag
                          reciver:self];
    }
}
- (void)requestAddDiscuss:(NSString *)text {
    NETRequest_AddDisscuss *request = [[NETRequest_AddDisscuss alloc] init];
    [request loadArticleId:self.articleId
             commentUserId:[DATA loginData].userId
           commentObjectId:nil
               commentText:text
               commentType:self.articleType];
    [NET startRequestWithPort:YFY_NET_PORT_ADD_DISSCUSS
                         code:YFY_NET_CODE_ADD_DISSCUSS
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)requestAddDiscuss_to_replay:(NSString *)text {
    NETRequest_AddDisscuss *request = [[NETRequest_AddDisscuss alloc] init];
    [request loadArticleId:self.articleId
             commentUserId:[DATA loginData].userId
           commentObjectId:self.replayed.commentUserId
               commentText:text
               commentType:self.articleType];
    [NET startRequestWithPort:YFY_NET_PORT_ADD_DISSCUSS
                         code:YFY_NET_CODE_ADD_DISSCUSS
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}

- (void)resetFooterStyle {
    int count = [DATA pageDiscuss].results.count;
    int total = [[DATA pageDiscuss].totalSize integerValue];
    if (count >= total) {
        self.pullUpView.type = PullUpViewTypeNoMore;
    }else {
        self.pullUpView.type = PullUpViewTypeNormal;
    }
}
- (void)dismissKeyboard:(UIButton *)button {
    [self.inputView.textView resignFirstResponder];
    [button removeFromSuperview];
}
- (void)setNavTitleView {
    
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    nav.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    label.text = @"评论";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.backgroundColor = [UIColor clearColor];
    [nav addSubview:label];
    
    NumberView *number = [[NumberView alloc] initWithFrame:CGRectMake(120, 10, 46, 24)];
    number.number = [[DATA pageDiscuss].totalSize stringValue];
    [nav addSubview:number];
    
    self.navigationBar.titleView = nav;
}


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    [self hideLoadingView];
    
    if ([port isEqualToString:YFY_NET_PORT_PAGE_DISCUSS] || [port isEqualToString:YFY_NET_PORT_MEDIA_DISCUSS]) {
        if ([tag isEqualToString:kRequestTagNew]) {
            NETResponse_PageDiscuss *res = [[NETResponse_PageDiscuss alloc] init];
            res.responseDic = [dic objectForKey:YFY_NET_DATA];
            res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
            [DATA setPageDiscuss:res];
            
            if ([res.totalSize intValue] == 0) {
                [HUD showText:@"没有更多"];
            }
            
            [self.mainTableView reloadData];
            [self setNavTitleView];
        }
        else if ([tag isEqualToString:kRequestTagAdd]) {
            if ([DATA firstPage]) { //如果已存在，添加信息
                NETResponse_PageDiscuss *res = [DATA pageDiscuss];
                [res addResponseDic:dic[YFY_NET_DATA]];
                res.responseHeader.responseDic = dic[YFY_NET_RSP_HEADER];
                
                [self.mainTableView reloadData];
            }else {//不存在，第一次请求，
                NETResponse_PageDiscuss *res = [[NETResponse_PageDiscuss alloc] init];
                res.responseDic = [dic objectForKey:YFY_NET_DATA];
                res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
                
                [DATA setPageDiscuss:res];
                [self.mainTableView reloadData];
            }
        }
        [self resetFooterStyle];
    }
    else if ([port isEqualToString:YFY_NET_PORT_ADD_DISSCUSS]) {
        [self hideHUD:0];
        [HUD showText:@"评论成功"];
        
        self.replayed = nil;
        
        [self requestWithTag:kRequestTagNew];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self.refreshView stopLoading];
    
    if ([port isEqualToString:YFY_NET_PORT_PAGE_DISCUSS]) {
        
        [self setLoadingFail];
        NETResponse_PageDiscuss *res = [[NETResponse_PageDiscuss alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        NSString *errorText = res.responseHeader.rspDesc.length ? res.responseHeader.rspDesc : @"加载失败";
        [HUD showFaceText:errorText];
        if ([tag isEqualToString:kRequestTagAdd]) {
            _pageIndex--;
        }
    }
    else if ([port isEqualToString:YFY_NET_PORT_ADD_DISSCUSS]) {
        [self hideHUD:0];
        
        NETResponse_AddDisscuss *res = [[NETResponse_AddDisscuss alloc] init];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:res.responseHeader.rspDesc];
        
        self.replayed = nil;
    }
}



@end
