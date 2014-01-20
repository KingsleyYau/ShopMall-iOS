//
//  SortTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-1.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "SortTableView.h"
#import "CenteralTextTableViewCell.h"

@implementation SortTableView
@synthesize tableViewDelegate;
@synthesize sort;
@synthesize items;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
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
        height = ITEM_HEIGHT;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if (indexPath.row < self.items.count) {
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        ShopSortType *type = [self.items objectAtIndex:indexPath.row];
        NSString *titleString = [NSString stringWithFormat:@"%@", type.sortName];
        cell.titleLabel.text = titleString;
        cell.titleLabel.textColor = [UIColor blackColor];
        
        if([type.sortID integerValue] == [self.sort.sortID integerValue]) {
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            cell.titleLabel.textColor = [UIColor redColor];
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.sort = [self.items objectAtIndex:indexPath.row];
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectSort:)]) {
        [self.tableViewDelegate tableView:self didSelectSort:self.sort];
    }
    [self reloadData];
}
#pragma mark - 缩略图界面回调 (RequestImageViewDelegate)
- (void)imageViewDidDisplayImage:(RequestImageView *)imageView {
    File *file = [ShopDataManager fileWithUrl:imageView.imageUrl isLocal:NO];
    if(file) {
        file.data = imageView.imageData;
        file.contentType = imageView.contentType;
        [CoreDataManager saveData];
        if ([self.tableViewDelegate respondsToSelector:@selector(needReloadData:)]) {
            [self.tableViewDelegate needReloadData:self];
        }
    }
}

@end
