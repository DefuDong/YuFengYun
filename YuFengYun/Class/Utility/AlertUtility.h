//
//  AlertUtility.h
//  JieKuWang
//
//  Created by 董德富 on 13-4-3.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertUtility : NSObject

+ (void)showAlertWithMess:(NSString *)message;
+ (void)showAlertWithTitle:(NSString *)title mess:(NSString *)message;

@end
