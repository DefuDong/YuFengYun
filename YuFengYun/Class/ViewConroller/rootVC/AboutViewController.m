//
//  AboutViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-9-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    self.navigationBar.title = @"关于";
    
    NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", applicationVersion];
}


@end
