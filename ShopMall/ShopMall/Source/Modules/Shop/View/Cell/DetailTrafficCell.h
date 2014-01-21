//
//  DetailTrafficCell.h
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTrafficCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

+ (NSString *)htmlStringFromString:(NSString *)source;
+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (NSInteger)cellHeight:(UITableView *)tableView titleString:(NSString *)titleString webViewHeight:(NSInteger)webViewHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
