//
//  SignCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-10.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sign.h"
@interface Sign(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
