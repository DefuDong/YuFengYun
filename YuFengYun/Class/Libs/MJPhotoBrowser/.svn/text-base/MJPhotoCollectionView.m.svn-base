//
//  MJPhotoCollectionView.m
//  YuFengYun
//
//  Created by 董德富 on 13-12-11.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "MJPhotoCollectionView.h"
#import "UIButton+WebCache.h"
#import "NETResponse_Picture.h"
#import <QuartzCore/QuartzCore.h>

@implementation MJPhotoCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect titleFrame = CGRectMake(0, 0, self.frame.size.width, 44);
//    if (SYSTEM_VERSION_MOER_THAN_7) {
//        titleFrame.origin.y = 20;
//    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"推荐图集";
    [self addSubview:titleLabel];
    
    if (!photos || !photos.count) {
        UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        noLabel.center = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
        noLabel.textColor = [UIColor whiteColor];
        noLabel.backgroundColor = [UIColor clearColor];
        noLabel.text = @"没有相关推荐";
        noLabel.textAlignment = UITextAlignmentCenter;
        noLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:noLabel];
        
        return;
    }
    
    
    for (int i = 0; i < photos.count; i++) {
        NETResponse_Picture_Recommen *data = photos[i];
        
        float delta = [UIScreen mainScreen].applicationFrame.size.height > 480 ? 150 : 70;
        CGRect frame = CGRectMake((i%2) ? 164 : 8, (i>1 ? 110 : 0) + delta, 149, 102);
        
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = [UIColor darkGrayColor];
        backView.layer.cornerRadius = 3;
        backView.clipsToBounds = YES;
        [self addSubview:backView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectInset(backView.bounds, 4, 4);
        button.tag = i;
        [button setImageWithURL:[NSURL URLWithString:data.mediaDeckblatt] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height-40, button.frame.size.width, 40)];
        back.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        back.userInteractionEnabled = NO;
        [button addSubview:back];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(back.bounds, 4, 2)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.text = data.mediaTitle;
        [back addSubview:label];
    }
}

- (void)buttonPressed:(UIButton *)button {
    int tag = button.tag;
    if ([self.delegate respondsToSelector:@selector(collectionPicturePressedAtIndex:)]) {
        [self.delegate collectionPicturePressedAtIndex:tag];
    }
}


@end



