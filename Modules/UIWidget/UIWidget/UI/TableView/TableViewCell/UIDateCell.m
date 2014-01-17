//
//  UITVNewEventDateCell.m
//  DrPalm
//
//  Created by fgx_lion on 12-2-16.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "UIDateCell.h"
#import "UIColor+RGB.h"
#import "NSDate+ToString.h"
@implementation UIDateCell
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize isWholeDay = _isWholeDay;

#define TVDateCellFont      [UIFont systemFontOfSize:18.0]
#define TVDateTitleCellFont [UIFont boldSystemFontOfSize:18.0]
#define DateLableTextColor  [UIColor colorWithIntRGB:87 green:105 blue:141 alpha:255]
#define StartLabelTag       1511
#define StartLabelDateTag   1512
#define EndLabelTag         1513
#define EndLabelDateTag     1514

+(id)getUITVDateCell:(UITableView*)tableView cellIdentifier:(NSString*)identifier
{
    UIDateCell *cell = (UIDateCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell){
        cell = [[[UIDateCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Initialization code
        _startDate = nil;
        _endDate = nil;
        _isWholeDay = NO;
    }
    return self;
}

#define HStep 5
- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    if ([self.superview isKindOfClass:[UITableView class]]){
        NSInteger step = 10;
        NSInteger top = HStep;
        CGSize startSize;
        
        if (nil == [self viewWithTag:StartLabelTag]){
            // 开始label
            UILabel *startLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            startLable.frame = CGRectMake(step, top, self.contentView.frame.size.width, 22);
            startLable.font = TVDateTitleCellFont;
            startLable.tag = StartLabelTag;
            startLable.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:startLable];
            [startLable release];
        }
        
        UILabel *startDateLable = (UILabel*)[self viewWithTag:StartLabelDateTag];
        if (nil == startDateLable){
            // 开始DateLable
            startDateLable = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
            NSInteger startDateLeft = step + startSize.width + step;
            NSInteger startDateWidth = self.contentView.frame.size.width - startDateLeft - step;
            startDateLable.frame = CGRectMake(startDateLeft, top, startDateWidth, startSize.height);
            startDateLable.font = TVDateCellFont;
            startDateLable.textColor = DateLableTextColor;
            startDateLable.backgroundColor = [UIColor clearColor];
            startDateLable.tag = StartLabelDateTag;
            startDateLable.textAlignment = UITextAlignmentRight;
            [self.contentView addSubview:startDateLable];
            top += 22;
        }
        
        
        CGSize endSize;
        if (nil == [self viewWithTag:EndLabelTag]){
            // 结束label
            UILabel *endLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            endLable.frame = CGRectMake(step, top, self.contentView.frame.size.width, 22);
            endLable.font = TVDateTitleCellFont;
            endLable.tag = EndLabelTag;
            endLable.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:endLable];
            [endLable release];
        }
        
        UILabel *endDateLable = (UILabel*)[self viewWithTag:EndLabelDateTag];
        if (nil == endDateLable){
            // 结束DateLable
            endDateLable = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
            NSInteger endDateLeft = step + endSize.width + step;
//            NSInteger endDateWidth = self.contentView.frame.size.width - endDateLeft - step;
            endDateLable.frame = CGRectMake(endDateLeft, top, self.contentView.frame.size.width, 22);
            endDateLable.font = TVDateCellFont;
            endDateLable.textColor = DateLableTextColor;
            endDateLable.textAlignment = UITextAlignmentRight;
            endDateLable.tag = EndLabelDateTag;
            endDateLable.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:endDateLable];
        }
        if(_isWholeDay){
            startDateLable.text = [_startDate toStringYMD];
            endDateLable.text = [_endDate toStringYMD];
        }
        else{
            startDateLable.text = [_startDate toStringYMDHM];
            endDateLable.text = [_endDate toStringYMDHM];
        }
    }
}

+ (NSInteger)cellHeight {
    return 50;
}

@end
