//
//  ShopModule.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ShopModule.h"
#import "ShopMainViewController.h"
@interface ShopModule () {
    
}
@property (nonatomic, strong) ShopMainViewController *vc;
@end

@implementation ShopModule
- (NSString*)moduleName {
    return @"shop";
}
- (UIViewController *)viewController {
    ShopMainViewController *vc = nil;
    if(!self.vc) {
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopMainViewController"];
        self.vc = vc;
    }
    return self.vc;
}
@end
