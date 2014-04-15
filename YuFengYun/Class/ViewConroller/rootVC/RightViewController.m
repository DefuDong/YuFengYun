//
//  RightViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-5.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "RightViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RightPageCell.h"
#import "HeadRoundButton.h"
#import "UserDiscussReplayViewController.h"
//#import "ChatUserViewController.h"
#import "ChatListViewController.h"
#import "LoginViewController.h"
#import "MLNavigationController.h"
#import "NotificationViewController.h"
#import "CollectionViewController.h"
#import "SettingViewController.h"
#import "AccountDetailViewController.h"
#import "SearchViewController.h"

#import "DataCenter.h"
//#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NETResponse_Login.h"

#define kImageNameKey   @"image"
#define kTitleKey       @"title"

@interface RightTableHeaderView : UIView 
@property (nonatomic, strong) HeadRoundButton *headButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *searhButton;
@property (nonatomic, strong) UIButton *settingButton;
@end

@interface RightViewController ()
<
  UITableViewDataSource,
  UITableViewDelegate
>

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation RightViewController
- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSArray arrayWithObjects:
                            @{kImageNameKey: @"right_page_comment.png", kTitleKey: @"评论"},
                            @{kImageNameKey: @"right_page_message.png", kTitleKey: @"私信"},
                            @{kImageNameKey: @"right_page_alarm.png", kTitleKey: @"通知"},
                            @{kImageNameKey: @"right_page_collect.png", kTitleKey: @"收藏"}, nil];
    }
    return _dataSourceArray;
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
    
    RightTableHeaderView *headView = (RightTableHeaderView *)self.table.tableHeaderView;
    [headView.headButton addTarget:self
                            action:@selector(headButtonPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    [headView.searhButton addTarget:self
                             action:@selector(searhButtonPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
    [headView.settingButton addTarget:self
                               action:@selector(settingButtonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = kRGBColor(69, 87, 101);    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DATA isLogin] && [DATA loginUserID] && [DATA tokenID].length
        && [DATA loginData].userEmail.length == 0) {
        [DATA getUserInfoData];
    }
    
    [self resetData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *selectedIndexPath = [self.table indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.table deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
    
    [NOTI_CENTER addObserver:self
                    selector:@selector(resetData)
                        name:kUserInfoSuccessRecivedNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [NOTI_CENTER removeObserver:self name:kUserInfoSuccessRecivedNotification object:nil];
}
- (void)clearMemory {
    self.dataSourceArray = nil;
}


#pragma mark - actions 
- (void)headButtonPressed:(id)sender {
    __weak RightViewController *wself = self;
    if ([DATA isLogin]) {
        AccountDetailViewController *user = [[AccountDetailViewController alloc] initWithCanEdit:YES userId:nil];
        [APP_ROOT_VC.navigationController pushViewController:user animated:YES];
    }else {
        [LoginViewController login:^(BOOL flag) {
            if (flag) {
                [wself resetData];
//                UserAccountViewController *user = [[UserAccountViewController alloc] initFromNib];
//                [app.drawerController.navigationController pushViewController:user animated:YES];
            }else {
//                [HUD showFaceText:@"登录失败"];
            }
        }];
    }    
}
- (void)searhButtonPressed:(id)sender {
    SearchViewController *search = [[SearchViewController alloc] initFromNib];
    [APP_ROOT_VC.navigationController pushViewController:search animated:YES];
}
- (void)settingButtonPressed:(id)sender {
    SettingViewController *setting = [[SettingViewController alloc] initFromNib];
    [APP_ROOT_VC.navigationController pushViewController:setting animated:YES];
}

#pragma mark - private
- (void)resetData {    
    RightTableHeaderView *headView = (RightTableHeaderView *)self.table.tableHeaderView;
    
    if ([DATA isLogin] && [DATA loginData]) {
        headView.nameLabel.text = [DATA loginData].userNickname;
        [headView.headButton setImageWithURL:[NSURL URLWithString:[DATA loginData].userIcon]
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"right_head.png"]];
    }else {
        headView.nameLabel.text = @"请点击登录...";
        [headView.headButton setImage:[UIImage imageNamed:@"right_head.png"]
                             forState:UIControlStateNormal];
    }
    [self.table reloadData];
}


#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RightPageCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = RightPageCellIdentifier;
	
	RightPageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[RightPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    NSDictionary *dic = self.dataSourceArray[indexPath.row];
    cell.cellImage = [UIImage imageNamed:dic[kImageNameKey]];
    cell.cellTitle = dic[kTitleKey];
    if (indexPath.row == 2) {
        NETResponse_Login *loginData = [DATA loginData];
        cell.cellValue = [loginData.noticeCount intValue];
    }else {
        cell.cellValue = 0;
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        if ([DATA isLogin]) {
            UserDiscussReplayViewController *userDiscuss = [[UserDiscussReplayViewController alloc] initFromNib];
            [APP_ROOT_VC.navigationController pushViewController:userDiscuss animated:YES];
        } else {
            [LoginViewController login:^(BOOL flag) {
                if (flag) {
                    UserDiscussReplayViewController *userDiscuss = [[UserDiscussReplayViewController alloc] initFromNib];
                    [APP_ROOT_VC.navigationController pushViewController:userDiscuss animated:YES];
                }else {
//                    [HUD showFaceText:@"登录失败"];
                }
            }];
        }
    }else if (indexPath.row == 1) {
        if ([DATA isLogin]) {
            ChatListViewController *chat = [[ChatListViewController alloc] initFromNib];
            [APP_ROOT_VC.navigationController pushViewController:chat animated:YES];
        } else {
            [LoginViewController login:^(BOOL flag) {
                if (flag) {
                    ChatListViewController *chat = [[ChatListViewController alloc] initFromNib];
                    [APP_ROOT_VC.navigationController pushViewController:chat animated:YES];
                }else {
                    //                    [HUD showFaceText:@"登录失败"];
                }
            }];
        }
    }else if (indexPath.row == 2) {
        
        if ([DATA isLogin]) {
            NotificationViewController *noti = [[NotificationViewController alloc] initFromNib];
            [APP_ROOT_VC.navigationController pushViewController:noti animated:YES];
        } else {
            [LoginViewController login:^(BOOL flag) {
                if (flag) {
                    NotificationViewController *noti = [[NotificationViewController alloc] initFromNib];
                    [APP_ROOT_VC.navigationController pushViewController:noti animated:YES];
                }else {
                    //                    [HUD showFaceText:@"登录失败"];
                }
            }];
        }
        
    }
    else if (indexPath.row == 3) {
        if ([DATA isLogin]) {
            CollectionViewController *collect = [[CollectionViewController alloc] initWithUserId:nil];
            [APP_ROOT_VC.navigationController pushViewController:collect animated:YES];
        } else {
            [LoginViewController login:^(BOOL flag) {
                if (flag) {
                    CollectionViewController *collect = [[CollectionViewController alloc] initWithUserId:nil];
                    [APP_ROOT_VC.navigationController pushViewController:collect animated:YES];
                }else {
//                    [HUD showFaceText:@"登录失败"];
                }
            }];
        }

    }
    
//    else if (indexPath.row == 4) {
//        SettingViewController *setting = [[SettingViewController alloc] initFromNib];
//        [APP_ROOT_VC.navigationController pushViewController:setting animated:YES];
//    }else if (indexPath.row == 5) {
//        SearchViewController *search = [[SearchViewController alloc] initFromNib];
//        [APP_ROOT_VC.navigationController pushViewController:search animated:YES];
//    }
}


@end


@implementation RightTableHeaderView
- (id)init {
    self = [super init];
    if (self) {
        [self persetImageView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self persetImageView];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self persetImageView];
    }
    return self;
}
- (void)persetImageView {
    self.headButton = [HeadRoundButton buttonWithType:UIButtonTypeCustom];
    self.headButton.frame = CGRectMake(0, 0, 90, 90);
    self.headButton.center = CGPointMake(self.center.x, 75);
    self.headButton.roundColor = [UIColor clearColor];
    [self addSubview:self.headButton];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 230, 20)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = UITextAlignmentCenter;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.nameLabel];
    
    self.searhButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searhButton.frame = CGRectMake(30, 63, 32, 32);
    [self.searhButton setImage:[UIImage imageNamed:@"right_page_search.png"] forState:UIControlStateNormal];
    [self addSubview:self.searhButton];
    
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingButton.frame = CGRectMake(190, 63, 32, 32);
    [self.settingButton setImage:[UIImage imageNamed:@"right_page_set.png"] forState:UIControlStateNormal];
    [self addSubview:self.settingButton];
}
- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetLineWidth(context, .5);
//    CGContextMoveToPoint(context, 0, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
//    CGContextStrokePath(context);
    
//    CGRect ellopseRect = CGRectMake((rect.size.width-90)*.5, (rect.size.height-90)*.5, 90, 90);
//    CGContextAddEllipseInRect(context, ellopseRect);
//    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:.5].CGColor);
//    CGContextDrawPath(context, kCGPathFillStroke);
}
@end









