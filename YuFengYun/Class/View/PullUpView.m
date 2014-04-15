//
//  PullUpView.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-14.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "PullUpView.h"

#define kTYPE_NORMAL @"上拉加载更多"
#define kTYPE_LOADING @"加载中..."
#define kTYPE_NEXTPAGE @"点击加载下一页"
#define kTYPE_NOMORE @"没有更多"

@implementation PullUpView {
    __weak UITableView *_owner;
    __strong UIActivityIndicatorView *_refreshIndicator;
//    BOOL _isLoading;
}

- (void)setType:(PullUpViewType)type {
    _type = type;
    switch (_type) {
        case PullUpViewTypeNormal:
            if (_owner.tableFooterView != self) {
                _owner.tableFooterView = self;
            }
            [_refreshIndicator stopAnimating];
            [_button setTitle:kTYPE_NORMAL forState:UIControlStateNormal];
            _button.enabled = NO;
            break;
        case PullUpViewTypeLoading:
            if (_owner.tableFooterView != self) {
                _owner.tableFooterView = self;
            }
            [_refreshIndicator startAnimating];
            [_button setTitle:kTYPE_LOADING forState:UIControlStateNormal];
            _button.enabled = NO;
            break;
        case PullUpViewTypeNoMore:
            _owner.tableFooterView = nil;
            [_refreshIndicator stopAnimating];
            [_button setTitle:kTYPE_NOMORE forState:UIControlStateNormal];
            _button.enabled = NO;
            break;
        case PullUpViewTypeNextPage:
            if (_owner.tableFooterView != self) {
                _owner.tableFooterView = self;
            }
            [_refreshIndicator stopAnimating];
            [_button setTitle:kTYPE_NEXTPAGE forState:UIControlStateNormal];
            _button.enabled = YES;
            break;
    }
}

#pragma mark -
- (id)initWithOwner:(UITableView *)owner complete:(PullUpComplete)block {
    self = [super initWithFrame:CGRectMake(0, 0, owner.frame.size.width, 44)];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];//kRGBColor(191, 191, 191);
        _owner = owner;
        self.completeBlock = block;
        
        UIImage *image = [UIImage imageNamed:@"register_button_back.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectInset(self.bounds, 5, 5);
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_button setBackgroundImage:image forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_button];
        
		_refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshIndicator.center = CGPointMake(100, self.frame.size.height *.5);
        _refreshIndicator.hidesWhenStopped = YES;
		[self addSubview:_refreshIndicator];
        
        _owner.tableFooterView = self;
        self.type = PullUpViewTypeNormal;
    }
    return self;
}


#pragma mark - scrollView call
- (void)tableViewDidScroll:(UITableView *)tableView {
//    UIView *headView = tableView.tableHeaderView;
    UIView *footView = tableView.tableFooterView;
    
    float contentHeight = tableView.contentSize.height;
    if (footView) {
        contentHeight -= footView.frame.size.height;
    }
    
    float offsetY = tableView.contentOffset.y + tableView.frame.size.height;
    if (offsetY > contentHeight) {
        if (self.type == PullUpViewTypeNormal) {
            if (self.completeBlock) {
                self.completeBlock();
            }
//            NSLog(@"+++++");
        }
    }
//    NSLog(@"%f, %f,     %f", tableView.contentSize.height, contentHeight, offsetY);
}


@end







