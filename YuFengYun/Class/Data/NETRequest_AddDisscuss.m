//
//  NETRequest_AddDisscuss.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-8-7.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "NETRequest_AddDisscuss.h"

@implementation NETRequest_AddDisscuss

- (NSDictionary *)build {
    if (self.articleId) {
        [self.requestDic setObject:self.articleId forKey:@"articleId"];
    }
    if (self.commentUserId) {
        [self.requestDic setObject:self.commentUserId forKey:@"commentUserId"];
    }
    if (self.commentObjectId) {
        [self.requestDic setObject:self.commentObjectId forKey:@"commentObjectId"];
    }
    if (self.commentText) {
        [self.requestDic setObject:self.commentText forKey:@"commentText"];
    }
    if (self.commentType) {
        [self.requestDic setObject:self.commentType forKey:@"commentType"];
    }
    
    return self.requestDic;
}

- (NSDictionary *)loadArticleId:(NSNumber *)articleId
                  commentUserId:(NSNumber *)commentUserId
                commentObjectId:(NSNumber *)commentObjectId
                    commentText:(NSString *)commentText
                    commentType:(NSString *)commentType {
    self.articleId = articleId;
    self.commentUserId = commentUserId;
    self.commentObjectId = commentObjectId;
    self.commentText = commentText;
    self.commentType = commentType;
    return [self build];
}

@end
