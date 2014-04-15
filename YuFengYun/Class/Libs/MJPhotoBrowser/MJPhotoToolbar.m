//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    
    UILabel *_titleLabel;
    UIScrollView *_detailBackView;
    UILabel *_detailLabel;
    //button
    NSArray *_buttons;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame {
//    frame.size.height = kToolBarHeight;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self loadSubviews];
    }
    return self;
}
- (void)loadSubviews {
    //title
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 270, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    //page
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 20, 40, 20)];
    _indexLabel.font = [UIFont systemFontOfSize:14];
    _indexLabel.backgroundColor = [UIColor clearColor];
    _indexLabel.textColor = [UIColor whiteColor];
//    _indexLabel.textAlignment = NSTextAlignmentRight;
    _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_indexLabel];
    //detail
    _detailBackView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 43, 310, kToolBarHeight-43-40)];
    _detailBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:_detailBackView];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.frame.size.width, 0)];
    _detailLabel.numberOfLines = 0;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = [UIColor whiteColor];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    [_detailBackView addSubview:_detailLabel];
    
    float perL = self.frame.size.width / 4;
    NSArray *images = @[@"picture_enjoy.png", @"picture_collect.png", @"picture_download.png", @"picture_share.png"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        CGRect frame = CGRectMake(perL*i + 30, kToolBarHeight - 33, 26, 24);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.frame = frame;
        button.tag = i;
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"detail_tool_like2.png"] forState:UIControlStateSelected];
        }
        if (i == 1) {
            [button setImage:[UIImage imageNamed:@"detail_tool_collect2.png"] forState:UIControlStateSelected];
        }
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [array addObject:button];
    }
    _buttons = array;
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}
- (void)setDetail:(NSString *)detail {
    _detail = detail;
    CGSize size = [_detail sizeWithFont:_detailLabel.font
                      constrainedToSize:CGSizeMake(_detailBackView.frame.size.width, 1000)
                          lineBreakMode:_detailLabel.lineBreakMode];
    CGRect rect = _detailLabel.frame;
    rect.size.height = size.height;
    _detailLabel.frame = rect;
    _detailBackView.contentSize = _detailLabel.frame.size;

    _detailLabel.text = _detail;
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex {
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d/%d", _currentPhotoIndex + 1, _photos.count];
    
//    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
//    _saveImageBtn.enabled = photo.image != nil && !photo.save;
}
- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
}


#pragma mark - actions
- (void)buttonPressed:(UIButton *)button {
    int tag = button.tag;
    if (tag == 2) {
        [self saveImage];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(toolBarButtonPressedAtIndex:)]) {
        [self.delegate toolBarButtonPressedAtIndex:tag];
    }
}
- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
//        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        0/255.0, 0/255.0, 0/255.0, 0,
        0/255.0, 0/255.0, 0/255.0, 1,
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(0, 0),
                                CGPointMake(0, rect.size.height),
                                0);
}

@end
