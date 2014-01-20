//
//  RankCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-7.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rank.h"
@interface Rank(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
