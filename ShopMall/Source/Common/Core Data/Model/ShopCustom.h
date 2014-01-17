//
//  ShopCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-27.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shop.h"
@interface Shop(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
