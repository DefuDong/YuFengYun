//
//  JXViewController.h
//  JingXiang
//
//  Created by 董德富 on 13-2-1.
//
//

#import <UIKit/UIKit.h>
#import "AlertHUDView.h"
#import "AppDelegate.h"

#define APP_ROOT_VC ([(AppDelegate *)[[UIApplication sharedApplication] delegate] drawerController])

#define IOS7 if([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)\
                {self.extendedLayoutIncludesOpaqueBars = NO;\
                self.modalPresentationCapturesStatusBarAppearance =NO;\
                self.edgesForExtendedLayout = UIRectEdgeNone;}

typedef NS_ENUM(NSInteger, CustomNavigationBarPosition) {
    CustomNavigationBarPositionLeft,
    CustomNavigationBarPositionRight,
};

@class CustomNavigationBar;
@interface YFYViewController : UIViewController

@property (nonatomic, readonly, strong) CustomNavigationBar *navigationBar;
@property (nonatomic, assign) BOOL navigationBarHidden; //default NO

//public
- (id)initFromNib;
- (void)clearMemory;

- (void)showHUDTitle:(NSString *)title;
- (void)hideHUD:(NSTimeInterval)delay;


- (void)showLoadingViewBelow:(UIView *)theView;
- (void)hideLoadingView;
- (void)setLoadingFail;
- (void)clickLoadingViewToRefresh;

@end


@interface YFYViewController (customNav)
- (UIButton *)setNavigationBarWithImageName:(NSString *)imageName
                                     target:(id)target
                                     action:(SEL)action
                                   position:(CustomNavigationBarPosition)position;
- (void)setBackNavButtonActionPop;
- (void)setBackNavButtonActionDismiss;

@end


@interface CustomNavigationBar : UIView {
    UILabel *_titleLabel;
}
@property (nonatomic, assign) NSString *title;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UIButton *rightBarButton;
@end


@interface UIViewController (UMengSocial)
- (void)shareUmengWithString:(NSString *)sendString image:(UIImage *)image url:(NSString *)url delegate:(id)delegate;
@end