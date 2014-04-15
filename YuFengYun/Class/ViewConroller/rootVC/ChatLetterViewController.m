//
//  ChatMessageViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-1.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "ChatLetterViewController.h"
#import "UIInputToolbar.h"
#import "BubbleView.h"
//#import "Chat_Bubble_Cell.h"
//#import "Chat_Bubble_Cell1.h"
#import "JSBubbleMessageCell.h"
#import "UITableViewCell+Nib.h"
#import "MessageSoundEffect.h"
#import "FaceBoard.h"
#import "UIButton+WebCache.h"
#import "UserInfoViewController.h"

#import "NetworkCenter.h"
#import "NETRequest_ChatLetter.h"
#import "NETResponse_ChatLetter.h"
#import "NETRequest_SendLetter.h"
#import "DataCenter.h"
#import "NETResponse_Login.h"


#define kDefaultToolbarHeight 40
#define kDefaultTableHeight (self.view.frame.size.height - kDefaultToolbarHeight - 44)

@interface ChatLetterViewController ()
<
  UIInputToolbarDelegate,
  UITableViewDataSource,
  UITableViewDelegate,
  NetworkCenterDelegate
>
@property (nonatomic, readwrite, strong) NSNumber *userId;
@property (nonatomic, readwrite, copy) NSString *nickName;
@property (nonatomic, strong) NSNumber *selfId;

@property (nonatomic, weak) IBOutlet UITableView *chatTableView;//表格

@property (nonatomic, strong) UIInputToolbar *inputToolbar;//输入框
@property (nonatomic, assign) BOOL isKeyboardShow;//键盘是否显示
@property (nonatomic, strong) FaceBoard *faceboard;


@property (nonatomic, strong) NETResponse_ChatLetter *chatData;

@end

@implementation ChatLetterViewController
- (UIInputToolbar *)inputToolbar {
    if (!_inputToolbar) {
        CGRect rect = CGRectMake(0,
                                 self.view.frame.size.height-kDefaultToolbarHeight,
                                 self.view.frame.size.width,
                                 kDefaultToolbarHeight);
        _inputToolbar = [[UIInputToolbar alloc] initWithFrame:rect];
        _inputToolbar.delegate = self;
        _inputToolbar.textView.placeholder = @"请输入内容...";
        _inputToolbar.textView.maximumNumberOfLines = 5;
    }
    return _inputToolbar;
}
- (FaceBoard *)faceboard {
    if (!_faceboard) {
        _faceboard = [[FaceBoard alloc] init];
        _faceboard.inputTextView = self.inputToolbar.textView.internalTextView;
    }
    return _faceboard;
}


- (id)initWithUserId:(NSNumber *)userId nickName:(NSString *)nickName {
    self = [super initFromNib];
    if (self) {
        self.userId = userId;
        self.nickName = nickName;
        self.selfId = [DATA loginData].userId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackNavButtonActionPop];
    self.navigationBar.title = self.nickName;

    /* Create toolbar */
    [self.view addSubview:self.inputToolbar];
    
    [self requestMessages];
    [self showLoadingViewBelow:nil];
    
    [DATA setChatPage:self];
}
- (void)viewWillAppear:(BOOL)animated  {
	[super viewWillAppear:animated];
	/* Listen for keyboard */
	[NOTI_CENTER addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//	[NOTI_CENTER addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [NOTI_CENTER addObserver:self selector:@selector(keyboardDidChange:)  name:UIKeyboardDidChangeFrameNotification object:nil];
    [NOTI_CENTER addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    CGRect rect = self.inputToolbar.frame;
    rect.origin.y = self.view.frame.size.height-kDefaultToolbarHeight;
    self.inputToolbar.frame = rect;
}
- (void)viewWillDisappear:(BOOL)animated  {
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
    [NOTI_CENTER removeObserver:self];
}
- (void)clearMemory {
    self.inputToolbar = nil;
    self.faceboard = nil;
}
- (void)clickLoadingViewToRefresh {
    [self requestMessages];
}


#pragma mark - input view delegate
- (void)inputButtonPressed:(NSString *)inputText {
    
    NETResponse_ChatLetter_Result *chat = [[NETResponse_ChatLetter_Result alloc] init];
    chat.letterSendUserName = [DATA loginData].userNickname;
    chat.letterReceiveUserName = self.nickName;
    chat.letterSendUserId = [DATA loginData].userId;
    chat.letterReceiveUserId = self.userId;
    chat.sendTime = @"";
    chat.letterText = inputText;
    if (self.chatData) {
//        if (self.chatData.results.count > 0) {
//            NETResponse_ChatLetter_Result *aResult = self.chatData.results[0];
//            chat.userIcon = aResult.userIcon;
//        }
        chat.userIcon = [DATA loginData].userIcon;
        [self.chatData.results insertObject:chat atIndex:0];
    }else {
        NETResponse_ChatLetter *chatLetter = [[NETResponse_ChatLetter alloc] init];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:chat];
        chatLetter.results = arr;
    }
    [self.chatTableView reloadData];
    [self scrollToBottomAnimated:YES];
    
    [self requestSendMenssage:inputText];
    [MessageSoundEffect playMessageSentSound];
} 
- (void)inputBar:(UIInputToolbar *)inputBar willChangeHeight:(float)height {
    if (self.isKeyboardShow) {
        float change = height - inputBar.frame.size.height;
        
        CGRect rect = self.chatTableView.frame;
        rect.size.height -= change;
        self.chatTableView.frame = rect;
        
        [self scrollToBottomAnimated:NO];
    }
}
- (void)faceoboardButtonPressed:(kInputType)type {
    if (type == kInputTypeKeyboard) {
        self.inputToolbar.textView.inputView = nil;
    }else {
        self.inputToolbar.textView.inputView = self.faceboard;
    }
    [self.inputToolbar.textView reloadInputViews];
}


#pragma mark - message 
- (void)newMessageReceived:(NSDictionary *)dic {
    
    NSString *nickName = [dic objectForKey:@"name"];
    NSNumber *userId = [dic objectForKey:@"id"];
    NSString *alert = [dic objectForKey:@"text"];
    
    if ([userId intValue] == [self.userId intValue]) {
        [MessageSoundEffect playMessageReceivedSound];
        
        NSString *inputText = alert;
        if ([alert hasPrefix:nickName]) {
            NSString *per = [NSString stringWithFormat:@"%@:", nickName];
            inputText = [alert stringByReplacingOccurrencesOfString:per withString:@""];
        }
        
        NETResponse_ChatLetter_Result *chat = [[NETResponse_ChatLetter_Result alloc] init];
        chat.letterSendUserName = self.nickName;
        chat.letterReceiveUserName = [DATA loginData].userNickname;
        chat.letterSendUserId = self.userId;
        chat.letterReceiveUserId = [DATA loginData].userId;
        chat.sendTime = @"";
        chat.letterText = inputText;
        if (self.chatData) {
            for (NETResponse_ChatLetter_Result *aResult in self.chatData.results) {
                if (![aResult.userIcon isEqualToString:[DATA loginData].userIcon]) {
                    chat.userIcon = aResult.userIcon;
                    break;
                }
            }
            [self.chatData.results insertObject:chat atIndex:0];
        }else {
            NETResponse_ChatLetter *chatLetter = [[NETResponse_ChatLetter alloc] init];
            NSMutableArray *arr = [NSMutableArray arrayWithObject:chat];
            chatLetter.results = arr;
        }
        [self.chatTableView reloadData];
        [self scrollToBottomAnimated:YES];
    }
}


#pragma mark - keyboard
/*
- (void)keyboardWillShow:(NSNotification *)note {
    
    if (self.isKeyboardShow) return;
    
//    DEBUG_LOG_FUN;
    NSDictionary *info = note.userInfo;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect frame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0
                        options:[curve intValue]
                     animations:^{
                         CGRect rect = self.chatTableView.frame;
                         rect.size.height = kDefaultTableHeight - frame.size.height;
                         self.chatTableView.frame = rect;
                         
                         CGRect inputRect = self.inputToolbar.frame;
                         inputRect.origin.y = self.view.frame.size.height - frame.size.height - inputRect.size.height;
                         self.inputToolbar.frame = inputRect;
                     }
                     completion:^(BOOL finished) {
                         [self scrollToBottomAnimated:YES];
                         [self addTableDissmissButton];
                         self.isKeyboardShow = YES;
                     }];
    
}
- (void)keyboardWillHide:(NSNotification *)note {
    
    if (!self.isKeyboardShow) return;
    
//    DEBUG_LOG_FUN;
    NSDictionary *info = note.userInfo;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    CGRect frame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0
                        options:[curve intValue]
                     animations:^{
                         CGRect rect = self.chatTableView.frame;
                         rect.size.height = kDefaultTableHeight;
                         self.chatTableView.frame = rect;
                         
                         CGRect inputRect = self.inputToolbar.frame;
                         inputRect.origin.y = self.view.frame.size.height - inputRect.size.height;
                         self.inputToolbar.frame = inputRect;
                     }
                     completion:NULL];
    self.isKeyboardShow = NO;
}
- (void)keyboardDidChange:(NSNotification *)note {
    
//    DEBUG_LOG_FUN;
    if (self.isKeyboardShow) {
        NSDictionary *info = note.userInfo;
        CGRect frame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGRect rect = self.chatTableView.frame;
        rect.size.height = kDefaultTableHeight - frame.size.height;
        self.chatTableView.frame = rect;
        
        CGRect inputRect = self.inputToolbar.frame;
        inputRect.origin.y = self.view.frame.size.height - frame.size.height - inputRect.size.height;
        self.inputToolbar.frame = inputRect;
        
        [self scrollToBottomAnimated:NO];
    }
}
*/
- (void)keyboardWillShow:(NSNotification *)note {
    [self addTableDissmissButton];
}
- (void)keyboardWillChange:(NSNotification *)note {
    NSDictionary *info = note.userInfo;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect begainFrame = [[info valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (CGRectEqualToRect(begainFrame, CGRectZero)) return;
    float changeHeight = 0;
    if (begainFrame.size.height == endFrame.size.height) {//show hide
        changeHeight = endFrame.origin.y - begainFrame.origin.y;
    }else {//change
        changeHeight = -(endFrame.size.height - begainFrame.size.height);
    }
    
    DEBUG_LOG_(@"\n%@\n%@\n%@\n%g", duration, NSStringFromCGRect(begainFrame), NSStringFromCGRect(endFrame), changeHeight);
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0
                        options:[curve intValue]
                     animations:^{
                         CGRect rect = self.chatTableView.frame;
                         rect.size.height += changeHeight;
                         self.chatTableView.frame = rect;
                         
                         CGRect inputRect = self.inputToolbar.frame;
                         inputRect.origin.y += changeHeight;
                         self.inputToolbar.frame = inputRect;
                     }
                     completion:^(BOOL finished) {}
     ];
}


#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatData.results.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = self.chatData.results.count - indexPath.row - 1;
    NETResponse_ChatLetter_Result *chatMess = self.chatData.results[index];
//    return [Chat_Bubble_Cell cellHeightWithText:chatMess.letterText];
    return [JSBubbleMessageCell cellHeightWithText:chatMess.letterText];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *cellID = @"chat";
//    Chat_Bubble_Cell *cell = (Chat_Bubble_Cell *)[tableView dequeueReusableCellWithIdentifier:cellID];
//    
//    if(!cell) {
//        cell = [[Chat_Bubble_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        [cell.bubbleView.headButton addTarget:self
//                                       action:@selector(headButtonPressed:)
//                             forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    int index = self.chatData.results.count - indexPath.row - 1;
//    NETResponse_ChatLetter_Result *chatMess = self.chatData.results[index];
//    if ([self.selfId intValue] == [chatMess.letterSendUserId intValue]) { //self
//        cell.bubbleView.style = BubbleMessageStyleSelf;
//        [cell.bubbleView.headButton setImageWithURL:[NSURL URLWithString:[DATA loginData].userIcon]
//                                           forState:UIControlStateNormal];
//    }else {
//        cell.bubbleView.style = BubbleMessageStyleOther;
//        [cell.bubbleView.headButton setImageWithURL:[NSURL URLWithString:chatMess.userIcon]
//                                           forState:UIControlStateNormal];
//    }
//    
//    cell.bubbleView.headButton.tag = index;
//    cell.bubbleView.text = chatMess.letterText;
//    
//    return cell;
    
    int index = self.chatData.results.count - indexPath.row - 1;
    NETResponse_ChatLetter_Result *chatMess = self.chatData.results[index];
    
    if ([self.selfId intValue] == [chatMess.letterSendUserId intValue]) { //self
        static NSString *cellID = @"cellID_out";
        JSBubbleMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[JSBubbleMessageCell alloc] initWithBubbleType:JSBubbleMessageTypeOutgoing reuseIdentifier:cellID];
            [cell.headButton addTarget:self
                            action:@selector(headButtonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
        }
        [cell.headButton setImageWithURL:[NSURL URLWithString:[DATA loginData].userIcon]
                                forState:UIControlStateNormal];
        cell.headButton.tag = index;
        cell.bubbleView.message = chatMess.letterText;
//        cell.bubbleView.messageLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }else {
        static NSString *cellID = @"cellID_in";
        JSBubbleMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[JSBubbleMessageCell alloc] initWithBubbleType:JSBubbleMessageTypeIncoming reuseIdentifier:cellID];
            [cell.headButton addTarget:self
                                action:@selector(headButtonPressed:)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        [cell.headButton setImageWithURL:[NSURL URLWithString:chatMess.userIcon]
                                forState:UIControlStateNormal];
        cell.headButton.tag = index;
        cell.bubbleView.message = chatMess.letterText;
//        cell.bubbleView.messageLabel.textColor = [UIColor blackColor];
        
        return cell;
    }
}

- (void)headButtonPressed:(HeadRoundButton *)button {
    int index = button.tag;
    NETResponse_ChatLetter_Result *chatMess = self.chatData.results[index];
    
    NSNumber *userId;
    if ([self.selfId intValue] == [chatMess.letterSendUserId intValue]) {
        userId = self.selfId;
    }else {
        userId = self.userId;
    }
    UserInfoViewController *user = [[UserInfoViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:user animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    int index = self.chatData.results.count - indexPath.row - 1;
    NETResponse_ChatLetter_Result *chatMess = self.chatData.results[index];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:chatMess.letterText];
}


#pragma mark - private
- (void)requestMessages {
    NETRequest_ChatLetter *request = [[NETRequest_ChatLetter alloc] init];
    [request loadReceiveUserId:self.userId pageIndex:@1 pageSize:@20];
    [NET startRequestWithPort:YFY_NET_PORT_MESSAGE_CHAT
                         code:YFY_NET_CODE_MESSAGE_CHAT
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
}
- (void)requestSendMenssage:(NSString *)text {
    NETRequest_SendLetter *request = [[NETRequest_SendLetter alloc] init];
    [request loadSendUserId:self.selfId receiveUserId:self.userId text:text];
//    [request loadSendUserId:self.userId receiveUserId:self.selfId text:text];
    
    [NET startRequestWithPort:YFY_NET_PORT_SEND_MESSAGE
                         code:YFY_NET_CODE_SEND_MESSAGE
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger rows = [self.chatTableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
    }
}
- (void)addTableDissmissButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.chatTableView.frame;
    [button addTarget:self action:@selector(inputResignFirstResponder:) forControlEvents:UIControlEventTouchDown];
    [self.view insertSubview:button belowSubview:self.inputToolbar];
}
- (void)inputResignFirstResponder:(UIButton *)button {
    [self.inputToolbar.textView resignFirstResponder];
    [button removeFromSuperview];
}



#pragma mark - network delegate
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    if ([port isEqualToString:YFY_NET_PORT_MESSAGE_CHAT]) {
        [self hideLoadingView];
        
        NETResponse_ChatLetter *rsp = [[NETResponse_ChatLetter alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_DATA];
        rsp.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        self.chatData = rsp;
        
        [self.chatTableView reloadData];
        [self scrollToBottomAnimated:NO];
    }
    if ([port isEqualToString:YFY_NET_PORT_SEND_MESSAGE]) {
        
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    NETResponse_Header *rsp = [[NETResponse_Header alloc] init];
    rsp.responseDic = [dic objectForKey:YFY_NET_DATA];
    
    [HUD showFaceText:rsp.rspDesc];
    
    if ([port isEqualToString:YFY_NET_PORT_MESSAGE_CHAT]) {
        [self setLoadingFail];
    }
    if ([port isEqualToString:YFY_NET_PORT_SEND_MESSAGE]) {
        
    }
}










@end
