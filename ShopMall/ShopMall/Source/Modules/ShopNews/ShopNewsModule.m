//
//  ShopNewsModule.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ShopNewsModule.h"
#import "ShopNewsMainViewController.h"
@interface ShopNewsModule () {
    
}
@property (nonatomic, strong) ShopNewsMainViewController *vc;
@end

@implementation ShopNewsModule
- (NSString*)moduleName {
    return @"shopnews";
}
- (UIViewController *)viewController {
    ShopNewsMainViewController *vc = nil;
    if(!self.vc) {
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        vc = [storyBoard instantiateViewControllerWithIdentifier:@"ShopNewsMainViewController"];
        self.vc = vc;
    }
    return self.vc;
}
@end
