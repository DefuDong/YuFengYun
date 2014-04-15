//
//  RightPageCell.h
//  YunHuaShiDai
//
//  Created by 董德富 on 13-7-11.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RightPageCellHeight 44.0f
#define RightPageCellIdentifier @"RightPageCellIdentifier"

//@class MKNumberBadgeView;
@class NumberView;
@interface RightPageCell : UITableViewCell {
    @private
    UIImageView *_cellImageView;
    UILabel *_cellTitleLabel;
//    MKNumberBadgeView *_cellValueView;
    NumberView *_cellValueView;
}

@property (nonatomic, assign) UIImage   *cellImage;
@property (nonatomic, assign) NSString  *cellTitle;
@property (nonatomic, assign) NSInteger cellValue;

@end
