//
//  CommentCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-4.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
@interface Comment(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
