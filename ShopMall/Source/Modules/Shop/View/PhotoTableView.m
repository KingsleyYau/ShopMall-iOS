//
//  PhotoTableView.h
//  YiCoupon
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "PhotoTableView.h"
#import "CommonAlbumTableViewCell.h"
#import "CenteralTextTableViewCell.h"

@implementation PhotoTableView
@synthesize tableViewDelegate;
@synthesize items;
- (void)initialize {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.hasMore = NO;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}
#pragma mark - 界面事件
- (UITableViewCell *)cellForSubView:(UIView *)view {
    // TODO:获取子控件所在单元格
    UITableViewCell *cell = nil;
    CGRect rect = [view convertRect:view.bounds toView:[[UIApplication sharedApplication] keyWindow]];
    for (UITableViewCell *subCell in [self visibleCells]) {
        CGRect subRect = [subCell convertRect:subCell.bounds toView:[[UIApplication sharedApplication] keyWindow]];
        if (CGRectIntersectsRect(rect, subRect)) {
            cell = subCell;
            break;
        }
    }
    return cell;
}
- (UIView *)viewForIndexPath:(NSIndexPath *)indexPath {
    // TODO:获单元格详细界面
    UIView *view = nil;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    view.backgroundColor = [UIColor grayColor];
    return view;
}
#pragma mark - 列表界面回调 (UITableViewDataSource / UITableViewDelegate)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = self.items.count;
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch(section) {
        case 0: {
            if(self.items.count > 0) {
                self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                number = (self.items.count + 1) / 2;
                if(self.hasMore) {
                    // 需要显示更多按钮
                    number += 1;
                }
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
    CGFloat height = 0;
    if (indexPath.row < (self.items.count + 1) / 2) {
        height = [CommonAlbumTableViewCell cellHeight];
    }
    else {
        height = [CenteralTextTableViewCell cellHeight];
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if (indexPath.row < (self.items.count + 1) / 2) {
        CommonAlbumTableViewCell *cell = [CommonAlbumTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        // TODO:数据填充
        ShopImage *item1 = (ShopImage *)[self.items objectAtIndex:(2 * indexPath.row)];
  
//        cell.titleLabel1.text = item1.imgName;
        
        cell.requestImageView1.imageUrl = item1.thumFile.path;
        cell.requestImageView1.imageData = item1.thumFile.data;
        cell.requestImageView1.contentType = item1.thumFile.contentType;
        cell.requestImageView1.delegate = self;
        cell.requestImageView1.tag = 2 * indexPath.row;
        [cell.requestImageView1 loadImage];
        
        if((2 * indexPath.row) + 1 < self.items.count) {
            cell.containView2.hidden = NO;
            
            ShopImage *item2 = (ShopImage *)[self.items objectAtIndex:(2 * indexPath.row) + 1];
            cell.titleLabel2.text = item2.imgName;

            cell.requestImageView2.imageUrl = item2.thumFile.path;
            cell.requestImageView2.imageData = item2.thumFile.data;
            cell.requestImageView2.contentType = item2.thumFile.contentType;
            cell.requestImageView2.delegate = self;
            cell.requestImageView2.tag = 2 * indexPath.row + 1;
            [cell.requestImageView2 loadImage];
        }
        else {
            cell.containView2.hidden = YES;
        }
    }
    else {
        // 更多
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        result = cell;
        cell.titleLabel.text = @"加载更多";
    }
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < (self.items.count + 1) / 2) {
    }
    else {
        if([self.tableViewDelegate respondsToSelector:@selector(didSelectMore:)]) {
            [self.tableViewDelegate didSelectMore:self];
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
#pragma mark - (异步下载图片控件回调)
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
- (void)photoViewDidSingleTap:(RequestImageView *)imageView {
    if(imageView.tag < self.items.count) {
        ShopImage *item = (ShopImage *)[self.items objectAtIndex:imageView.tag];
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShopImage:)]) {
            [self.tableViewDelegate tableView:self didSelectShopImage:item];
        }
    }
}
@end
