//
//  UIImage+Language.h
//  UIWidget
//
//  Created by KingsleyYau on 13-12-6.
//  Copyright (c) 2013年 drcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(Language)
+ (NSString*)getPreferredLanguage;
+ (UIImage *)imageWithContentsOfFileLanguage:(NSString *)path ofType:(NSString *)ofType;
@end
