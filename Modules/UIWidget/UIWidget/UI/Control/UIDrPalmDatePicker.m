//
//  UIDrPalmDatePicker.m
//  DrPalm
//
//  Created by drcom on 2/22/12.
//  Copyright (c) 2012 DrCOM. All rights reserved.
//



#import "UIDrPalmDatePicker.h"
#import "UIColor+RGB.h"
#import "NSDate+ToString.h"
#import "UIDateCell.h"
#import "ResourceManager.h"
#import "../ImageDefine.h"
#import "../UILanguageDefine.h"


@implementation UIDrPalmDatePicker
@synthesize tableView = _tableView;
@synthesize tableDict = _tableDict;
@synthesize datePickerYear = _datePickerYear; 
@synthesize datePickerDay = _datePickerDay;
@synthesize start = _start;
@synthesize end = _end;
@synthesize iSection = _iSection;
@synthesize isWholeDay = _isWholeDay;
enum {
    DateGroup =0,
    DatePickerGroup,
    GroupCount
};
enum {
    SaveEvent = 0
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bShart = YES;
        _tableView = nil;
        
        self.Start = [NSDate date];
        self.End = [NSDate date];
        _bInited = NO;
        _isWholeDay = NO;
        self.iSection = [NSIndexPath indexPathForRow:0 inSection:0];
        
    }
    return self;
}
-(void)dealloc
{
    self.Start = nil;
    self.End = nil;
    self.tableView = nil;
    self.datePickerYear = nil;
    self.datePickerDay = nil;
    self.iSection = nil;
    [super dealloc];
}

#pragma mark - Public function
-(void) popup:(UIViewController*)parent  delegate:(UIDrPalmDatePickerDelegate*)delegate
{
    if (nil != parent && parent != [self parentViewController])
    {
        [self close];
        _delegate = delegate;
        [[parent navigationController] pushViewController:self animated:YES];
        
    }
}

-(void) close
{   
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithIntRGB:255 green:253 blue:228 alpha:255];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    // 设置 navigation
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:TipSave, nil]];
//    [segmentedControl setMomentary:YES];
//    //[segmentedControl setEnabled:NO forSegmentAtIndex:SendEvent];
//    [segmentedControl setEnabled:NO forSegmentAtIndex:SaveEvent];
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [segmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
//    
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:segmentedControl] autorelease];
//    
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:TipCancel style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0, 0, 32, 32);
    saveButton.frame = frame;
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.contentMode = UIViewContentModeCenter;
    [saveButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:UIDrPalmDatePickerSaveButton]] forState:UIControlStateNormal];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    // table view
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    
    // 设置背景图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:UIDrPalmDatePickerBackground]]];
    imageView.frame = self.view.bounds;
    _tableView.backgroundView = imageView;
    [imageView release];
    
    // datepicker
    self.datePickerYear = [[[UIDatePicker alloc] init] autorelease];
    _datePickerYear.datePickerMode = UIDatePickerModeDate;
    [_datePickerYear addTarget:self action:@selector(datePickerYearChanged) forControlEvents:UIControlEventValueChanged];
    CGRect rect = CGRectMake(0, self.view.frame.size.height - 270, self.view.frame.size.width, 200);
    _datePickerYear.frame = rect;
    // init control with member
    [_datePickerYear setDate:_start];
    [self.view addSubview:_datePickerYear];
    
    self.datePickerDay = [[[UIDatePicker alloc] init] autorelease];
    [_datePickerDay addTarget:self action:@selector(datePickerDayChanged) forControlEvents:UIControlEventValueChanged];
    _datePickerDay.frame = rect;
    // init control with member
    [_datePickerDay setDate:_start];
    [self.view addSubview:_datePickerDay];
    
    if(_isWholeDay){
        [_datePickerDay setHidden:YES];
    }
    else{
        [_datePickerYear setHidden:YES];
    }
    
    //NSIndexPath* section = [NSIndexPath indexPathForRow:1 inSection:0];
    //[_tableView scrollToRowAtIndexPath:section atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //[_tableView reloadData];
    //NSIndexPath* section2 = [_tableView indexPathForSelectedRow];
//    NSIndexPath* section = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_tableView selectRowAtIndexPath:section animated:YES scrollPosition:UITableViewScrollPositionNone];

}
-(void)switchChanged:(id)sender
{
    if(YES == [_datePickerDay isHidden])
    {
        _isWholeDay = NO;
        [_datePickerDay setHidden:NO];
        [_datePickerYear setHidden:YES];
        if(YES == _bShart)
            [_datePickerDay setDate:_start];
        else
            [_datePickerDay setDate:_end];
    }
    else
    {
        _isWholeDay = YES;
        [_datePickerDay setHidden:YES];
        [_datePickerYear setHidden:NO]; 
        if(YES == _bShart)
            [_datePickerYear setDate:_start];
        else
            [_datePickerYear setDate:_end];
    }
    NSIndexPath* section = [_tableView indexPathForSelectedRow];
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:section animated:TRUE scrollPosition:UITableViewScrollPositionMiddle];
}
-(void)datePickerYearChanged
{
    if(YES == _bShart){
        NSTimeInterval ti = [self.end timeIntervalSinceDate:self.start];
        self.start = _datePickerYear.date;
        self.end = [self.start dateByAddingTimeInterval:ti];
    }
    else{
        self.End = _datePickerYear.date;
        if(NSOrderedAscending == [self.end compare:self.start]){
            // Change cell color
        }
    }
    NSIndexPath* section = [_tableView indexPathForSelectedRow];
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:section animated:TRUE scrollPosition:UITableViewScrollPositionMiddle];
}
-(void)datePickerDayChanged
{
    if(YES == _bShart){
        NSTimeInterval ti = [self.end timeIntervalSinceDate:self.start];
        self.start= _datePickerDay.date;
        self.End = [self.start dateByAddingTimeInterval:ti];
    }
    else{
        self.End = _datePickerDay.date;
        if(NSOrderedAscending == [self.end compare:self.start]){
            // Change cell color
        }
    }
    NSIndexPath* section = [_tableView indexPathForSelectedRow];
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:section animated:TRUE scrollPosition:UITableViewScrollPositionMiddle];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. 
    self.tableView = nil;
    self.datePickerYear = nil;
    self.datePickerDay = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#define TIMEINTERVAL_ONEDAY   24*60*60
#pragma mark - actions
- (void)saveAction:(id)sender {
    if(nil != _delegate)
    {
        //结束大于开始
        if(NSOrderedAscending == [self.end compare:self.start]){
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(DatePickerFailEndEarilyThanStart, nil) delegate:nil cancelButtonTitle:NSLocalizedString(DatePickerOK, nil) otherButtonTitles:nil] autorelease];
            [alertView show];
            return;
        }
        //结束比当前时间大一天
        if([self.end timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970] < TIMEINTERVAL_ONEDAY)
        {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(DatePickerFailEndTooLate, nil) delegate:nil cancelButtonTitle:NSLocalizedString(DatePickerOK, nil) otherButtonTitles:nil] autorelease];
            [alertView show];
            return;
        }
        if(_isWholeDay){
            NSDateComponents *comoponents;
            NSUInteger componentFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth| kCFCalendarUnitDay
            |kCFCalendarUnitHour|kCFCalendarUnitMinute;
            comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:_start];
            [comoponents setHour:0];
            [comoponents setMinute:0];
            self.Start = [[NSCalendar currentCalendar] dateFromComponents:comoponents];
            comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:_end];
            [comoponents setHour:23];
            [comoponents setMinute:59];
            self.End = [[NSCalendar currentCalendar] dateFromComponents:comoponents];
            
        }
        [_delegate getStartAndEndDate:_start endDate:_end wholeDay:_isWholeDay];
        [self close];
    }

}
- (void)segmentedAction:(id)sender
{
    switch ([sender selectedSegmentIndex])
    {
        case SaveEvent:{
           if(nil != _delegate)
           {
               if(NSOrderedAscending == [self.end compare:self.start]){
                   UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(DatePickerFailEndEarilyThanStart, nil) delegate:nil cancelButtonTitle:NSLocalizedString(DatePickerOK, nil) otherButtonTitles:nil] autorelease];
                   [alertView show];
                   return;
               }
               if(_isWholeDay){
                   NSDateComponents *comoponents;
                   NSUInteger componentFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth| kCFCalendarUnitDay
                   |kCFCalendarUnitHour|kCFCalendarUnitMinute;
                   comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:_start];
                   [comoponents setHour:0];
                   [comoponents setMinute:0];
                   self.Start = [[NSCalendar currentCalendar] dateFromComponents:comoponents];
                   comoponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:_end];
                   [comoponents setHour:23];
                   [comoponents setMinute:59];
                   self.End = [[NSCalendar currentCalendar] dateFromComponents:comoponents];
                
               }
               [_delegate getStartAndEndDate:_start endDate:_end wholeDay:_isWholeDay];
               [self close];
           }
        }break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - UITableViewDataSource
// draw section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch(section)
    {
        case DateGroup:{
            count = 3;
        }break;
    }
    return count;
}
// draw item in section
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
   
    if (DateGroup == indexPath.section){
        NSString *CellIdentifier = @"UITVDateCell";
        UITableViewCell *dateCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == dateCell){
            dateCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        if (0 == indexPath.row){
            dateCell.textLabel.text = NSLocalizedString(DatePickerStart, nil);
            dateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if(YES == [_datePickerDay isHidden])
                dateCell.detailTextLabel.text = [self.start toStringYMD];
            else
                dateCell.detailTextLabel.text = [self.start toStringYMDHM];
           
            cell = dateCell;
            
            [_tableView selectRowAtIndexPath:_iSection animated:TRUE scrollPosition:UITableViewScrollPositionMiddle];
            
        }
        else if (1 == indexPath.row){
            dateCell.textLabel.text = NSLocalizedString(DatePickerEnd, nil);
            if(YES == [_datePickerDay isHidden])
                dateCell.detailTextLabel.text = [self.end toStringYMD];
            else
                dateCell.detailTextLabel.text = [self.end toStringYMDHM];
            dateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell = dateCell;
        }
        else if(2 == indexPath.row){
            if(_wholeDaySwitch == nil)
            {
                NSInteger width = 40;
                _wholeDaySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, width, tableView.frame.size.height - 10)];
                _wholeDaySwitch.center = CGPointMake(tableView.frame.size.width - width, tableView.frame.size.height/2);
                dateCell.accessoryView = _wholeDaySwitch;
            }
            _wholeDaySwitch.on = _isWholeDay;
            [_wholeDaySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            dateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dateCell.textLabel.text = NSLocalizedString(DatePickerTimeSelectDay, nil);
            cell = dateCell;
          
//            UITVNewEventSwitchCell *switchCell = [UITVNewEventSwitchCell getUITVSwitchViewCell:tableView cellIdentifier:@"UITVSwitchCell"];
//            switchCell.label.text = TimeSelectDay;
//            [switchCell.switchView addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
//            switchCell.switchView.on = _isWholeDay;
//            cell = switchCell;
        }
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return GroupCount;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
     if (DateGroup == indexPath.section){
        // 选时间
        if (0 == indexPath.row){
            // 开始
            {
                _bShart = YES;
                [_datePickerYear setDate:_start];
                [_datePickerDay setDate:_start];
            }
            //
        }
        else if (1 == indexPath.row){
            // 结束
             _bShart = NO;
            [_datePickerYear setDate:_end];
            [_datePickerDay setDate:_end];
        }
        else if (2 == indexPath.row){
            [_tableView selectRowAtIndexPath:_iSection animated:TRUE scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    self.iSection = [_tableView indexPathForSelectedRow];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CGFloat height = 40;
    
    if (DateGroup == indexPath.section){
        return [UIDateCell cellHeight];
    }
    return height;
}

@end
