//
//  MKNumberBadgeView.m
//  MKNumberBadgeView
//
// Copyright 2009-2012 Michael F. Kamprath
// michael@claireware.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef __has_feature
#define __has_feature(x) 0
#endif
#ifndef __has_extension
#define __has_extension __has_feature // Compatibility with pre-3.0 compilers.
#endif

#if __has_feature(objc_arc) && __clang_major__ >= 3
#error "iPhoneMK is not designed to be used with ARC. Please add '-fno-objc-arc' to the compiler flags of iPhoneMK files."
#endif // __has_feature(objc_arc)


#import "MKNumberBadgeView.h"
#import <QuartzCore/QuartzCore.h>


@interface MKNumberBadgeView ()

//
// private methods
//

- (void)initState;
- (CGPathRef)newBadgePathForTextSize:(CGSize)inSize;

@end


@implementation MKNumberBadgeView
@synthesize value=_value;
@synthesize shadow;
@synthesize shadowOffset;
@synthesize shadowColor;
@synthesize shine;
@synthesize font;
@synthesize fillColor;
@synthesize strokeColor;
@synthesize strokeWidth;
@synthesize textColor;
@synthesize alignment;
@dynamic badgeSize;
@synthesize pad;
@synthesize hideWhenZero;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
        // Initialization code
		
		[self initState];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder]) 
	{
        // Initialization code
		[self initState];
    }
    return self;
}


#pragma mark -- private methods --

- (void)initState;
{	
	self.opaque = NO;
	self.pad = 2;
	self.font = [UIFont boldSystemFontOfSize:16];
	self.shadow = YES;
	self.shadowOffset = CGSizeMake(0, 3);
	self.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
	self.shine = YES;
	self.alignment = NSTextAlignmentCenter;
	self.fillColor = [UIColor redColor];
	self.strokeColor = [UIColor whiteColor];
	self.strokeWidth = 2.0;
	self.textColor = [UIColor whiteColor];
    self.hideWhenZero = NO;
	
	self.backgroundColor = [UIColor clearColor];
}

- (void)dealloc 
{
    [font release];
    [fillColor release];
    [strokeColor release];
    [textColor release];
    [shadowColor release];
    
    [super dealloc];
}


- (void)drawRect:(CGRect)rect 
{
	CGRect viewBounds = self.bounds;
	
	CGContextRef curContext = UIGraphicsGetCurrentContext();

//	NSString* numberString = [NSString stringWithFormat:@"%d",self.value];
	
	CGSize numberSize = [self.valueString sizeWithFont:self.font];
		
	CGPathRef badgePath = [self newBadgePathForTextSize:numberSize];
	
	CGRect badgeRect = CGPathGetBoundingBox(badgePath);
	
	badgeRect.origin.x = 0;
	badgeRect.origin.y = 0;
	badgeRect.size.width = ceil( badgeRect.size.width );
	badgeRect.size.height = ceil( badgeRect.size.height );
	
    
	CGContextSaveGState( curContext );
	CGContextSetLineWidth( curContext, self.strokeWidth );
	CGContextSetStrokeColorWithColor(  curContext, self.strokeColor.CGColor  );
	CGContextSetFillColorWithColor( curContext, self.fillColor.CGColor );
	
	// Line stroke straddles the path, so we need to account for the outer portion
	badgeRect.size.width += ceilf( self.strokeWidth / 2 );
	badgeRect.size.height += ceilf( self.strokeWidth / 2 );
	
	CGPoint ctm;
	
	switch (self.alignment) 
	{
		default:
		case NSTextAlignmentCenter:
			ctm = CGPointMake( round((viewBounds.size.width - badgeRect.size.width)/2), round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
		case NSTextAlignmentLeft:
			ctm = CGPointMake( 0, round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
		case NSTextAlignmentRight:
			ctm = CGPointMake( (viewBounds.size.width - badgeRect.size.width), round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
	}
	
	CGContextTranslateCTM( curContext, ctm.x, ctm.y);

	if (self.shadow)
	{
		CGContextSaveGState( curContext );

		CGSize blurSize = self.shadowOffset;
		
		CGContextSetShadowWithColor( curContext, blurSize, 4, self.shadowColor.CGColor );
		
		CGContextBeginPath( curContext );
		CGContextAddPath( curContext, badgePath );
		CGContextClosePath( curContext );
		
		CGContextDrawPath( curContext, kCGPathFillStroke );
		CGContextRestoreGState(curContext); 
	}
	
	CGContextBeginPath( curContext );
	CGContextAddPath( curContext, badgePath );
	CGContextClosePath( curContext );
	CGContextDrawPath( curContext, kCGPathFillStroke );

	//
	// add shine to badge
	//
	
	if (self.shine)
	{
		CGContextBeginPath( curContext );
		CGContextAddPath( curContext, badgePath );
		CGContextClosePath( curContext );
		CGContextClip(curContext);
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
		CGFloat shinyColorGradient[8] = {1, 1, 1, 0.8, 1, 1, 1, 0}; 
		CGFloat shinyLocationGradient[2] = {0, 1}; 
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, 
																	shinyColorGradient, 
																	shinyLocationGradient, 2);
		
		CGContextSaveGState(curContext); 
		CGContextBeginPath(curContext); 
		CGContextMoveToPoint(curContext, 0, 0); 
		
		CGFloat shineStartY = badgeRect.size.height*0.25;
		CGFloat shineStopY = shineStartY + badgeRect.size.height*0.4;
		
		CGContextAddLineToPoint(curContext, 0, shineStartY); 
		CGContextAddCurveToPoint(curContext, 0, shineStopY, 
										badgeRect.size.width, shineStopY, 
										badgeRect.size.width, shineStartY); 
		CGContextAddLineToPoint(curContext, badgeRect.size.width, 0); 
		CGContextClosePath(curContext); 
		CGContextClip(curContext); 
		CGContextDrawLinearGradient(curContext, gradient, 
									CGPointMake(badgeRect.size.width / 2.0, 0), 
									CGPointMake(badgeRect.size.width / 2.0, shineStopY), 
									kCGGradientDrawsBeforeStartLocation); 
		CGContextRestoreGState(curContext); 
		
		CGColorSpaceRelease(colorSpace); 
		CGGradientRelease(gradient); 
		
	}
	CGContextRestoreGState( curContext );
	CGPathRelease(badgePath);
	
	CGContextSaveGState( curContext );
	CGContextSetFillColorWithColor( curContext, self.textColor.CGColor );
		
	CGPoint textPt = CGPointMake( ctm.x + (badgeRect.size.width - numberSize.width)/2 , ctm.y + (badgeRect.size.height - numberSize.height)/2 );
	
	[self.valueString drawAtPoint:textPt withFont:self.font];

	CGContextRestoreGState( curContext );

}


- (CGPathRef)newBadgePathForTextSize:(CGSize)inSize
{
	CGFloat arcRadius = ceil((inSize.height+self.pad)/2.0);
	
	CGFloat badgeWidthAdjustment = inSize.width - inSize.height/2.0;
	CGFloat badgeWidth = 2.0*arcRadius;
	
	if ( badgeWidthAdjustment > 0.0 )
	{
		badgeWidth += badgeWidthAdjustment;
	}
	
	
	CGMutablePathRef badgePath = CGPathCreateMutable();
	
	CGPathMoveToPoint( badgePath, NULL, arcRadius, 0 );
	CGPathAddArc( badgePath, NULL, arcRadius, arcRadius, arcRadius, 3.0*M_PI_2, M_PI_2, YES);
	CGPathAddLineToPoint( badgePath, NULL, badgeWidth-arcRadius, 2.0*arcRadius);
	CGPathAddArc( badgePath, NULL, badgeWidth-arcRadius, arcRadius, arcRadius, M_PI_2, 3.0*M_PI_2, YES);
	CGPathAddLineToPoint( badgePath, NULL, arcRadius, 0 );
	
	return badgePath;
	
}

#pragma mark -- property methods --

- (void)setValue:(NSUInteger)inValue
{
	_value = inValue;
    
//    if (self.hideWhenZero == YES && _value == 0)
//    {
//        self.hidden = YES;
//    }
//    else
//    {
//        self.hidden = NO;
//    }
	
    self.valueString = [NSString stringWithFormat:@"%d", _value];
//	[self setNeedsDisplay];
}
- (void)setValueString:(NSString *)valueString {
    if (valueString != _valueString) {
        [_valueString release];
        _valueString = [valueString copy];
    }
    
    if (self.hideWhenZero == YES &&
        (_valueString.length == 0 || [_valueString isEqualToString:@"0"])) {
        self.hidden = YES;
    }
    else {
        self.hidden = NO;
    }
	
	[self setNeedsDisplay];
}

- (CGSize)badgeSize
{
//	NSString* numberString = [NSString stringWithFormat:@"%d",self.value];
	
	
	CGSize numberSize = [self.valueString sizeWithFont:self.font];
	
	CGPathRef badgePath = [self newBadgePathForTextSize:numberSize];
	
	CGRect badgeRect = CGPathGetBoundingBox(badgePath);
	
	badgeRect.origin.x = 0;
	badgeRect.origin.y = 0;
	badgeRect.size.width = ceil( badgeRect.size.width );
	badgeRect.size.height = ceil( badgeRect.size.height );
	
	CGPathRelease(badgePath);
	
	return badgeRect.size;
}



@end


#define LABEL_ANIM_3D_PROSPECTIVE 0.0003
@implementation MKNumberBadgeView (animation)

- (void)_rollOver_duration:(float)dur value:(NSInteger)value {
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:4];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = LABEL_ANIM_3D_PROSPECTIVE;
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    for (int i = 1; i < 4; i++) {
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        [values addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = values;
    animation.duration = dur * .5;
    //    animation.removedOnCompletion = NO;
    //    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:nil];
    
    [self performSelector:@selector(_rollOver_2:)
               withObject:@{@"dur": [NSNumber numberWithFloat:dur], @"value": [NSNumber numberWithInteger:value]}
               afterDelay:dur*.5];
}
- (void)_rollOver_2:(NSDictionary *)dic {
    float dur = [[dic objectForKey:@"dur"] floatValue];
    NSInteger value = [[dic objectForKey:@"value"] integerValue];
    self.value = value;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:4];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = LABEL_ANIM_3D_PROSPECTIVE;
    for (int i = 3; i >= 0; i--) {
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        [values addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = values;
    animation.duration = dur * .5;
    //    animation.removedOnCompletion = NO;
    //    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)_shrink_duration:(float)dur value:(NSInteger)value {
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    animation1.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation1.duration = dur*.5;
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = @[@0.0, [NSNumber numberWithFloat:M_PI*.9], [NSNumber numberWithFloat:M_PI*1.8]];
    rotateAnimation.duration = dur*.5;
    rotateAnimation.keyTimes = @[@0.0, @.4, @1.];
        
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation1, rotateAnimation];
    group.duration = dur*.5;
    [self.layer addAnimation:group forKey:nil];
    
    [self performSelector:@selector(_shrink_2:)
               withObject:@{@"dur": [NSNumber numberWithFloat:dur], @"value": [NSNumber numberWithInteger:value]}
               afterDelay:dur*.5];
}
- (void)_shrink_2:(NSDictionary *)dic {
    float dur = [[dic objectForKey:@"dur"] floatValue];
    NSInteger value = [[dic objectForKey:@"value"] integerValue];
    self.value = value;
        
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    animation1.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation1.duration = dur*.5;
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = @[[NSNumber numberWithFloat:M_PI*1.8], [NSNumber numberWithFloat:M_PI*.9], @0.0];
    rotateAnimation.duration = dur*.5;
    rotateAnimation.keyTimes = @[@0.0, @.4, @1.];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation1, rotateAnimation];
    group.duration = dur * .5;
    [self.layer addAnimation:group forKey:nil];
}

- (void)_shake_duration:(float)dur value:(NSInteger)value {
    float duration = dur * .1;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.1, .1, 1)];
    [self.layer addAnimation:animation forKey:nil];
    
    [self performSelector:@selector(_shake_2:)
               withObject:@{@"dur": [NSNumber numberWithFloat:dur-duration], @"value": [NSNumber numberWithInteger:value]}
               afterDelay:duration];
}
- (void)_shake_2:(NSDictionary *)dic {
    float duration = [[dic objectForKey:@"dur"] floatValue];
    NSInteger value = [[dic objectForKey:@"value"] integerValue];
    self.value = value;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(.1, .1, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(.8, .8, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    animation.keyTimes = @[@0.0, @.3, @.65, @1.0];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)setValueAnimated:(NSInteger)value
                   style:(NumberTransformStyle)style
                duration:(float)dur {
    
    if (self.value == value) {
        return;
    }
    
    if (self.superview) {
        
		switch (style) {
                
			case NumberTransformStyleRollOver:
                [self _rollOver_duration:dur value:value];
				break;
                
			case NumberTransformStyleShrinkInOut:
                [self _shrink_duration:dur value:value];
				break;
                
            case NumberTransformStyleShake:
                [self _shake_duration:dur value:value];
                break;
                
		}
	}
}

@end





