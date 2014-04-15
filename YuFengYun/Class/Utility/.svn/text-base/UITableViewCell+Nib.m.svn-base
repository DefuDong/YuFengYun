//
//  NSString+URL.m
//  jinnyVVM
//
//  Created by  on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UITableViewCell+Nib.h"

@implementation UITableViewCell (Nib)


+ (UITableViewCell *)cellWithNibName:(NSString *)name {
	NSArray *objSet = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
	id targetClass = NSClassFromString(name);
	id result = nil;
	for (id object in objSet) {
		if ([object isKindOfClass:targetClass]){
			result = object;
			break;
		}
	}
	return result;    
}


@end
