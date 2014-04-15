//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"
#import "StringUtil.h"

@implementation FaceBoard
@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (void)dealloc
{
    [_inputTextField release];
    [_inputTextView release];
    [faceView release];
    [facePageControl release];
    [super dealloc];
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 216)];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((60/28+1)*320, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 0; i<60; i++) {
            UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            faceButton.tag = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            faceButton.frame = CGRectMake(((i%28)%7)*44+6+(i/28*320), ((i%28)/7)*44+8, 44, 44);
//            NSLog(@"%@  \t%d", NSStringFromCGPoint(faceButton.frame.origin), i);
          
            NSString *imageName = [NSString stringWithFormat:@"yfy%d_",i+1];
            [faceButton setImage:UIIMAGE_FILE(imageName)
                        forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(110, 190, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = 60/28+1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:UIIMAGE_FILE(@"backFace") forState:UIControlStateNormal];
        [back setImage:UIIMAGE_FILE(@"backFaceSelect") forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(270, 185, 38, 27);
        [self addSubview:back];
        
    }
    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [facePageControl setCurrentPage:faceView.contentOffset.x/320];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage*320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {
    int i = ((UIButton*)sender).tag;
    if (self.inputTextField) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [faceString appendString:[[NSString alloc] initWithCString:g_faceTable[i].newfaceCode encoding:NSUTF8StringEncoding]];

        self.inputTextField.text = faceString;
        [faceString release];
    }
    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:[[NSString alloc] initWithCString:g_faceTable[i].newfaceCode encoding:NSUTF8StringEncoding]];

        self.inputTextView.text = faceString;
        if ([self.inputTextView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.inputTextView.delegate textViewDidChange:self.inputTextView];
        }
        [faceString release];
    }
}

- (void)backFace{
    NSString *inputString;
    inputString = self.inputTextField.text;
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
    }
    
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    self.inputTextField.text = string;
    self.inputTextView.text = string;
}

@end
