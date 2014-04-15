//
//  PictureCell.h
//  YuFengYun
//
//  Created by 董德富 on 13-12-5.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PictureCellCellHeight 175
#define PictureCellIdentifier @"PictureCellIdentifier"

@protocol PictureCellDelegate;
@interface PictureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *pictureNumLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *discussLabel_1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *pictureNumLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *discussLabel_2;

@property (weak, nonatomic) id<PictureCellDelegate>delegate;

- (void)setBViewHidden:(BOOL)hide;

@end


@protocol PictureCellDelegate <NSObject>
@optional
- (void)pictureCell:(PictureCell *)cell tapAtIndex:(unsigned)index;
@end






@interface PictureCellBackView : UIView
@end
