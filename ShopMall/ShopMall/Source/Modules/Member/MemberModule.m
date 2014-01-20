//
//  MemberModule.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MemberModule.h"
#import "MemberMainViewController.h"

@interface MemberModule () {
    
}
@property (nonatomic, strong) MemberMainViewController *vc;
@end

@implementation MemberModule
- (NSString*)moduleName {
    return @"member";
}
- (UIViewController *)viewController {
    MemberMainViewController *vc = nil;
    if(!self.vc) {
        UIStoryboard *storyBoard = AppDelegate().storyBoard;
        vc = [storyBoard instantiateViewControllerWithIdentifier:@"MemberMainViewController"];
        self.vc = vc;
    }
    return self.vc;
}
@end
