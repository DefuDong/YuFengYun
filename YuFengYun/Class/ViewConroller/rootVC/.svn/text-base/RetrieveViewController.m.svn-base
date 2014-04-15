//
//  RetrieveViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "RetrieveViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TextLeftView.h"
#import "Utility.h"
#import "NetworkCenter.h"
#import "NETRequest_Retrieve.h"
#import "NETResponse_Retrieve.h"

@interface RetrieveViewController ()
<
  NetworkCenterDelegate
>
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@end

@implementation RetrieveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.title = @"找回密码";
    [self setBackNavButtonActionPop];
    self.view.backgroundColor = kRGBColor(0, 147, 218);
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view from its nib.
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.leftView = [[TextLeftView alloc] initWithImage:@"login_left_user.png"];
    self.nameTextField.backgroundColor = kRGBColor(240, 240, 240);
    self.nameTextField.layer.cornerRadius = 5;
        
    UIImage *registerBackImage = [UIImage imageNamed:@"round_button_back.png"];
    registerBackImage = [registerBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.confirmButton setBackgroundImage:registerBackImage forState:UIControlStateNormal];
}

- (IBAction)comfirmButtonPressed:(id)sender {
    [self.nameTextField resignFirstResponder];
    
    if (self.nameTextField.text.length == 0) {
        [HUD showFaceText:@"请输入邮箱"];
        return;
    }else {
        if (![Utility isValidEmail:self.nameTextField.text]) {
            [HUD showFaceText:@"邮箱格式错误"];
            return;
        }
    }
    
    [self requestData];
}


#pragma mark - private
- (void)requestData {
    NETRequest_Retrieve *request = [[NETRequest_Retrieve alloc] init];
    [request loadUserEmail:self.nameTextField.text];
    [NET startRequestWithPort:YFY_NET_PORT_RETRIEVE_PASS
                         code:YFY_NET_CODE_RETRIEVE_PASS
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - net
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self hideHUD:0];
    
//    NETResponse_Retrieve *res = [[NETResponse_Retrieve alloc] init];
//    res.responseDic = [dic objectForKey:YFY_NET_DATA];
//    res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    [HUD showText:@"请求成功，请登录邮箱确认"];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.2];
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    [self hideHUD:0];
    
    NETResponse_Retrieve *res = [[NETResponse_Retrieve alloc] init];
//    res.responseDic = [dic objectForKey:YFY_NET_DATA];
    res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    [HUD showFaceText:res.responseHeader.rspDesc];
}



@end
