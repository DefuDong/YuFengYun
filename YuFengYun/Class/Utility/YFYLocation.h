//
//  YFYLocation.h
//  JieKuWang
//
//  Created by 董德富 on 13-4-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^completeBlock)(NSString *city, NSString *address);

@interface YFYLocation : NSObject

- (void)startLocation:(completeBlock)block;

@end