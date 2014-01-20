//
//  ProductCustom.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
@interface Product(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
