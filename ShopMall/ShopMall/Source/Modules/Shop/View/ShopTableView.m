//
//  ShopTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-26.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopTableView.h"
#import "ShopTableViewCell.h"
#import "CenteralTextTableViewCell.h"

@interface ShopTableView() <RequestImageViewDelegate> {
    
}
@end

@implementation ShopTableView
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
    self.canDeleteItem = NO;
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
            if(self.items.count > 0) {
                self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                number = self.items.count;
                if(self.hasMore) {
                    // 需要显示更多按钮
                    number += 1;
                }
                self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            else {
                self.separatorStyle = UITableViewCellSeparatorStyleNone;
                number = 0;
            }
        }
        default:break;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    if (indexPath.row < self.items.count) {
        height = [ShopTableViewCell cellHeight];
    }
    else {
        height = [CenteralTextTableViewCell cellHeight];
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if (indexPath.row < self.items.count) {
        ShopTableViewCell *cell = [ShopTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        // 数据填充
        Shop *shop = [self.items objectAtIndex:indexPath.row];
        cell.requestImageView.imageUrl = shop.logo.path;
        cell.requestImageView.imageData = shop.logo.data;
        cell.requestImageView.contentType = shop.logo.contentType;
        cell.requestImageView.delegate = self;
        [cell.requestImageView loadImage];
        
        cell.titleLabel.text = shop.shopName;
        
        if([shop.isPromo boolValue]) {
            // 优惠券
            cell.imageCardView.hidden = NO;
        }
        if([shop.isGift boolValue]) {
            // 赠送
            cell.imageGiftView.hidden = NO;
        }
        if([shop.isDiscount boolValue]) {
            // 打折
            cell.imageDiscView.hidden = NO;
        }
                
        cell.kkRankSelector.curRank = [shop.score integerValue] / RankOfScore;
        cell.avgLabel.text = [NSString stringWithFormat:@"人均:¥ %@", shop.priceAvg];
        cell.addressLabel.text = shop.address;
        cell.catLabel.text = shop.category.categoryName;
        cell.disLabel.text = [SignInManagerInstance() getDistance:[shop.lat doubleValue] lon:[shop.lon doubleValue]];

    }
    else {
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        result = cell;
        cell.titleLabel.text = @"加载更多";
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.items.count) {
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShop:)]) {
            [self.tableViewDelegate tableView:self didSelectShop:[self.items objectAtIndex:indexPath.row]];
        }
    }
    else {
        if([self.tableViewDelegate respondsToSelector:@selector(didSelectMore:)]) {
            [self.tableViewDelegate didSelectMore:self];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.canDeleteItem)
        return UITableViewCellEditingStyleDelete;
    else {
        return UITableViewCellEditingStyleNone;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete: {
            if (indexPath.row < self.items.count) {
                if([self.tableViewDelegate respondsToSelector:@selector(tableView:willDeleteShop:)]) {
                    [self.tableViewDelegate tableView:self willDeleteShop:[self.items objectAtIndex:indexPath.row]];
                }
            }
            break;
        }
        default:
            break;
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
