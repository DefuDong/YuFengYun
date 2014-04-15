//
//  SettingViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-31.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountDetailViewController.h"
//#import "KLSwitch.h"
#import "AboutViewController.h"
#import "MBProgressHUD.h"
#import "NetworkCenter.h"
#import "DataCenter.h"
#import "DBManager.h"
#import "LoginViewController.h"
#import "SocialLoginViewController.h"
#import "SDImageCache.h"
#import "Harpy.h"

#include <sys/stat.h>
#include <dirent.h>

#import "NetworkCenter.h"
#import "NETResponse.h"


@interface SettingViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate,
  NetworkCenterDelegate
>
{
    MBProgressHUD *hud;
    long long cacheSize;
}
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *cellTitles;
@end

@implementation SettingViewController
- (NSArray *)cellTitles {
    if (!_cellTitles) {
        _cellTitles = [NSArray arrayWithObjects:@[@"我的账户", @"分享账号管理"], @[@"离线下载", @"清除缓存"], @[@"检查新版本", @"关于"], nil];
    }
    return _cellTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"设置";
    
    cacheSize = [SettingViewController folderSizeAtPath3:[DBManager cachePath]];
    
    if ([DATA isLogin]) {
        [self setRightButton];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [NOTI_CENTER removeObserver:self name:kOfflineDataSuccessRecivedNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *selectedIndexPath = [self.mainTableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.mainTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
    
    [NOTI_CENTER addObserver:self
                    selector:@selector(offlineDownlioadFinished:)
                        name:kOfflineDataSuccessRecivedNotification
                      object:nil];
}


- (void)setRightButton {
    
    if (!self.navigationBar.rightBarButton) {
        UIImage *image = [UIImage imageNamed:@"nav_button_back_round.png"];
        CGSize size = image.size;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70, size.height);
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"注销" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        self.navigationBar.rightBarButton = button;
        
        CGRect buttonFrame = button.frame;
        buttonFrame.origin.x = self.view.frame.size.width-buttonFrame.size.width-5;
        buttonFrame.origin.y = self.navigationBar.frame.size.height-buttonFrame.size.height-6;
        button.frame = buttonFrame;
    }
}
- (void)rightBarButtonPressed:(UIButton *)button {
    [NET startRequestWithPort:YFY_NET_PORT_LOGOUT
                         code:YFY_NET_CODE_LOGOUT
                   parameters:nil
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}

#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [self.cellTitles[sectionIndex] count];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) return 20;
//    return 0;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 20;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 2) {
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
//        backView.backgroundColor = [UIColor clearColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 250, 15)];
//        label.text = @"点击后，您阅读过的文章缓存将会全部删除";
//        label.font = [UIFont systemFontOfSize:12];
//        label.textColor = [UIColor darkGrayColor];//kRGBColor(153, 153, 153);
//        label.backgroundColor = [UIColor clearColor];
//        [backView addSubview:label];
//        return backView;
//    }
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"settingCellId";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        /*
        UIEdgeInsets edge = UIEdgeInsetsMake(5, 5, 5, 5);
        UIImage *image = [[UIImage imageNamed:@"round_gray_back.png"] resizableImageWithCapInsets:edge];
        UIImage *imageH = [[UIImage imageNamed:@"round_gray_back2.png"] resizableImageWithCapInsets:edge];
        cell.backgroundView = [[UIImageView alloc] initWithImage:image];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:imageH];*/
	}
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [self.cellTitles[indexPath.section] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSString *sizeStrig = nil;
        if (cacheSize >= 1024*1024) {
            float size = (float)cacheSize / (1024.0f*1024.0f);
            sizeStrig = [NSString stringWithFormat:@"%.02fM", size];
        }else if (cacheSize == 0) {
            sizeStrig = @"没有缓存";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            float size = (float)cacheSize / 1024.0f;
            sizeStrig = [NSString stringWithFormat:@"%.02fK", size];
        }
        cell.detailTextLabel.text = sizeStrig;
    }
    else
        cell.detailTextLabel.text = nil;
    
	return cell;
}

//@[@"我的账户", @"分享账号管理"], @[@"离线下载", @"清除缓存"], @[@"检查新版本", @"关于"]
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//我的账户
            if ([DATA isLogin]) {
                AccountDetailViewController *user = [[AccountDetailViewController alloc] initWithCanEdit:YES userId:nil];
                [APP_ROOT_VC.navigationController pushViewController:user animated:YES];
            }else {
                [LoginViewController login:^(BOOL flag) {
                    if (flag) {
                        AccountDetailViewController *user = [[AccountDetailViewController alloc] initWithCanEdit:YES userId:nil];
                        [self.navigationController pushViewController:user animated:YES];
                    }else {
//                        [HUD showFaceText:@"登录失败"];
                    }
                }];
            }
        }
        else if (indexPath.row == 1) {//分享账号管理
            SocialLoginViewController *social = [[SocialLoginViewController alloc] initFromNib];
            [self.navigationController pushViewController:social animated:YES];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {//离线下载
            //off line
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            hud = [MBProgressHUD showHUDAddedTo:(keyWindow ? keyWindow : self.view) animated:YES];
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
            hud.dimBackground = YES;
            hud.removeFromSuperViewOnHide = YES;
            
            [NET downloadOfflineWithProgress:hud];
        }
        else if (indexPath.row == 1) {//清除缓存
            if (cacheSize == 0) return;
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self deleteCache];
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {//检查新版本
           [Harpy checkForNewVersion];
           [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else if (indexPath.row == 1) {
            AboutViewController *about = [[AboutViewController alloc] initFromNib];
            [self.navigationController pushViewController:about animated:YES];
        }
    }    
}



#pragma mark -
- (void)offlineDownlioadFinished:(id)sender {
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"离线下载完成";
    hud.labelFont = [UIFont boldSystemFontOfSize:15];
    hud.margin = 10;
    
    [hud hide:YES afterDelay:1.5];
    
    cacheSize = [SettingViewController folderSizeAtPath3:[DBManager cachePath]];
    [self.mainTableView reloadData];
}


#pragma mark - network
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    if ([port isEqualToString:YFY_NET_PORT_LOGOUT]) {
        [self hideHUD:0];
        
        [DATA setTokenID:nil];
        [DATA setIsLogin:NO];
        [DATA setLoginData:nil];
        
        [USER_DEFAULT removeObjectForKey:kUserTokenKey];
        [USER_DEFAULT removeObjectForKey:kUserIdKey];
        [USER_DEFAULT synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    if ([port isEqualToString:YFY_NET_PORT_LOGOUT]) {
        [self hideHUD:0];
        
        NETResponse_Header *header = [[NETResponse_Header alloc] init];
        header.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:header.rspDesc];
    }
}



#pragma mark - 
+ (long long)folderSizeAtPath3:(NSString*) folderPath{
    return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}
+ (long long)_folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        int folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}

- (void)deleteCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [DBManager cachePath];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[cachePath stringByAppendingPathComponent:filename] error:NULL];
    }
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    [HUD showText:@"清除缓存成功"];
    
    cacheSize = [SettingViewController folderSizeAtPath3:[DBManager cachePath]];
    [self.mainTableView reloadData];
}

@end













