//
//  CustomCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-4.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Custom.h"
@interface Custom(Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
