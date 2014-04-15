//
//  AlertUtility.m
//  JieKuWang
//
//  Created by 董德富 on 13-4-3.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "AlertUtility.h"

@implementation AlertUtility


+ (void)showAlertWithMess:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"错误"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"好的"
                      otherButtonTitles:nil, nil] show];
}
+ (void)showAlertWithTitle:(NSString *)title mess:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"好的"
                      otherButtonTitles:nil, nil] show];
}

@end
