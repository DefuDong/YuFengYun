//
//  VideoCell.h
//  YuFengYun
//
//  Created by 董德富 on 13-12-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CollectionVideoCellCellHeight 95
#define CollectionVideoCellIdentifier @"CollectionVideoCellIdentifier"

@protocol CollectionVideoCellDelegate;
@interface CollectionVideo_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;


@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (nonatomic, weak) id<CollectionVideoCellDelegate> delegate;

@end


@protocol CollectionVideoCellDelegate <NSObject>
@optional
- (void)collectionVideoCellDelete:(CollectionVideo_Cell *)cell;

@end