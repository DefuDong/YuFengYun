//
//  AccountDetailViewController.m
//  YuFengYun
//
//  Created by 董德富 on 14-1-6.
//  Copyright (c) 2014年 董德富. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "HeadRoundButton.h"
#import "UIButton+WebCache.h"

#import "NetworkCenter.h"
#import "DataCenter.h"
#import "NETRequest_EditUser.h"
#import "NETResponse_EditUser.h"
#import "NETResponse_Login.h"
#import "NETRequest_Logout.h"
#import "NETResponse_Logout.h"
#import "NETResponse_UploadImage.h"
#import "NETRequest_UserInfo.h"
#import "NETResponse_Login.h"


#import "UITableViewCell+Nib.h"
#import "User_Account_Basic_Cell.h"
#import "User_Acount_First_Cell.h"
#import "User_Account_Logout_Cell.h"
#import "User_Account_Des_Cell.h"

#define kProvinceKey @"province"
#define kCitysKey @"citys"

#define kDefaultScrollViewHeight (self.view.frame.size.height-(SYSTEM_VERSION_MOER_THAN_7 ? 64 : 44))

typedef NS_ENUM(NSInteger, RightButtonState) {
    RightButtonStateEdit,
    RightButtonStateSave
};

#define kActionTagLogout 100
#define kActionTagImage 200
#define kActionTagSex 300


@interface AccountDetailViewController ()
<
UITextFieldDelegate,
UITextViewDelegate,
NetworkCenterDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>
{
    __weak UIActionSheet *_actionSheet;
    
    UIImage *_userIconImage;//若为空，则没有改变。否则就是已经改变
    NSString *_nickName;
    NSString *_userSex; //男m, 女f, 未知n
    NSString *_company;
    NSString *_userTitle;
    unsigned int _provinceIndex;
    unsigned int _cityIndex;
    NSString *_userDes;
    
    unsigned _activeIndex;
}
@property (nonatomic, assign) BOOL allowEdit;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) BOOL isKeyboardShow;//键盘是否显示
@property (nonatomic, copy) NSString *userIcon;

@property (nonatomic, strong) NSDictionary *citysDic;

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NETResponse_Login *userInfo;

@end

@implementation AccountDetailViewController
- (NSDictionary *)citysDic {
    if (!_citysDic) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        _citysDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _citysDic;
}
- (void)setCanEdit:(BOOL)canEdit {
    if (!self.allowEdit) {
        _canEdit = NO;
    }else {
        _canEdit = canEdit;
    }
}

- (id)initWithCanEdit:(BOOL)edit userId:(NSNumber *)userId {
    self = [super initFromNib];
    if (self) {
        self.allowEdit = edit;
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBar.title = @"我的账户";
    
    [self setNavigationBarWithImageName:@"nav_back.png"
                                 target:self
                                 action:@selector(backButtonPressed:)
                               position:CustomNavigationBarPositionLeft];
    
    [self setRightButtonState:RightButtonStateEdit];
    
    if (self.allowEdit) {
        NETResponse_Login *data = [DATA loginData];
        _nickName = data.userNickname;
        _userSex = data.userSex;
        _company = data.userCompany;
        _userTitle = data.userTitle;
        if (data.userArea && data.userCity) {
            int commpon = [data.userArea integerValue];
            int row = [data.userCity integerValue];
            _provinceIndex = commpon-1;
            _cityIndex = row-1;
        }else {
            _provinceIndex = 0;
            _cityIndex = 0;
        }
        _userDes = data.userInfo;
    }else {
        [self getUserInfoData];
        [self showLoadingViewBelow:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated  {
	[super viewWillAppear:animated];
	/* Listen for keyboard */
	[NOTI_CENTER addObserver:self
                    selector:@selector(keyboardWillShow:)
                        name:UIKeyboardWillShowNotification
                      object:nil];
    [NOTI_CENTER addObserver:self
                    selector:@selector(keyboardDidShow:)
                        name:UIKeyboardDidShowNotification
                      object:nil];
	[NOTI_CENTER addObserver:self
                    selector:@selector(keyboardWillHide:)
                        name:UIKeyboardWillHideNotification
                      object:nil];
}
- (void)viewWillDisappear:(BOOL)animated  {
	[super viewWillDisappear:animated];
	/* No longer listen for keyboard */
	[NOTI_CENTER removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NOTI_CENTER removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[NOTI_CENTER removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)clickLoadingViewToRefresh {
    [self getUserInfoData];
}


#pragma mark - private
- (void)setRightButtonState:(RightButtonState)state {
    if (!self.allowEdit) {
        return;
    }
    
    if (!self.navigationBar.rightBarButton) {
        UIImage *image = [UIImage imageNamed:@"nav_button_back_round.png"];
        CGSize size = image.size;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70, size.height);
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [button setTitle:@"保存" forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        self.navigationBar.rightBarButton = button;
        
        CGRect buttonFrame = button.frame;
        buttonFrame.origin.x = self.view.frame.size.width-buttonFrame.size.width-5;
        buttonFrame.origin.y = self.navigationBar.frame.size.height-buttonFrame.size.height-6;
        button.frame = buttonFrame;
    }
    
    UIButton *rightButton = self.navigationBar.rightBarButton;
    if (state == RightButtonStateEdit) {
        rightButton.selected = NO;
    }else if (state == RightButtonStateSave) {
        rightButton.selected = YES;
    }
}
- (void)backButtonPressed:(UIButton *)button {
    if (self.navigationBar.rightBarButton.selected) {
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:@"确定要放弃保存吗？"
                                   delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定", nil] show];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)rightBarButtonPressed:(UIButton *)button {
    
    if (button.selected == YES) {
        [self.tableView resignFirstResponder];
        button.enabled = NO;
        
        if ([self isEnterValid]) {
            if (_userIconImage) {
                [self requestUploadImage];
            }else {
                [self requestData:nil];
            }
        }
    }else {
        button.selected = YES;
        self.canEdit = YES;
        [self.tableView reloadData];
    }
}
- (IBAction)headButtonPressed:(id)sender {
    if (!self.canEdit) {
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择数据源"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册选取", nil];
        actionSheet.tag = kActionTagImage;
        [actionSheet showInView:self.view];
    }else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];
    }
}

- (void)actionSheetCancelButtonPressed {
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)actionSheetConfirmButtonPressed {
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSArray *provience = self.citysDic[kProvinceKey];
    NSString *key = provience[_provinceIndex];
    NSDictionary *cityDic = self.citysDic[kCitysKey];
    NSString *city = [cityDic[key] objectAtIndex:_cityIndex];
    
    User_Account_Basic_Cell *cell = (User_Account_Basic_Cell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    cell.textField.text = [NSString stringWithFormat:@"%@ %@", key, city];
}

- (void)showPickerView {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil, nil];
    //        _baseActionSheet.clipsToBounds = NO;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(actionSheetCancelButtonPressed)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(actionSheetConfirmButtonPressed)];
    toolBar.items = @[cancelItem ,leftItem, confirmItem];
    [actionSheet addSubview:toolBar];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, actionSheet.frame.size.width, 216)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    [picker selectRow:_provinceIndex inComponent:0 animated:NO];
    [picker selectRow:_cityIndex inComponent:1 animated:YES];
    
    [actionSheet addSubview:picker];
    
    [actionSheet showInView:self.view];
    _actionSheet = actionSheet;
}
- (BOOL)isEnterValid {
    if (_nickName.length == 0) {
        [HUD showFaceText:@"请输入昵称"];
        return NO;
    }
    return YES;
}
#pragma net
- (void)requestUploadImage {
    [NET uploadImage:_userIconImage reciver:self];
    [self showHUDTitle:@"上传头像..."];
}
- (void)requestData:(NSString *)icon {

    NSString *userIcon = icon.length ? icon : [DATA loginData].userIcon;
    
    NETRequest_EditUser *edit = [[NETRequest_EditUser alloc] init];
    [edit loadUserId:[DATA loginData].userId
        userNickname:_nickName
            userIcon:userIcon
         userCompany:_company
           userTitle:_userTitle
            userArea:[[NSNumber numberWithUnsignedInt:_provinceIndex+1] stringValue]
            userCity:[[NSNumber numberWithUnsignedInt:_cityIndex+1] stringValue]
             userSex:_userSex
            userInfo:_userDes];
    [NET startRequestWithPort:YFY_NET_PORT_EDIT_USER
                         code:YFY_NET_CODE_EDIT_USER
                   parameters:edit.requestDic
                          tag:nil
                      reciver:self];
    [self showHUDTitle:nil];
}
- (void)getUserInfoData {
    NETRequest_UserInfo *request = [[NETRequest_UserInfo alloc] init];
    [request loadUserId:self.userId];
    [NET startRequestWithPort:YFY_NET_PORT_USER_INFO
                         code:YFY_NET_CODE_USER_INFO
                   parameters:request.requestDic
                          tag:nil
                      reciver:self];
}



#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.allowEdit || self.canEdit) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return UserAcountFirstCellHeight;
    }else if (indexPath.section == 1){
        return UserAccountLogoutCellHeight;
    }else if (indexPath.section == 0 && indexPath.row == 6) {
        return UserAccountDesCellHeight;
    }else {
        return UserAccountBasicCellHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NETResponse_Login *data = nil;
    if (self.allowEdit) {
        data = [DATA loginData];
    }else {
        data = self.userInfo;
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellId = UserAcountFirstCellIdentifier;
        User_Acount_First_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (User_Acount_First_Cell *)[UITableViewCell cellWithNibName:@"User_Acount_First_Cell"];

            [cell.headButton addTarget:self action:@selector(headButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.level = data.userLevelType;
        cell.scoreLabel.text = [data.loyaltyValue stringValue];
        cell.emailLabel.text = data.userEmail;
        
        if (_userIconImage) {
            cell.headButton.headImage = _userIconImage;
        }else {
            [cell.headButton setImageWithURL:[NSURL URLWithString:data.userIcon] forState:UIControlStateNormal];
        }
        cell.headButton.enabled = self.canEdit;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *cellId = UserAccountLogoutCellIdentifier;
        User_Account_Logout_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (User_Account_Logout_Cell *)[UITableViewCell cellWithNibName:@"User_Account_Logout_Cell"];
        }
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 6) {
        static NSString *cellId = UserAccountDesCellIdentifier;
        User_Account_Des_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (User_Account_Des_Cell *)[UITableViewCell cellWithNibName:@"User_Account_Des_Cell"];
        }
        
        cell.textView.text = _userDes;
        cell.textView.editable = self.canEdit;
        cell.textView.delegate = self;
        cell.textView.tag = 6;
        
        return cell;
    }
    else{
        NSString *cellId = [NSString stringWithFormat:@"%@%d", UserAccountBasicCellIdentifier, indexPath.row];
        User_Account_Basic_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = (User_Account_Basic_Cell *)[UITableViewCell cellWithNibName:@"User_Account_Basic_Cell"];
        
            if (indexPath.row == 1) {
                cell.firstText = @"昵称:";
                cell.textField.text = _nickName;
                cell.type = UserAccountBasicCellTypeBottom;
            }
            else if (indexPath.row == 2) {
                cell.firstText = @"性别:";
                
                NSString *sex = nil;
                if ([_userSex isEqualToString:@"m"]) {
                    sex = @"男";
                }else if ([_userSex isEqualToString:@"f"]) {
                    sex = @"女";
                }else if ([_userSex isEqualToString:@"n"]) {
                    sex = @"未知";
                }
                cell.textField.text = sex;
                cell.type = UserAccountBasicCellTypeMid;
            }
            else if (indexPath.row == 3) {
                cell.firstText = @"公司:";
                cell.textField.text = _company;
                cell.type = UserAccountBasicCellTypeMid;
            }
            else if (indexPath.row == 4) {
                cell.firstText = @"职位:";
                cell.textField.text = _userTitle;
                cell.type = UserAccountBasicCellTypeMid;
            }
            else if (indexPath.row == 5) {
                cell.firstText = @"所在地:";
                
                NSArray *provience = self.citysDic[kProvinceKey];
                NSString *key = nil; NSString *city = nil;
                if (_provinceIndex < provience.count) {
                    key = provience[_provinceIndex];
                    
                    NSDictionary *cityDic = self.citysDic[kCitysKey];
                    if (_cityIndex < [cityDic[key] count]) {
                        city = [cityDic[key] objectAtIndex:_cityIndex];
                        cell.textField.text = [NSString stringWithFormat:@"%@ %@", key, city];
                    }
                }
                
                cell.type = UserAccountBasicCellTypeMid;
            }
            
            cell.textField.tag = indexPath.row;
            [cell.textField addTarget:self action:@selector(textFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
            cell.textField.delegate = self;
        }
        
        cell.textField.enabled = self.canEdit;
        cell.tagImageView.hidden = YES;
        if (indexPath.row == 2 || indexPath.row == 5) {
            cell.textField.enabled = NO;
            if (self.canEdit) {
                cell.tagImageView.hidden = NO;
            }else {
                cell.tagImageView.hidden = YES;
            }
        }

        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.allowEdit) {
        return;
    }
    
    if (indexPath.section == 1) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"注销"
                                                   otherButtonTitles:nil, nil];
        [action showInView:self.view];
        action.tag = kActionTagLogout;

    }else if (indexPath.section == 0) {
        if (indexPath.row == 5 && self.canEdit) {
            [self showPickerView];
        }
        if (indexPath.row == 2 && self.canEdit) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"男", @"女", nil];
            [action showInView:self.view];
            action.tag = kActionTagSex;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}


#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == kActionTagImage) {
        if (buttonIndex == 2) return;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        if (buttonIndex == 0) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 1) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentModalViewController:imagePicker animated:YES];
    }else if (actionSheet.tag == kActionTagLogout){
        if (buttonIndex == 0) {
            [NET startRequestWithPort:YFY_NET_PORT_LOGOUT
                                 code:YFY_NET_CODE_LOGOUT
                           parameters:nil
                                  tag:nil
                              reciver:self];
            [self showHUDTitle:nil];
        }
    }else if (actionSheet.tag == kActionTagSex) {
        if (buttonIndex == 0) {
            _userSex = @"m";
        }
        if (buttonIndex == 1) {
            _userSex = @"f";
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        User_Acount_First_Cell *cell = (User_Acount_First_Cell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.headButton.headImage = image;
        _userIconImage = image;
    }
    
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - text 
- (void)textFieldDidChangeText:(UITextField *)textField {
    int tag = textField.tag;
    if (tag == 1) {
        _nickName = textField.text;
    }else if (tag == 3) {
        _company = textField.text;
    }else if (tag == 4) {
        _userTitle = textField.text;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    int tag = textField.tag;
    if (tag == 1) {
        _nickName = textField.text;
    }else if (tag == 3) {
        _company = textField.text;
    }else if (tag == 4) {
        _userTitle = textField.text;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    _userDes = textView.text;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark - picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.citysDic[kProvinceKey] count];
    }
    if (component == 1) {
        NSArray *provience = self.citysDic[kProvinceKey];
        NSString *key = provience[_provinceIndex];
        NSDictionary *cityDic = self.citysDic[kCitysKey];
        int count = [cityDic[key] count];
        return count;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSArray *provience = self.citysDic[kProvinceKey];
        return provience[row];
    }
    if (component == 1) {
        NSArray *provience = self.citysDic[kProvinceKey];
        NSString *key = provience[_provinceIndex];
        NSDictionary *cityDic = self.citysDic[kCitysKey];
        return [cityDic[key] objectAtIndex:row];
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _provinceIndex = row;
        _cityIndex = 0;
        [pickerView reloadComponent:1];
    }
    else if (component == 1) {
        _cityIndex = row;
    }
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
                         CGRect rect = self.tableView.frame;
                         rect.size.height = kDefaultScrollViewHeight - frame.size.height;
                         self.tableView.frame = rect;
                     }
                     completion:^(BOOL finished) {self.isKeyboardShow = YES;}];
}
- (void)keyboardDidShow:(NSNotification *)note {
    
}
- (void)keyboardWillHide:(NSNotification *)note {
    if (!self.isKeyboardShow) {
        return;
    }
    NSDictionary *info = note.userInfo;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    [UIView animateWithDuration:[duration doubleValue]
                          delay:0
                        options:[curve intValue]
                     animations:^{
                         CGRect rect = self.tableView.frame;
                         rect.size.height = kDefaultScrollViewHeight;
                         self.tableView.frame = rect;
                     }
                     completion:NULL];
    self.isKeyboardShow = NO;
}


#pragma mark - network
- (void)networkDidSuccess:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    if ([port isEqualToString:YFY_NET_PORT_EDIT_USER]) {
        [self hideHUD:0];
        
        UIButton *rightButton = self.navigationBar.rightBarButton;
        rightButton.enabled = YES;
        rightButton.selected = NO;
        self.canEdit = NO;
        [self.tableView reloadData];
        
        NETResponse_EditUser *res = [[NETResponse_EditUser alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showText:@"修改资料成功"];
        
        NETResponse_Login *loginData = [DATA loginData];
        loginData.userNickname = _nickName;
        loginData.userCompany = _company;
        loginData.userTitle = _userTitle;
        loginData.userArea = [[NSNumber numberWithInt:_provinceIndex+1] stringValue];
        loginData.userCity = [[NSNumber numberWithInt:_cityIndex+1] stringValue];
        loginData.userSex = _userSex;
        loginData.userInfo = _userDes;
        if (self.userIcon.length) {
            loginData.userIcon = self.userIcon;
        }
        [self.tableView reloadData];
    }
    else if ([port isEqualToString:YFY_NET_PORT_LOGOUT]) {
        [self hideHUD:0];
        
        [DATA setTokenID:nil];
        [DATA setIsLogin:NO];
        [DATA setLoginData:nil];
        
        [USER_DEFAULT removeObjectForKey:kUserTokenKey];
        [USER_DEFAULT removeObjectForKey:kUserIdKey];
        [USER_DEFAULT synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([port isEqualToString:YFY_NET_PORT_UPLOAD_IMAGE]) {
        [self hideHUD:0];
        
        NETResponse_UploadImage *rsp = [[NETResponse_UploadImage alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_DATA];
        rsp.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        self.userIcon = rsp.filepath;
        [self requestData:rsp.filepath];
    }
    else if ([port isEqualToString:YFY_NET_PORT_USER_INFO]) {
        [self hideLoadingView];
        
        NETResponse_Login *rsp = [[NETResponse_Login alloc] init];
        rsp.responseDic = [dic objectForKey:YFY_NET_DATA];
        rsp.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        self.userInfo = rsp;
        
        _nickName = rsp.userNickname.length ? rsp.userNickname : @"-";
        _userSex = rsp.userSex.length ? rsp.userSex : @"n";
        _company = rsp.userCompany.length ? rsp.userCompany : @"-";
        _userTitle = rsp.userTitle.length ? rsp.userTitle : @"-";
        if (rsp.userArea && rsp.userCity) {
            int commpon = [rsp.userArea integerValue];
            int row = [rsp.userCity integerValue];
            _provinceIndex = commpon-1;
            _cityIndex = row-1;
        }else {
            _provinceIndex = 0;
            _cityIndex = 0;
        }
        _userDes = rsp.userInfo.length ? rsp.userInfo : @"-";
        [self.tableView reloadData];
    }
}
- (void)networkDidFail:(NSDictionary *)dic port:(NSString *)port tag:(NSString *)tag {
    if ([port isEqualToString:YFY_NET_PORT_EDIT_USER]) {
        [self hideHUD:0];
        
        UIButton *rightButton = self.navigationBar.rightBarButton;
        rightButton.enabled = YES;
        
        NETResponse_EditUser *res = [[NETResponse_EditUser alloc] init];
        res.responseDic = [dic objectForKey:YFY_NET_DATA];
        res.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:res.responseHeader.rspDesc];
    }
    else if ([port isEqualToString:YFY_NET_PORT_LOGOUT]) {
        [self hideHUD:0];
        
        NETResponse_Header *header = [[NETResponse_Header alloc] init];
        header.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:header.rspDesc];
    }
    else if ([port isEqualToString:YFY_NET_PORT_UPLOAD_IMAGE]) {
        [self hideHUD:0];
        
        NETResponse_UploadImage *rsp = [[NETResponse_UploadImage alloc] init];
        rsp.responseHeader.responseDic = [dic objectForKey:YFY_NET_RSP_HEADER];
        
        [HUD showFaceText:rsp.responseHeader.rspDesc];
        [self requestData:nil];
    }
    else if ([port isEqualToString:YFY_NET_PORT_USER_INFO]) {
        [self setLoadingFail];
    }
}


@end
