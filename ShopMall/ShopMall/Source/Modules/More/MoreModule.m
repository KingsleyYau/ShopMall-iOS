//
//  MoreModule.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MoreModule.h"
#import "MoreMainViewController.h"

@interface MoreModule () {
    
}
@property (nonatomic, strong) MoreMainViewController *vc;
@end

@implementation MoreModule
- (NSString*)moduleName {
    return @"more";
}
- (UIViewController *)viewController {
    MoreMainViewController *vc = nil;
    if(!self.vc) {
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        vc = [storyBoard instantiateViewControllerWithIdentifier:@"MoreMainViewController"];
        self.vc = vc;
    }
    return self.vc;
}
@end
