//
//  LoginViewController.h
//  ShopMall
//
//  Created by KingsleyYau on 14-1-3.
//  Copyright (c) 2014年 KingsleyYau. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet KKTextField *usernameTextField;
@property (nonatomic, weak) IBOutlet KKTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) IBOutlet KKLoadingView *kkLoadingView;

- (IBAction)backAction:(id)sender;
- (IBAction)loginAction:(id)sender;
@end
