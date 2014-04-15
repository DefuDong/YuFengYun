//
//  MLNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define FRAME_WIDTH (self.view.frame.size.width)
#define DURATION 0.3f

#import "MLNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface MLNavigationController () {
    
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
//    UIView *blackMask;    
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *screenShotsList;

@property (nonatomic, strong,) UIPanGestureRecognizer *panGesture;

@end

@implementation MLNavigationController
- (UIView *)backgroundView {
    if (!_backgroundView) {
        CGRect frame = self.view.bounds;
        
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
        
        lastScreenShotView = [[UIImageView alloc] initWithFrame:frame];
        [_backgroundView addSubview:lastScreenShotView];
        
//        blackMask = [[UIView alloc] initWithFrame:frame];
//        blackMask.backgroundColor = [UIColor blackColor];
//        [_backgroundView addSubview:blackMask];
        
    }
    return _backgroundView;
}

#pragma mark - view -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
        self.canDragBack = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
//    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
//    [self.view addSubview:shadowImageView];
    
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    self.panGesture.enabled = NO;
    self.panGesture.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panGesture];

}


#pragma mark - navi -
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self.screenShotsList addObject:[self capture]];
    
    if (!animated) {
        [super pushViewController:viewController animated:NO];
    }else {
        
        self.backgroundView.hidden = NO;
        lastScreenShotView.image = [self.screenShotsList lastObject];
        [super pushViewController:viewController animated:NO];
        [self moveViewWithX:FRAME_WIDTH];
        
        [UIView animateWithDuration:DURATION
                         animations:^{[self moveViewWithX:0];}
                         completion:^(BOOL finished) {
                             self.backgroundView.hidden = YES;
                         }];
    }
    
    if (self.viewControllers.count > 1 || self.viewControllers[0] != self.topViewController) {
        self.panGesture.enabled = YES;
    }else {
        self.panGesture.enabled = NO;
    }
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    if (!animated) {
        return [self finishedPop];
    }
    
    self.backgroundView.hidden = NO;
    lastScreenShotView.image = [self.screenShotsList lastObject];
    [self moveViewWithX:0];
    
    [UIView animateWithDuration:DURATION
                     animations:^{
                         [self moveViewWithX:FRAME_WIDTH];
                     }
                     completion:^(BOOL finished) {
                         [self finishedPop];
                         
                         CGRect frame = self.view.frame;
                         frame.origin.x = 0;
                         self.view.frame = frame;
                         
                         self.backgroundView.hidden = YES;
                     }];
    return nil;
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if (!animated) {
        return [self finishedPopRoot];
    }
    
    self.backgroundView.hidden = NO;
    lastScreenShotView.image = self.screenShotsList[1];
    [self moveViewWithX:0];
    
    [UIView animateWithDuration:DURATION
                     animations:^{[self moveViewWithX:FRAME_WIDTH];}
                     completion:^(BOOL finished) {
                         
                         [self finishedPopRoot];
                                                  
                         CGRect frame = self.view.frame;
                         frame.origin.x = 0;
                         self.view.frame = frame;
                         
                         self.backgroundView.hidden = YES;
                     }];
    return nil;
}


#pragma mark - Utility Methods -
- (UIImage *)capture {
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
//    __block UIImage *returnImage = nil;
//    __weak MLNavigationController *wself = self;
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        __strong MLNavigationController *sself = wself;
//        UIGraphicsBeginImageContextWithOptions(sself.view.bounds.size, sself.view.opaque, 0.0);
//        [sself.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//        
//        returnImage = UIGraphicsGetImageFromCurrentImageContext();
//        
//        UIGraphicsEndImageContext();
//    });
    
    return returnImage;
}
- (void)moveViewWithX:(float)x {
    
    x = x > FRAME_WIDTH ? FRAME_WIDTH : x;
    x = x < 0 ? 0 : x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    
    CGRect backFrame = self.backgroundView.frame;
    backFrame.origin.x = (x-FRAME_WIDTH)*.35;
    self.backgroundView.frame = backFrame;
    
//    float scale = (x/6400)+0.95;
//    float alpha = 0.4 - (x/800);

//    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
//    blackMask.alpha = alpha;
}

- (UIViewController *)finishedPop {
    [self.screenShotsList removeLastObject];
    
    UIViewController *perViewController = [super popViewControllerAnimated:NO];
    
    if (self.viewControllers.count <= 1) {
        self.panGesture.enabled = NO;
    } else {
        self.panGesture.enabled = YES;
    }
    return perViewController;
}
- (NSArray *)finishedPopRoot {
    [self.screenShotsList removeAllObjects];
    
    NSArray *viewControllers = [super popToRootViewControllerAnimated:NO];
    self.panGesture.enabled = NO;
    
    return viewControllers;
}


#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer {
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    switch (recoginzer.state) {
        case UIGestureRecognizerStateBegan: {
            startTouch = touchPoint;
            
            self.backgroundView.hidden = NO;
            lastScreenShotView.image = [self.screenShotsList lastObject];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self moveViewWithX:touchPoint.x - startTouch.x];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (touchPoint.x - startTouch.x > 50) {
                [UIView animateWithDuration:DURATION
                                 animations:^{[self moveViewWithX:FRAME_WIDTH];}
                                 completion:^(BOOL finished) {
//                                     [self popViewControllerAnimated:NO];
                                     [self finishedPop];
                                     
                                     CGRect frame = self.view.frame;
                                     frame.origin.x = 0;
                                     self.view.frame = frame;
                                     
                                     self.backgroundView.hidden = YES;
                                 }];
            }
            else {
                [UIView animateWithDuration:DURATION
                                 animations:^{ [self moveViewWithX:0];}
                                 completion:^(BOOL finished) {
                                     self.backgroundView.hidden = YES;
                                 }];
                
            }
        }
            break;
        case UIGestureRecognizerStateCancelled: {
            [UIView animateWithDuration:DURATION
                             animations:^{[self moveViewWithX:0];}
                             completion:^(BOOL finished) {
                                 self.backgroundView.hidden = YES;
                             }];
        }
            break;
            
        default:
            break;
    }
    
}

@end
