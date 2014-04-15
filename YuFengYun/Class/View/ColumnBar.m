//
//  ColumnBar.m
//  ColumnBarDemo
//
//  Created by chenfei on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColumnBar.h"
#import "Utility.h"

@implementation ColumnBar

- (void)setDataSource:(id<ColumnBarDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self reloadData];
    }
}
- (void)setSelectedIndex:(int)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}


#pragma mark - init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubviews];
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        [self loadSubviews];
    }
    return self;
}


#pragma mark - subviews
- (void)loadSubviews {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = kRGBColor(48, 56, 67);
    [self addSubview:_scrollView];
    
    _mover = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height-3, kItemWidth, 3)];
    _mover.backgroundColor = kRGBColor(101, 101, 101);
    [_scrollView insertSubview:_mover atIndex:0];
    
    _selectedIndex = -1;
}


#pragma mark - public 
- (void)reloadData {
    for (id vi in _scrollView.subviews) {
        if ([vi isKindOfClass:[UIButton class]])
            [vi removeFromSuperview];
    }
	
	if(!self.dataSource) return;
	
	int items = [self.dataSource numberOfTabsInColumnBar:self];
	if (items == 0) return;
    
    if (_buttons) {
        [_buttons removeAllObjects], _buttons = nil;
    }
    _buttons = [NSMutableArray arrayWithCapacity:items];
        	
	float origin_x = 0;
	for(int i = 0; i < items; i++) {
		NSString *name = [self.dataSource columnBar:self titleForTabAtIndex:i];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.frame = CGRectMake(origin_x, 0, kItemWidth, _scrollView.frame.size.height);
//		CGSize size = [name sizeWithFont:button.titleLabel.font];
//        button.frame = CGRectMake(origin_x, 0, size.width+kSpace, _scrollView.frame.size.height);
		[button setTitle:name forState:UIControlStateNormal];
		[button setTitleColor:kRGBColor(204, 204, 204) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[_scrollView addSubview:button];
        [_buttons addObject:button];
        
        ////////////////
        if (i < items-1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(origin_x+button.frame.size.width, 0, kSpace, 10)];
            lineView.center = CGPointMake(lineView.center.x, button.center.y);
            lineView.backgroundColor = kRGBColor(101, 101, 101);
            [_scrollView addSubview:lineView];
        }
        
        origin_x += kItemWidth + kSpace;
	}
	
    [self setSelectedIndex:0 animated:NO];
	_scrollView.contentSize = CGSizeMake(origin_x-kSpace, _scrollView.frame.size.height);
}
- (void)setSelectedIndex:(int)index animated:(BOOL)animated {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    
    for (UIButton *btn in _buttons) {
        if ([btn isKindOfClass:[UIButton class]] && btn.selected)
            btn.selected = NO;
    }
    
    UIButton *button = _buttons[index];
    CGPoint center = CGPointMake(button.center.x, _mover.center.y);
//    CGSize size = [[button titleForState:UIControlStateNormal] sizeWithFont:button.titleLabel.font];
//    CGRect rect = CGRectInset(button.frame, kSpace * .2, (button.frame.size.height-size.height) * .3);
    
    if (animated) {
        [UIView animateWithDuration:.2
                         animations:^{_mover.center = center;}
                         completion:^(BOOL finished) {
                             button.selected = YES;
                             [_scrollView scrollRectToVisible:button.frame animated:YES];
//                             _mover.image = [_moverImage resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
                         }];
    }else {
        _mover.center = center;
        button.selected = YES;
    }
}


#pragma mark - action
- (void)buttonClicked:(UIButton *)button {
    
    int index = [_buttons indexOfObject:button];
    if (index != self.selectedIndex) {
        [self setSelectedIndex:index animated:YES];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(columnBar:didSelectedTabAtIndex:)])
            [self.delegate columnBar:self didSelectedTabAtIndex:_selectedIndex];
    }
}




@end
