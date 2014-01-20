//
//  ShopPersonalNewsTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "ShopPersonalNewsTableView.h"
#import "CommonListTableViewCell.h"
#import "CommonListTextTableViewCell.h"
#import "CenteralTextTableViewCell.h"

#import "ShopDataManager.h"
@interface ShopPersonalNewsTableView () <RequestImageViewDelegate> {
    
}
@end

@implementation ShopPersonalNewsTableView
@synthesize tableViewDelegate;
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
    self.separatorColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.hasMore = NO;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    CGFloat height = 0;
//    if([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
//        height = [self.tableViewDelegate tableView:self heightForHeaderInSection:section];
//    }
//    return height;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = nil;
//    if([self.tableViewDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
//        view = [self.tableViewDelegate tableView:self viewForHeaderInSection:section];
//    }
//    return view;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 1;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch(section) {
        case 0: {
            if(self.items.count > 0) {
                number = self.items.count;
                if(self.hasMore) {
                    // 需要显示更多按钮
                    number += 1;
                }
                self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            else {
                number = 0;
                self.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }
        default:break;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    if (indexPath.row < self.items.count) {
        height = [CommonListTableViewCell cellHeight];
    }
    else {
        height = [CenteralTextTableViewCell cellHeight];
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if (indexPath.row < self.items.count) {
        CommonListTableViewCell *cell = [CommonListTableViewCell getUITableViewCell:tableView];
        
        // 数据填充
        ShopNews *shopNews = [self.items objectAtIndex:indexPath.row];

        cell.requestImageView.imageUrl = shopNews.detailPhoto.path;
        cell.requestImageView.imageData = shopNews.detailPhoto.data;
        cell.requestImageView.contentType = shopNews.detailPhoto.contentType;
        cell.requestImageView.delegate = self;
        [cell.requestImageView loadImage];
        
        cell.titleLabel.text = shopNews.shop.shopName;
        cell.subLabel.text = shopNews.infoTitle;
        cell.subLabel2.text = [NSString stringWithFormat:@"有效期:%@至%@", [shopNews.infoBeginDate toStringYMD], [shopNews.infoEndDate toStringYMD]];//[NSString stringWithFormat:@"已下载%d次", 0];
        
        result = cell;
    }
    else {
        // 更多
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        cell.titleLabel.text = @"更多";
        result = cell;
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    //self.itemSelected = [self.items objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.items.count) {
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShopPersonalNews:)]) {
            [self.tableViewDelegate tableView:self didSelectShopPersonalNews:[self.items objectAtIndex:indexPath.row]];
        }
    }
    else {
        if([self.tableViewDelegate respondsToSelector:@selector(didSelectMore:)]) {
            [self.tableViewDelegate didSelectMore:self];
        }
    }
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
#pragma mark - 滚动界面回调 (UIScrollViewDelegate)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.tableViewDelegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.tableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
@end