//
//  RegisterViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h> 
#import "TextLeftView.h"
#import "NETRequest_Register.h"
#import "NETResponse_Register.h"
#import "NetworkCenter.h"
#import "DataCenter.h"
#import "Utility.h"


#define kDefaultScrollViewHeight (self.view.frame.size.height-44)

@interface RegisterViewController ()
<
  UITextFieldDelegate,
  NetworkCenterDelegate
>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *nickTextField;
@property (nonatomic, weak) IBOutlet UITextField *passTextField;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, assign) BOOL isKeyboardShow;//键盘是否显示

@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBar.title = @"注册";
    [self setBackNavButtonActionPop];
    self.view.backgroundColor = kRGBColor(0, 147, 218);
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.leftView = [[TextLeftView alloc] initWithImage:@"login_left_email.png"];
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    self.nameTextField.layer.cornerRadius = 5;
    
    self.nickTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nickTextField.leftView = [[TextLeftView alloc] initWithImage:@"login_left_user.png"];
    self.nickTextField.backgroundColor = [UIColor whiteColor];
    self.nickTextField.layer.cornerRadius = 5;
    
    self.passTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passTextField.leftView = [[TextLeftView alloc] initWithImage:@"login_left_password.png"];
    self.passTextField.backgroundColor = [UIColor whiteColor];
    self.passTextField.layer.cornerRadius = 5;
    
    UIImage *registerBackImage = [UIImage imageNamed:@"round_button_back.png"];
    registerBackImage = [registerBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [self.registerButton setBackgroundImage:registerBackImage forState:UIControlStateNormal];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 310);
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
}
- (void)viewWillDisappear:(BOOL)animated  {
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
	[NOTI_CENTER removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[NOTI_CENTER removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NOTI_CENTER removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


#pragma mark - actions
- (IBAction)comfirmButtonPressed:(id)sender {
    
    if (![self isVaild]) return;
    
    [self.nameTextField resignFirstResponder];
    [self.nickTextField resignFirstResponder];
    [self.passTextField resignFirstResponder];
    
    NETRequest_Register *regist = [[NETRequest_Register alloc] init];
    [regist loadEmail:self.nameTextField.text
             nickName:self.nickTextField.text
                  pwd:[Utility MD5:self.passTextField.text]];
    [NET startRequestWithPort:YFY_NET_PORT_REGISTER
                         code:YFY_NET_CODE_REGISTER
                   parameters:regist.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}


#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)note {
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
                         CGRect rect = self.scrollView.frame;
                         rect.size.height = kDefaultScrollViewHeight - frame.size.height;
                         self.scrollView.frame = rect;
                     }
                     completion:^(BOOL finished) {self.isKeyboardShow = YES;}];
}
- (void)keyboardWillHide:(NSNotification *)note {
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
                         CGRect rect = self.scrollView.frame;
                         rect.size.height = kDefaultScrollViewHeight;
                         self.scrollView.frame = rect;
                     }
                     completion:NULL];
    self.isKeyboardShow = NO;
}
- (void)keyboardWillChange:(NSNotification *)note {
    if (self.isKeyboardShow) {
        NSDictionary *info = note.userInfo;
        CGRect frame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGRect rect = self.scrollView.frame;
        rect.size.height = kDefaultScrollViewHeight - frame.size.height;
        self.scrollView.frame = rect;
    }
}


#pragma mark - private
- (BOOL)isVaild {
    if (self.nameTextField.text.length == 0) {
        [HUD showFaceText:@"请输入账号"];
        return NO;
    }else {
        if (![Utility isValidEmail:self.nameTextField.text]) {
            [HUD showFaceText:@"账号输入错误"];
            return NO;
        }
    }
    
    if (self.nickTextField.text.length == 0) {
        [HUD showFaceText:@"请输入昵称"];
        return NO;
    }
    if (self.passTextField.text.length == 0) {
        [HUD showFaceText:@"请输入密码"];
        return NO;
    }
    
    return YES;
}
- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.scrollView scrollRectToVisible:textField.frame animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.nickTextField becomeFirstResponder];
    }
    if (textField == self.nickTextField) {
        [self.passTextField becomeFirstResponder];
    }
    if (textField == self.passTextField) {
        [self comfirmButtonPressed:self.registerButton];
    }
    return YES;
}


#pragma mark - network delegate
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self hideHUD:0];
    
    NETResponse_Register *registRes = [[NETResponse_Register alloc] init];
    registRes.responseDic = [dic objectForKey:YFY_NET_DATA];
    registRes.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    [HUD showText:@"注册成功，请前往注册邮箱确认"];
    [self performSelector:@selector(popVC) withObject:nil afterDelay:2];
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self hideHUD:0];
    
    NETResponse_Register *registRes = [[NETResponse_Register alloc] init];
//    registRes.responseDic = [dic objectForKey:YFY_NET_DATA];
    registRes.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    [HUD showFaceText:registRes.responseHeader.rspDesc];
}


@end





