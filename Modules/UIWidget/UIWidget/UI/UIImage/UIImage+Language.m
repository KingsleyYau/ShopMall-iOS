//
//  UIImage+Language.m
//  UIWidget
//
//  Created by KingsleyYau on 13-12-6.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import "UIImage+Language.h"

@implementation UIImage(Language)
/**
 *  得到本机现在用的语言
 *  en:英文
    zh-Hans:简体中文   
    zh-Hant:繁体中文    
    ja:日本  
    ......
 */
+ (NSString *)getPreferredLanguage {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
//    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}
+ (UIImage *)imageWithContentsOfFileLanguage:(NSString *)path ofType:(NSString *)ofType {
    NSString *newPath = path;
    
    NSString *suffix = [NSString stringWithFormat:@".%@", ofType];
    NSArray *array = [path componentsSeparatedByString:suffix];
    
    NSString *lang = [UIImage getPreferredLanguage];
    if([lang isEqualToString:@"zh-Hans"]){
        if(array.count > 1) {
            newPath = [array objectAtIndex:0];
            newPath = [newPath stringByAppendingString:@"-s"];
            newPath = [newPath stringByAppendingString:suffix];
        }
    }
    else if([lang isEqualToString:@"zh-Hant"]){
        if(array.count > 1) {
            newPath = [array objectAtIndex:0];
            newPath = [newPath stringByAppendingString:@"-t"];
            newPath = [newPath stringByAppendingString:suffix];
        }
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:newPath];
    if(!image) {
        // 找不到对应的图片, 用原路径的图片
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}
@end
