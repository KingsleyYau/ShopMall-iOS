//
//  MemberLoginTableViewCell.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-25.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MemberLoginTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
