//
//  UITVNewEventDateCell.h
//  DrPalm
//
//  Created by fgx_lion on 12-2-16.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDateCell : UITableViewCell{
    NSDate  *_startDate;
    NSDate  *_endDate;
    Boolean _isWholeDay;
}
@property (nonatomic, assign) Boolean isWholeDay;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

+ (id)getUITVDateCell:(UITableView*)tableView cellIdentifier:(NSString*)identifier;
+ (NSInteger)cellHeight;
@end
