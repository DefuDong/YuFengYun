//
//  VideoCell.h
//  YuFengYun
//
//  Created by 董德富 on 13-12-6.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CollectionArticleCellCellHeight 81
#define CollectionArticleCellIdentifier @"CollectionArticleCellIdentifier"

@protocol CollectionArticleCellDelegate;
@interface CollectionArticle_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;


@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (nonatomic, weak) id<CollectionArticleCellDelegate> delegate;


@end



@protocol CollectionArticleCellDelegate <NSObject>
@optional
- (void)collectionArticleCellDelete:(CollectionArticle_Cell *)cell;

@end