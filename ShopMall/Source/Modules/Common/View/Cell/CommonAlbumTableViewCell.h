//
//  HomeTableViewCell.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonAlbumTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView  *containView1;
@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView1;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel1;

@property (nonatomic, weak) IBOutlet UIView  *containView2;
@property (nonatomic, weak) IBOutlet RequestImageView *requestImageView2;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel2;



+ (NSString *)cellIdentifier;
+ (NSInteger)cellHeight;
+ (id)getUITableViewCell:(UITableView*)tableView;
@end
