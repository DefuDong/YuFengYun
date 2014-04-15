//
//  TopPopupView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-9.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "SNPopupView.h"
#import "SNPopupView+UsingPrivateMethod.h"

typedef void (^PopupViewDismissBlock)(int index);
@interface TopPopupView : SNPopupView

@property (strong, readonly, nonatomic) NSArray *titles;

- (id)initWithTitles:(NSArray *)titles;
@property (nonatomic, copy) PopupViewDismissBlock completeBlock;

@end

