//
//  UserCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-14.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface User(Custom)
+ (NSString *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
