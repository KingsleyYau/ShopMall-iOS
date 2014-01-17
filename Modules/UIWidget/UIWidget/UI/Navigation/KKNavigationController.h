//
//  KKNavigationController.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-25.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKNavigationControllerDelegate <NSObject>
@optional
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)backAction;
@end


@interface KKNavigationController : UINavigationController {
    id <KKNavigationControllerDelegate> _kkDelegate;
}
@property (nonatomic, assign) IBOutlet id<KKNavigationControllerDelegate> kkDelegate;
@property (nonatomic, retain) UIImage *customTitleImage; // 自定义默认导航栏标题
@property (nonatomic) BOOL isCustomBackButton; // 是否自定义默认导航栏标题
@property (nonatomic) BOOL isCustomNoTitleBackButton; // 是否自定义默认导航栏标题

// 加入栈之前先添加手势
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated gesture:(BOOL)gesture;
@end
