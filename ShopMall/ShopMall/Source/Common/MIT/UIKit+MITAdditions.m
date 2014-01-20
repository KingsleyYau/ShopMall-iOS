#import "UIKit+MITAdditions.h"

@implementation UIActionSheet (MITUIAdditions)
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
//    CGRect bounds = self.bounds;
    CGRect pFrame = self.superview.frame;
//    CGRect pBounds = self.superview.bounds;

    if(frame.size.height > 0) {
        self.frame = CGRectMake(0, pFrame.size.height - frame.size.height, self.frame.size.width, self.frame.size.height);
    }
}
- (void)showFromAppDelegate {
//    MIT_MobileAppDelegate *appDelegate = (MIT_MobileAppDelegate *)[UIApplication sharedApplication].delegate;
//    if ([appDelegate usesTabBar]) {
//        [self showFromTabBar:appDelegate.tabBarController.tabBar];
//    } else if (nil != AppDelegate().myTabBarController && nil != MITAppDelegate().myTabBarController.tabBar)
//        [self showFromTabBar:MITAppDelegate().myTabBarController.tabBar];
//    else {
//        [self showInView:appDelegate.window];
//    }
}

@end


