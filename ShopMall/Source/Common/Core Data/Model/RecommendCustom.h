//
//  RecommendCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-13.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recommend.h"
@interface Recommend(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
