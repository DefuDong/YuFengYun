//
//  FaceBoard.h
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import <UIKit/UIKit.h>

@interface FaceBoard : UIView<UIScrollViewDelegate>{
    UIScrollView *faceView;
    UIPageControl *facePageControl;
}
@property (nonatomic, assign) UITextField *inputTextField;
@property (nonatomic, assign) UITextView *inputTextView;

@end
