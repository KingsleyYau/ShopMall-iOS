//
//  LanguageManager.m
//  DrPalm
//
//  Created by fgx_lion on 12-6-4.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "LanguageManager.h"

@implementation LanguageManager

static LanguageManager *s_languageManager = nil;
+ (LanguageManager*)shareLanguageManager
{
    if (nil == s_languageManager){
        s_languageManager = [[LanguageManager alloc] init];
    }
    return s_languageManager;
}

- (id)init
{
    self = [super init];
    if (nil != self){
        NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        if ([[language lowercaseString] isEqualToString:[@"zh-Hant" lowercaseString]]){
            // 繁体
            
        }
        else if ([[language lowercaseString] isEqualToString:[@"zh-Hans" lowercaseString]]){
            // 简体
            
        }
        else{
            // 默认（英文）
            
        }
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
@end
