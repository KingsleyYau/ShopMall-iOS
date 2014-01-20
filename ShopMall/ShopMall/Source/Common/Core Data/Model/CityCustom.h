//
//  CityCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-24.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
@interface City(Custom)
+ (NSNumber *)idWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;
@end
