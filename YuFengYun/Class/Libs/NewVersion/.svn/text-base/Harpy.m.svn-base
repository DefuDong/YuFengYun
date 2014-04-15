//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"

#define kHarpyAppID                 @"730854565"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@implementation Harpy

#pragma mark - Public Methods
+ (void)checkForNewVersion
{
    @synchronized (self)
    {
        @autoreleasepool
        {            
            //first check iTunes
            NSString *iTunesServiceURL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
            
            NSError *error;
            NSURLResponse *response;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:iTunesServiceURL]
                                                     cachePolicy:NSURLCacheStorageNotAllowed
                                                 timeoutInterval:20.0];
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
            if (data) {
                //convert to string
                NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:NULL];
                
                NSNumber *count = [appData objectForKey:@"resultCount"];
                if ([count integerValue] == 0) {
                    [[[UIAlertView alloc] initWithTitle:@"没有新版本"
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:@"好的"
                                      otherButtonTitles:nil, nil] show];
                    return;
                }
                
                NSDictionary *result = [appData[@"results"] objectAtIndex:0];
                
                NSString *releaseNotes = result[@"releaseNotes"];
                NSString *latestVersion = result[@"version"];
                                
                //check for new version
                NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                BOOL newerVersionAvailable = ([latestVersion compare:applicationVersion options:NSNumericSearch] == NSOrderedDescending);
                                
                if (newerVersionAvailable) {
//                    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 %@ 已经可用于更新", latestVersion]
                                                                        message:releaseNotes
                                                                       delegate:self
                                                              cancelButtonTitle:@"以后再说"
                                                              otherButtonTitles:@"更新", nil];
                    
                    [alertView show];
                }else {
                    [[[UIAlertView alloc] initWithTitle:@"没有新版本"
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:@"好的"
                                      otherButtonTitles:nil, nil] show];
                }
            }
        }
    }
}



#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch ( buttonIndex ) {
            
        case 0:
            break;
            
        case 1:{ // Update
            
            NSString *iTunesString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", kHarpyAppID];
            NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
            [[UIApplication sharedApplication] openURL:iTunesURL];
            
        } break;
            
        default:
            break;
    }
}

@end
