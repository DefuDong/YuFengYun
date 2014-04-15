//
//  LoginViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-16.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TextLeftView.h"
#import "RegisterViewController.h"
#import "RetrieveViewController.h"
#import "ShareCenter.h" //share
#import "UMSocial.h"
#import "MLNavigationController.h"

#import "NetworkCenter.h"
#import "NETRequest_Login.h"
#import "NETResponse_Login.h"
#import "NETRequest_SinaLogin.h"
#import "NetRequest_TencentLogin.h"
#import "Utility.h"
#import "Common.h"
#import "DataCenter.h"

#define kDefaultScrollViewHeight (self.view.frame.size.height-44)
#define kTomorrowInterval (24 * 60 * 60)

@interface LoginViewController ()
<
  NetworkCenterDelegate,
  UITextFieldDelegate
>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, assign) BOOL isKeyboardShow;//键盘是否显示

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarWithImageName:@"nav_back.png"
                                 target:self
                                 action:@selector(backButtonPressed)
                               position:CustomNavigationBarPositionLeft];
//    [self setBackNavButtonActionDismiss];
    self.navigationBar.title = @"登录";
    self.view.backgroundColor = kRGBColor(0, 147, 218);
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.leftView = [[TextLeftView alloc] initWithImage:@"login_left_user.png"];
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    self.nameTextField.layer.cornerRadius = 5;
    
    self.passTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passTextField.leftView = [[TextLeftView alloc] initWithImage:@"login_left_password.png"];
    self.passTextField.backgroundColor = [UIColor whiteColor];
    self.passTextField.layer.cornerRadius = 5;
    
    UIImage *loginBackImage = [UIImage imageNamed:@"round_button_back.png"];
    loginBackImage = [loginBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [self.loginButton setBackgroundImage:loginBackImage forState:UIControlStateNormal];
    
    UIImage *registerBackImage = [UIImage imageNamed:@"round_button_back.png"];
    registerBackImage = [registerBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [self.registerButton setBackgroundImage:registerBackImage forState:UIControlStateNormal];
    
    self.scrollView.contentSize = self.scrollView.frame.size;
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
    
    self.nameTextField.text = [USER_DEFAULT objectForKey:kUserNameKey];
}
- (void)viewWillDisappear:(BOOL)animated  {
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
	[NOTI_CENTER removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[NOTI_CENTER removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NOTI_CENTER removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


#pragma mark - actions
- (void)backButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
//    if (self.completeBlock) {
//        self.completeBlock(NO);
//    }
}
- (IBAction)loginButtonPressed:(id)sender {
    if (![self isValid]) {
        return;
    }

    NETRequest_Login *login = [[NETRequest_Login alloc] init];
    [login loadEmail:self.nameTextField.text
                 pwd:[Utility MD5:self.passTextField.text]
                type:@"1"
         deviceToken:[USER_DEFAULT objectForKey:kDeviceToken]];
    
    [NET startRequestWithPort:YFY_NET_PORT_LOGIN
                         code:YFY_NET_CODE_LOGIN
                   parameters:login.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
    [self.nameTextField resignFirstResponder];
    [self.passTextField resignFirstResponder];
    
    [USER_DEFAULT setObject:self.nameTextField.text forKey:kUserNameKey];
    [USER_DEFAULT synchronize];
}
- (IBAction)registerButtonPressed:(id)sender {
    RegisterViewController *regist = [[RegisterViewController alloc] initFromNib];
    [self.navigationController pushViewController:regist animated:YES];
}
- (IBAction)forgetPasswrodPressed:(id)sender {
    RetrieveViewController *forget = [[RetrieveViewController alloc] initFromNib];
    [self.navigationController pushViewController:forget animated:YES];
}
- (IBAction)tencentWeiboButtonPressed:(id)sender {
    //share
    __weak LoginViewController *wself = self;
    
    [[SHARE tencentWeibo] setRootViewController:self];
    [SHARE tencentTirdPartLogin:^(BOOL flag, NSError *error) {

        if (flag) {

            TCWBEngine *tencent = [SHARE tencentWeibo];
            int expire = tencent.expireTime - [[NSDate date] timeIntervalSince1970];
            
            NetRequest_TencentLogin *request = [[NetRequest_TencentLogin alloc] init];
            [request loadTokenId:tencent.accessToken
                          openid:tencent.openId
                         openkey:tencent.openKey
                       expiresIn:[[NSNumber numberWithInt:expire] stringValue]];

            [NET startRequestWithPort:YFY_NET_PORT_TENCENT_LOGIN
                                 code:nil
                           parameters:request.requestDic
                                  tag:nil
                              reciver:wself];
            [wself showHUDTitle:nil];
        }else {
            [HUD showFaceText:[error localizedDescription]];
        }
    }];

    
    /*
    __weak LoginViewController *wself = self;

    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeTenc];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
//            NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
            
            if ([platformName isEqualToString:UMShareToTencent]) {
                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
//                    NSLog(@"get openid  response is %@",respose);
                    
                    NetRequest_TencentLogin *request = [[NetRequest_TencentLogin alloc] init];
                    [request loadTokenId:snsAccount.accessToken
                                  openid:[respose.data objectForKey:@"openid"]
                                 openkey:nil
                               expiresIn:nil];
                    
                    [NET startRequestWithPort:YFY_NET_PORT_TENCENT_LOGIN
                                         code:nil
                                   parameters:request.requestDic
                                          tag:nil
                                      reciver:wself];
                    [wself showHUDTitle:nil];
                    
                }];
            }
        }
    });
    */
    
    
    [self.nameTextField resignFirstResponder];
    [self.passTextField resignFirstResponder];
}
- (IBAction)sinaWeiboButtonPressed:(id)sender {
    //share
//    __weak LoginViewController *wself = self;
//    
//    [SHARE sinaThirdPartLogin:^(BOOL flag, NSError *error) {
//        
//        if (flag) {
//            SinaWeibo *sina = [SHARE sinaWeibo];
//            
//            NETRequest_SinaLogin *login = [[NETRequest_SinaLogin alloc] init];
//            [login loadUId:sina.userID tokenId:sina.accessToken];
//            [NET startRequestWithPort:YFY_NET_PORT_SINA_LOGIN
//                                 code:nil
//                           parameters:login.requestDic
//                                  tag:nil
//                              reciver:wself];
//            [wself showHUDTitle:nil];
//        }else {
//            [HUD showFaceText:[error localizedDescription]];
//        }
//    }];
    
    __weak LoginViewController *wself = self;
    
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeSina];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){

        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
            NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
            
            NETRequest_SinaLogin *login = [[NETRequest_SinaLogin alloc] init];
            [login loadUId:snsAccount.usid tokenId:snsAccount.accessToken];
            [NET startRequestWithPort:YFY_NET_PORT_SINA_LOGIN
                                 code:nil
                           parameters:login.requestDic
                                  tag:nil
                              reciver:wself];
            [wself showHUDTitle:nil];

        }
    });
    
    [self.nameTextField resignFirstResponder];
    [self.passTextField resignFirstResponder];
}


#pragma mark - private
- (BOOL)isValid {
    if (self.nameTextField.text.length == 0) {
        [HUD showFaceText:@"请输入账号"];
        return NO;
    }else {
        if (![Utility isValidEmail:self.nameTextField.text]) {
            [HUD showFaceText:@"账号格式错误"];
            return NO;
        }
    }
    
    if (self.passTextField.text.length == 0) {
        [HUD showFaceText:@"请输入密码"];
        return NO;
    }
    
    return YES;
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


#pragma mark - text field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.passTextField becomeFirstResponder];
    }else if (textField == self.passTextField) {
        [self loginButtonPressed:self.loginButton];
    }
    return YES;
}


#pragma mark - network delegate 
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    
    [self hideHUD:0];
    NETResponse_Login *loginData = [[NETResponse_Login alloc] init];
    loginData.responseDic = [dic objectForKey:YFY_NET_DATA];
    loginData.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    [DATA setLoginData:loginData];
    [DATA setLoginUserID:loginData.userId];
    [DATA setTokenID:loginData.tokenId];
    [DATA setIsLogin:YES];
    
    [USER_DEFAULT setObject:loginData.tokenId forKey:kUserTokenKey];
    [USER_DEFAULT setObject:loginData.userId forKey:kUserIdKey];
    [USER_DEFAULT synchronize];
    
    __weak LoginViewController *wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (wself.completeBlock) {
            wself.completeBlock(YES);
        }
    }];
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self hideHUD:0];
    
    NETResponse_Login *loginData = [[NETResponse_Login alloc] init];
    loginData.responseDic = [dic objectForKey:YFY_NET_DATA];
    loginData.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    if (loginData.responseHeader.rspDesc.length) {
        [HUD showFaceText:loginData.responseHeader.rspDesc];
    }
    
    [DATA setTokenID:nil];
    [DATA setIsLogin:NO];
    
    if (self.completeBlock) {
        self.completeBlock(NO);
    }
}


#pragma mark -
#pragma mark - login control
+ (void)login:(LoginComplete)block {
    
    if (![DATA isLogin]) {
        [DATA setTokenID:nil];
        [DATA setIsLogin:NO];
        
        LoginViewController *loginVC = [[LoginViewController alloc] initFromNib];
        loginVC.completeBlock = block;
        MLNavigationController *nav = [[MLNavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBarHidden = YES;
        [APP_ROOT_VC presentModalViewController:nav animated:YES];
    }
}


@end








