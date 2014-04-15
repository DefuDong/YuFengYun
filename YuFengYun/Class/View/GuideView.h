//
//  GuideView.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-24.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallBackBlock)(void);

@interface GuideView : UIScrollView 

@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, copy) CallBackBlock completeBlock;

@end
