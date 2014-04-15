//
//  FaceSession.m
//  TXiPhone
//
//  Created by qinxg on 13-10-22.
//
//

#import "FaceSession.h"

static FaceSession *returnFaceSession;

@implementation FaceSession

+ (id)singleFaceSession
{
    @synchronized (self)
    {
        if (returnFaceSession == nil)
        {
            [[self alloc] init];
        }
    }
    return returnFaceSession;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (returnFaceSession == nil) {
            returnFaceSession = [super allocWithZone:zone];
            return returnFaceSession;
        }
    }
    return nil;
}


- (void)addFace:(UIImage *)_img
           With:(NSString *)fileName
{
    if (dicSession)
    {
        [dicSession setObject:_img forKey:fileName];
    }
}

- (UIImage *)getFaceWith:(NSString *)fileName
{
    if (dicSession) {
        if ([dicSession objectForKey:fileName])
        {
            return [dicSession objectForKey:fileName];
        }
    }
    return nil;
}

- (void)delAllFaceSession
{
    if (dicSession) {
        [dicSession removeAllObjects];
    }
}


- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;
}

- (oneway void) release
{
    [dicSession release], dicSession = nil;
}

- (id) autorelease
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        [super init];
        dicSession = [[NSMutableDictionary alloc] init];
        return self;
    }
}
@end
