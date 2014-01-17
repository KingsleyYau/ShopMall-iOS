//
//  KKViewController.m
//  ShopMall
//
//  Created by KingsleyYau on 13-3-27.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "KKViewController.h"
#import "UIColor+RGB.h"
#import "ResourceManager.h"

@interface KKViewController ()

@end

@implementation KKViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibNameOrNilReal = nibNameOrNil;
    
    BOOL bSupportiPad = NO;
    /*  应用是否支持iPad
     *  1:iPhone or iTouch
     *  2:iPad
     */
    NSArray *array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIDeviceFamily"];
    for(NSNumber *deviceFamily in array) {
        if([deviceFamily integerValue] == 2) {
            bSupportiPad = YES;
            break;
        }
    }
    

    if(bSupportiPad) {
        // 应用支持iPad
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            // iPhone
        }
        else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad
            if(nil == nibNameOrNil || nibNameOrNil.length == 0) {
                nibNameOrNil = NSStringFromClass([self class]);
            }
            nibNameOrNilReal = [NSString stringWithFormat:@"%@-iPad", nibNameOrNil];
        }
    }
    
    self = [super initWithNibName:nibNameOrNilReal bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupBackgroundView];
}
- (void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewDidAppearEver = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 横屏切换
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    //return YES;
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark － 界面布局
- (void)setupNavigationBar {
    
}
- (void)setupBackgroundView {
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
