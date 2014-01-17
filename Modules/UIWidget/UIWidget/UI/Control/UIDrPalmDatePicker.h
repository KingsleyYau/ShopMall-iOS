//
//  UIDrPalmDatePicker.h
//  DrPalm
//
//  Created by drcom on 2/22/12.
//  Copyright (c) 2012 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIDrPalmDatePickerDelegate
-(void)getStartAndEndDate:(NSDate*)startDate endDate:(NSDate*)endDate wholeDay:(BOOL)wholeDay;
@end
@class UIDrPalmDatePickerDelegate;
@interface UIDrPalmDatePicker : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UIDrPalmDatePickerDelegate *_delegate;
    UITableView *_tableView;
    NSMutableDictionary *_tableDict;
    UIDatePicker *_datePickerYear;
    UIDatePicker *_datePickerDay;    
    NSDate      *_start;
    NSDate      *_end;
    //NSDateComponents *comoponents;
    Boolean _bShart;
    Boolean _bInited;
    Boolean _isWholeDay;
    NSIndexPath *_iSection;
    UISwitch* _wholeDaySwitch;


}
@property (nonatomic, assign) Boolean isWholeDay;
@property (nonatomic, retain) UITableView   *tableView;
@property (nonatomic, retain) NSMutableDictionary   *tableDict;
@property (nonatomic, retain) UIDatePicker *datePickerYear; 
@property (nonatomic, retain) UIDatePicker *datePickerDay;
@property (nonatomic, copy) NSDate    *start;
@property (nonatomic, copy) NSDate    *end;
@property (nonatomic, retain) NSIndexPath *iSection;

-(void) popup:(UIViewController*)parent delegate:(UIDrPalmDatePickerDelegate*)delegate;
-(void) close;

-(void)datePickerYearChanged;
-(void)datePickerDayChanged;
-(void)switchChanged:(id)sender;
@end
