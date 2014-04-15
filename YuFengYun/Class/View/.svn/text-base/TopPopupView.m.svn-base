//
//  TopPopupView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-9.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "TopPopupView.h"

#define POPUP_VIEW_WIDTH        120.f
#define POPUP_BUTTON_HEIGHT     30.f
#define POPUP_SEPARATE_LENGTH   5.f


@interface TopPopupView()
@property (strong, readwrite, nonatomic) NSArray *titles;
@end

@implementation TopPopupView

- (id)initWithTitles:(NSArray *)titles {
    int count = titles.count;
    float height = POPUP_BUTTON_HEIGHT * count + POPUP_SEPARATE_LENGTH * (count - 1);
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, POPUP_VIEW_WIDTH, height)];
    
    self.titles = titles;
    
    self = [super initWithContentView:content contentSize:content.frame.size];
    if (self) {
        for (int i = 0; i < count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, (POPUP_BUTTON_HEIGHT+POPUP_SEPARATE_LENGTH)*i, POPUP_VIEW_WIDTH, POPUP_BUTTON_HEIGHT);
            button.tag = i;
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            button.backgroundColor = [UIColor blueColor];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [content addSubview:button];
        }
    }
    return self;
}

- (void)buttonPressed:(UIButton *)button {
    int index = button.tag;
    if (self.completeBlock) {
        self.completeBlock(index);
    }
    [self dismissModal];
}

@end
