//
//  UserMainPageViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-17.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UITableViewCell+Nib.h"
#import "HeadRoundButton.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UserInfo_Cell.h"
#import "User_Basic_Cell.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_UserInfo.h"
#import "NETResponse_UserInfo.h"

#import "ChatLetterViewController.h"
//#import "DetailViewController.h"
#import "CollectionViewController.h"
#import "UserInfoArticleViewController.h"
#import "UserInfoCommentViewController.h"
#import "AccountDetailViewController.h"

#define kRequestTagNew @"new"
#define kRequestTagAdd @"add"

@interface UserInfoViewController ()
<
  UITableViewDelegate,
  UITableViewDataSource,
  NetworkCenterDelegate
>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NETResponse_UserInfo *userInfo;

@end

@implementation UserInfoViewController


- (id)initWithUserId:(NSNumber *)userId {
    self = [super initFromNib];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"个人主页";
    
    [self setRightButton];
    
    [self showLoadingViewBelow:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestUserInfo];
}
- (void)clearMemory {
}
- (void)clickLoadingViewToRefresh {
    [self requestUserInfo];
}

- (void)rightBarButtonPressed:(id)sender {
    ChatLetterViewController *chat = [[ChatLetterViewController alloc] initWithUserId:self.userId
                                                                             nickName:self.userInfo.userNickname];
    [self.navigationController pushViewController:chat animated:YES];
}


#pragma mark - private
- (void)requestUserInfo {
    NETRequest_UserInfo *request = [[NETRequest_UserInfo alloc] init];
    [request loadUserId:self.userId];
    
    [NET startRequestWithPort:YFY_NET_PORT_USER_INFO
                         code:YFY_NET_CODE_USER_INFO
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
}
- (void)setRightButton {
    UIImage *image = [UIImage imageNamed:@"nav_button_back_round.png"];
    CGSize size = image.size;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 30, 5, 5)];
    NSString *discuss = @"私信 Ta";
    CGSize stringSize = [discuss sizeWithFont:[UIFont boldSystemFontOfSize:14]];
    size.width = 37+stringSize.width;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButton = button;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 10)];
    imageView.image = [UIImage imageNamed:@"right_page_message.png"];
    [button addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, stringSize.width, size.height)];
    label.text = discuss;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [button addSubview:label];
    
    CGRect buttonFrame = button.frame;
    buttonFrame.origin.x = self.view.frame.size.width-buttonFrame.size.width-5;
    buttonFrame.origin.y = self.navigationBar.frame.size.height-buttonFrame.size.height-6;
    button.frame = buttonFrame;
}


#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.userInfo) {
        return 0;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.userInfo) {
        return 0;
    }
    if (section == 0) {
        return 2;
    }else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return [UserInfo_Cell cellHeight:self.userInfo.userInfo];
    }else {
        return UserBasicCellHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellId = UserInfoCellIdentifier;
        UserInfo_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (UserInfo_Cell *)[UITableViewCell cellWithNibName:@"UserInfo_Cell"];
        }
        [cell.headButton setImageWithURL:[NSURL URLWithString:self.userInfo.userIcon] forState:UIControlStateNormal];
        cell.name = self.userInfo.userNickname;
        cell.level = self.userInfo.userLevelType;
        cell.scoreLabel.text = [self.userInfo.loyaltyValue stringValue];
        cell.detail = self.userInfo.userInfo;
        
        return cell;
    }else {
        static NSString *cellId = UserBasicCellIdentifier;
        User_Basic_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (User_Basic_Cell *)[UITableViewCell cellWithNibName:@"User_Basic_Cell"];
        }
        
        if (indexPath.section == 0) {
            cell.titleLabel.text = @"详细资料";
            cell.detailLabel.text = nil;
            cell.type = UserBasicCellTypeBottom;
        }else {
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"参与评论";
                cell.detailLabel.text = [self.userInfo.commentCount stringValue];
                cell.type = UserBasicCellTypeTop;
            }
            if (indexPath.row == 1) {
                cell.titleLabel.text = @"发表文章";
                cell.detailLabel.text = [self.userInfo.articleCount stringValue];
                cell.type = UserBasicCellTypeMid;
            }
            if (indexPath.row == 2) {
                cell.titleLabel.text = @"收藏";
                cell.detailLabel.text = [self.userInfo.favoriteCount stringValue];
                cell.type = UserBasicCellTypeBottom;
            }
        }
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        AccountDetailViewController *account = [[AccountDetailViewController alloc] initWithCanEdit:NO userId:self.userId];
        [self.navigationController pushViewController:account animated:YES];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UserInfoCommentViewController *collect = [[UserInfoCommentViewController alloc] initWithUserId:self.userId];
            [self.navigationController pushViewController:collect animated:YES];
        }
        if (indexPath.row == 1) {
            UserInfoArticleViewController *collect = [[UserInfoArticleViewController alloc] initWithUserId:self.userId];
            [self.navigationController pushViewController:collect animated:YES];
        }
        if (indexPath.row == 2) {
            CollectionViewController *collect = [[CollectionViewController alloc] initWithUserId:self.userId];
            [self.navigationController pushViewController:collect animated:YES];
        }
    }
}



#pragma mark - network delegate
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    if ([port isEqualToString:YFY_NET_PORT_USER_INFO]) {
        [self hideLoadingView];
        
        NETResponse_UserInfo *rsq = [[NETResponse_UserInfo alloc] init];
        rsq.responseDic = [dic objectForKey:YFY_NET_DATA];
        rsq.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        self.userInfo = rsq;
        
        [self.tableView reloadData];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    NETResponse_Header *header = [[NETResponse_Header alloc] init];
    header.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
    
    if ([port isEqualToString:YFY_NET_PORT_USER_INFO]) {
        [HUD showFaceText:header.rspDesc];
        [self setLoadingFail];
    }
}



@end
