//
//  ShopNewsTypesTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-9.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewsTypesTableView.h"
#import "CenteralTextTableViewCell.h"

#import "ShopDataManager.h"
@interface ShopNewsTypesTableView() <RequestImageViewDelegate> {
    
}
@end

@implementation ShopNewsTypesTableView
@synthesize tableViewDelegate;
@synthesize items;
@synthesize type;
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
        height = [CenteralTextTableViewCell cellHeight];
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if (indexPath.row < self.items.count) {
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        result = cell;
        ShopNewsType *item = [self.items objectAtIndex:indexPath.row];
        NSString *titleString = [NSString stringWithFormat:@"%@", item.shopNewsTypeName];
        cell.titleLabel.text = titleString;
        cell.titleLabel.textColor = [UIColor blackColor];
        
        if([item.shopNewsTypeID integerValue] == [self.type.shopNewsTypeID integerValue]) {
//            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            cell.titleLabel.textColor = [UIColor redColor];
        }
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    self.type = [self.items objectAtIndex:indexPath.row];
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShopNewsType:)]) {
        [self.tableViewDelegate tableView:self didSelectShopNewsType:[self.items objectAtIndex:indexPath.row]];
    }
    [self reloadData];
}
#pragma mark - 按钮事件
- (void)itemAction:(id)sender {
    NSInteger index = ((UIButton *)sender).tag;
    self.type = [self.items objectAtIndex:index];
    if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShopNewsType:)]) {
        [self.tableViewDelegate tableView:self didSelectShopNewsType:[self.items objectAtIndex:index]];
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
