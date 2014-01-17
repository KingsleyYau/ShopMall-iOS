//
//  ShopImageCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-3.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopImage.h"
#define ImageTypeProduct @"产品"
#define ImageTypeAir     @"氛围"
#define ImageTypeOther   @"其它"

@interface ShopImage(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
