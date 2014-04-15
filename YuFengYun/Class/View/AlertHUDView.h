//
//  AlertHUDView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-10-18.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HUD [AlertHUDView hud]

@interface AlertHUDView : UIView

+ (id)hud;

- (void)showText:(NSString *)text;//auto
- (void)showFaceText:(NSString *)text;//auto
- (void)showText:(NSString *)text image:(UIImage *)image autoHide:(BOOL)autoHide;
- (void)dismiss;

@end
