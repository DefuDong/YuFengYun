//
//  SocialLoginViewController.m
//  YuFengYun
//
//  Created by 董德富 on 13-11-20.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "SocialLoginViewController.h"
#import "UMSocial.h"

@interface SocialLoginViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  UIActionSheetDelegate,
  UMSocialUIDelegate
>
{
    UISwitch *_changeSwitcher;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation SocialLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"分享账号管理";
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UMSnsAccountCellIdentifier = @"UMSnsAccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSnsAccountCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:UMSnsAccountCellIdentifier] ;
    }
    
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[UMSocialSnsPlatformManager getSnsPlatformStringFromIndex:indexPath.row]];
    UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
    
    UISwitch *oauthSwitch = nil;
    if ([cell viewWithTag:snsPlatform.shareToType]) {
        oauthSwitch = (UISwitch *)[cell viewWithTag:snsPlatform.shareToType];
    }
    else{
        oauthSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 10, 40, 20)];
        
        oauthSwitch.tag = snsPlatform.shareToType;
        cell.accessoryView = oauthSwitch;
    }
    oauthSwitch.center = CGPointMake(self.mainTableView.bounds.size.width - 40, oauthSwitch.center.y);
    
    [oauthSwitch addTarget:self action:@selector(onSwitchOauth:) forControlEvents:UIControlEventValueChanged];
    
    NSString *showUserName = nil;
    
    //这里判断是否授权
    if ([UMSocialAccountManager isOauthWithPlatform:snsPlatform.platformName]) {
        [oauthSwitch setOn:YES];
        //这里获取到每个授权账户的昵称
        showUserName = accountEnitity.userName;
    }
    else {
        [oauthSwitch setOn:NO];
        showUserName = [NSString stringWithFormat:@"尚未授权"];
    }
    
    if ([showUserName isEqualToString:@""]) {
        cell.textLabel.text = @"已授权";
    }
    else{
        cell.textLabel.text = showUserName;
    }
    
    cell.imageView.image = [UIImage imageNamed:snsPlatform.smallImageName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)onSwitchOauth:(UISwitch *)switcher
{
    _changeSwitcher = switcher;
    
    if (switcher.isOn == YES) {
        [switcher setOn:NO];
        
        __weak SocialLoginViewController *wself = self;
        //此处调用授权的方法,你可以把下面的platformName 替换成 UMShareToSina,UMShareToTencent等
        NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:switcher.tag];
        
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//            NSLog(@"login response is %@",response);
//            //          获取微博用户名、uid、token等
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
//                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
//            }
//            //这里可以获取到腾讯微博openid,Qzone的token等
//            /*
//             if ([platformName isEqualToString:UMShareToTencent]) {
//             [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
//             NSLog(@"get openid  response is %@",respose);
//             }];
//             }
//             */
            
            [wself.mainTableView reloadData];
        });
        
    }
    else {
        UIActionSheet *unOauthActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除授权", nil];
        unOauthActionSheet.destructiveButtonIndex = 0;
        unOauthActionSheet.tag = switcher.tag;
        [unOauthActionSheet showInView:self.view];
    }
}

#pragma UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        __weak SocialLoginViewController *wself = self;
        
        NSString *platformType = [UMSocialSnsPlatformManager getSnsPlatformString:actionSheet.tag];
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:^(UMSocialResponseEntity *response) {
//            NSLog(@"unOauth response is %@",response);
            [wself.mainTableView reloadData];
        }];
    }
    else {//按取消
        [_changeSwitcher setOn:YES animated:YES];
    }
}

@end
