//
//  RefreshView.m
//  Testself
//
//  Created by Jason Liu on 12-1-10.
//  Copyright 2012年 Yulong. All rights reserved.
//

#import "RefreshView.h"

@interface UploadLogoView : UIView
{
    __strong UIImageView *_logoImage;
    BOOL _moving;
}
@property (nonatomic, assign) float progress;
- (void)startMoving;
- (void)stopMoving;
@end


@implementation RefreshView {
    // UI
    UILabel *_refreshStatusLabel;
    UILabel *_refreshLastUpdatedTimeLabel;
    UploadLogoView *_logoView;
    
    BOOL _isDragging;
}

#pragma mark -
- (id)initWithOwner:(UIScrollView *)owner callBack:(RefreshViewCallBack)callBack {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        float headDelat = 100;
        
        self.frame = CGRectMake(0, -REFRESH_TRIGGER_HEIGHT-headDelat,
                                owner.bounds.size.width, REFRESH_TRIGGER_HEIGHT+headDelat);
//        self.frame = CGRectMake(owner.frame.origin.x, owner.frame.origin.y, owner.bounds.size.width, REFRESH_TRIGGER_HEIGHT);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        _refreshStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshStatusLabel.frame = CGRectMake(120, 15+headDelat, 200, 20.0f);
		_refreshStatusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_refreshStatusLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
		_refreshStatusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_refreshStatusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_refreshStatusLabel.backgroundColor = [UIColor clearColor];
        _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
		[self addSubview:_refreshStatusLabel];
        
        _refreshLastUpdatedTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshLastUpdatedTimeLabel.frame = CGRectMake(120, 35+headDelat, 200, 20.0f);
		_refreshLastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11.0f];
		_refreshLastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
		_refreshLastUpdatedTimeLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_refreshLastUpdatedTimeLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_refreshLastUpdatedTimeLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_refreshLastUpdatedTimeLabel];
        
        _logoView = [[UploadLogoView alloc] initWithFrame:CGRectMake(70, 20+headDelat , 30, 30)];
        [self addSubview:_logoView];
        
//        owner.backgroundColor = [UIColor clearColor];
//        UIView *superView = owner.superview;
//        if (superView) {
//            [superView insertSubview:self belowSubview:owner];
//        }
        [owner insertSubview:self atIndex:0];

        _owner = owner;
        self.callBackBlock = callBack;
    }
    return self;
}

#pragma mark - animation
- (void)stopLoading {
    if (!_isLoading) {
        return;
    }
    _isLoading = NO;
    // UI 更新日期计算
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"MM'-'dd HH':'mm':'ss"];
    NSString *timeStr = [outFormat stringFromDate:nowDate];
    // UI 赋值
    _refreshLastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@", REFRESH_UPDATE_TIME_PREFIX, timeStr];
    _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;

    [_logoView stopMoving];
    
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{_owner.contentOffset = CGPointZero;}
                     completion:NULL];
}
- (void)startLoading {
    // control
    _isLoading = YES;
    // Animation
    _refreshStatusLabel.text = REFRESH_LOADING_STATUS;
    [_logoView startMoving];
    
    [UIView animateWithDuration:.3 animations:^{
        _owner.contentOffset = CGPointMake(0, -REFRESH_TRIGGER_HEIGHT);
        _owner.contentInset = UIEdgeInsetsMake(REFRESH_TRIGGER_HEIGHT, 0, 0, 0);
    }];
 }


#pragma mark - scrollView call
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isLoading) return;
    _isDragging = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        else if (scrollView.contentOffset.y >= -REFRESH_TRIGGER_HEIGHT) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    } else if (_isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        
        _logoView.progress = fabs(scrollView.contentOffset.y) / REFRESH_TRIGGER_HEIGHT;
        
        if (scrollView.contentOffset.y < - REFRESH_TRIGGER_HEIGHT) {
            // User is scrolling above the header
            _refreshStatusLabel.text = REFRESH_RELEASED_STATUS;
//            _refreshArrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else { // User is scrolling somewhere within the header
            _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
//            _refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
        }
    }
    else if(!_isDragging && !_isLoading){
        scrollView.contentInset = UIEdgeInsetsZero;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isLoading) return;
    _isDragging = NO;
    if (scrollView.contentOffset.y <= - REFRESH_TRIGGER_HEIGHT) {
        [self startLoading];
        if (self.callBackBlock) {
            self.callBackBlock();
        }
    }
}



@end



@implementation UploadLogoView
- (void)setProgress:(float)progress {
    
    if (_moving) {
        _progress = 1;
        [self setNeedsDisplay];
        return;
    }
    
    _progress = progress;
    if (_progress >= 0 && _progress <= 1) {
        [self setNeedsDisplay];
    }
    _logoImage.transform = CGAffineTransformMakeRotation(4*M_PI*_progress);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_upload.png"]];
        _logoImage.frame = self.bounds;
        [self addSubview:_logoImage];
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)startMoving {
    if (_moving) return;
    
    self.progress = 1;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:2*M_PI];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.repeatCount = 100;
    
    [_logoImage.layer addAnimation:animation forKey:@"shakeAnimation"];
    
    _moving = YES;
}
- (void)stopMoving {
    if (_moving) {
        
        [_logoImage.layer removeAllAnimations];
        self.progress = 0;
        _moving = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    if (_progress > 1 || _progress < 0) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float value = _progress * .9;
    
//    float startAngle = -M_PI_2 + M_PI*value;
//    float endAngle = -M_PI_2 - M_PI*value;
//    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    CGContextAddArc(context,
//                    CGRectGetMidX(rect),
//                    CGRectGetMidY(rect),
//                    CGRectGetWidth(rect)*.5,
//                    startAngle,
//                    endAngle,
//                    true);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextFillEllipseInRect(context, rect);
    
    float startAngle = M_PI_2 + M_PI*value;
    float endAngle = M_PI_2 - M_PI*value;
    CGContextSetFillColorWithColor(context, kRGBColor(40, 170, 220).CGColor);
    CGContextAddArc(context,
                    CGRectGetMidX(rect),
                    CGRectGetMidY(rect),
                    CGRectGetWidth(rect)*.5,
                    startAngle,
                    endAngle,
                    true);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end







