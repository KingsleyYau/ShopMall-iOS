//
//  CreditTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-2.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CreditTableView.h"
#import "CreditImageTableViewCell.h"

@interface CreditTableView () <RequestImageViewDelegate> {
    
}
@end
@implementation CreditTableView
@synthesize tableViewDelegate;
@synthesize credit;
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
        height = [CreditImageTableViewCell cellHeight];
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if (indexPath.row < self.items.count) {

        CreditImageTableViewCell *cell = [CreditImageTableViewCell getUITableViewCell:tableView];
        
        Credit *item = [self.items objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.creditName;
        cell.titleLabel.textColor = [UIColor blackColor];
        
        cell.requestImageView.imageUrl = item.logo.path;
        cell.requestImageView.imageData = item.logo.data;
        cell.requestImageView.contentType = item.logo.contentType;
        cell.requestImageView.delegate = self;
        [cell.requestImageView loadImage];
        
        if([item.creditID integerValue] == [self.credit.creditID integerValue]) {
//           [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            cell.titleLabel.textColor = [UIColor redColor];
        }
        result = cell;
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.credit = [self.items objectAtIndex:indexPath.row];
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectCredit:)]) {
        [self.tableViewDelegate tableView:self didSelectCredit:[self.items objectAtIndex:indexPath.row]];
    }
    [self reloadData];
}
#pragma mark - 按钮事件
- (void)itemAction:(id)sender {
    NSInteger index = ((UIButton *)sender).tag;
    self.credit = [self.items objectAtIndex:index];
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectCredit:)]) {
        [self.tableViewDelegate tableView:self didSelectCredit:[self.items objectAtIndex:index]];
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
