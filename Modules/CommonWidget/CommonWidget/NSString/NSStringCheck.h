//
//  NSStringCheck.h
//  DrPalm
//
//  Created by JiangBo on 13-1-6.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)
- (BOOL)isPhoneNum;
- (BOOL)isSearchString;
- (NSString *)commitString;
@end
