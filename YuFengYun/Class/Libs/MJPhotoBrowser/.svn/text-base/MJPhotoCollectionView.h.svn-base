//
//  MJPhotoCollectionView.h
//  YuFengYun
//
//  Created by 董德富 on 13-12-11.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPhotoCollectionViewDelegate;
@interface MJPhotoCollectionView : UIView

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, weak) id<MJPhotoCollectionViewDelegate> delegate;

@end


@protocol MJPhotoCollectionViewDelegate <NSObject>

- (void)collectionPicturePressedAtIndex:(unsigned)index;

@end