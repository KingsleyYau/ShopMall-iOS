//
//  CitySearchTableView.m
//  ShopMall
//
//  Created by KingsleyYau on 13-3-26.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CitySearchTableView.h"

@implementation CitySearchTableView
@synthesize tableViewDelegate;
@synthesize items;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor grayColor];
        self.backgroundColor = [UIColor whiteColor];
        self.alwaysBounceVertical = YES;
    }
    return self;
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 1;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch(section) {
        case 0: {
            number = self.items.count;
        }
        default:break;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    if (indexPath.row < self.items.count) {
        height = 44;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    static NSString *cellIdentifier = @"CitySearchTableViewCell";
    if (indexPath.row < self.items.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        City *city = [self.items objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityName;
        cell.textLabel.font = [UIFont systemFontOfSize:18];

        result = cell;
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectSearchCity:)]) {
        [self.tableViewDelegate tableView:self didSelectSearchCity:[self.items objectAtIndex:indexPath.row]];
    }
    [self deselectRowAtIndexPath:indexPath animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
