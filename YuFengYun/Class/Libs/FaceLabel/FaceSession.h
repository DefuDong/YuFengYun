//
//  FaceSession.h
//  TXiPhone
//
//  Created by qinxg on 13-10-22.
//
//

#import <Foundation/Foundation.h>

@interface FaceSession : NSObject
{
    NSMutableDictionary *dicSession;
}

+ (id)singleFaceSession;

- (void)addFace:(UIImage *)_img
           With:(NSString *)fileName;
- (UIImage *)getFaceWith:(NSString *)fileName;

- (void)delAllFaceSession;

@end
