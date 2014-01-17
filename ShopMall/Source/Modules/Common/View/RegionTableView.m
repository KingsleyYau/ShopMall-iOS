//
//  RegionTableView.m
//  ShopMall
//
//  Created by KingsleyYau on 13-3-27.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "RegionTableView.h"
#import "CenteralTextTableViewCell.h"
@interface RegionTableView () {
    
}

@property (nonatomic, retain) Region *curParent;
@property (nonatomic, retain) NSArray *itemsSub;
@property (nonatomic, retain) Region *curSub;
@end

@implementation RegionTableView
@synthesize tableViewDelegate;
@synthesize itemsParent;
@synthesize itemsSub;
@synthesize curParent;
@synthesize curSub;
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
    // Initialization code
    _regionParent = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height)];
    [self addSubview:_regionParent];
    _regionParent.delegate = self;
    _regionParent.dataSource = self;
    _regionParent.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _regionParent.separatorStyle = UITableViewCellSeparatorStyleNone;
    _regionParent.separatorColor = [UIColor grayColor];
    _regionParent.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.8 alpha:1];
    _regionParent.showsVerticalScrollIndicator = NO;
    
    
    _regionSub = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height)];
    [self addSubview:_regionSub];
    _regionSub.delegate = self;
    _regionSub.dataSource = self;
    _regionSub.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _regionSub.separatorStyle = UITableViewCellSeparatorStyleNone;
    _regionSub.separatorColor = [UIColor grayColor];
    _regionSub.backgroundColor = [UIColor whiteColor];
    _regionSub.showsVerticalScrollIndicator = YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}
- (void)reloadData {
    self.curParent = nil;
    self.curSub = nil;
    // 界面传入的分类
    if(self.region) {
        if([self.region.regionID intValue] == TopRegionID) {
            // 全部
            self.curParent = self.region;
            self.itemsSub = nil;
        }
        else if([self.region.parent.regionID integerValue] == TopRegionID) {
            // 顶层分类
            self.curParent = self.region;
            self.itemsSub = [ShopDataManager regionListWithParent:self.curParent.regionID];
        }
        else {
            // 子分类
            self.curSub = self.region;
            self.curParent = self.curSub.parent;
            self.itemsSub = [ShopDataManager regionListWithParent:self.curParent.regionID];
        }
    }
    
    [_regionParent reloadData];
    [_regionSub reloadData];
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
    if(_regionParent == tableView) {
        number = self.itemsParent.count + 1;
    }
    else if(_regionSub == tableView){
        if([self.curParent.regionID integerValue] != TopRegionID) {
            number = self.itemsSub.count + 1;
        }
        else {
            number = 0;
        }
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ITEM_HEIGHT;
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;

    Region *item;
    if(_regionParent == tableView) {
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.titleLabel.textColor = [UIColor blackColor];
        
        if(indexPath.row == 0) {
            // 全部分类
            item = [ShopDataManager topRegion];
            cell.titleLabel.text = item.regionName;
            if([item.regionID integerValue] == [self.curParent.regionID integerValue]) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategoryListCellSelectedBackground ofType:@"png" inDirectory:nil]];
                [cell.backgroundImageView setImage:image];
                cell.titleLabel.textColor = [UIColor redColor];
            }
        }
        else if(indexPath.row > 0){
            // 一级分类
            item = [self.itemsParent objectAtIndex:indexPath.row - 1];
            cell.titleLabel.text = item.regionName;
            if([item.regionID integerValue] == [self.curParent.regionID integerValue]) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategoryListCellSelectedBackground ofType:@"png" inDirectory:nil]];
                [cell.backgroundImageView setImage:image];
                cell.titleLabel.textColor = [UIColor redColor];
            }
        }
        result = cell;
    }
    else if(_regionSub == tableView){
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        result = cell;

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.titleLabel.textColor = [UIColor blackColor];
        
        if(indexPath.row == 0) {
            NSString *title = [NSString stringWithFormat:@"全部%@", self.curParent.regionName];
            cell.titleLabel.text = title;
//            cell.titleLabel.textColor = [UIColor redColor];
        }
        else if(indexPath.row > 0) {
            item = [self.itemsSub objectAtIndex:indexPath.row - 1];
            cell.titleLabel.text = item.regionName;
            if([item.regionID integerValue] == [self.curSub.regionID integerValue]) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                cell.titleLabel.textColor = [UIColor redColor];
            }
        }
    }
    
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Region *item;
    if(_regionParent == tableView) {
        // 点击父分类
        if(indexPath.row == 0) {
            self.curParent = [ShopDataManager topRegion];
            self.itemsSub = nil;
            // 回调界面选择
            if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRegion:)]) {
                [self.tableViewDelegate tableView:self didSelectRegion:self.curParent];
            }
            [_regionSub reloadData];
        }
        else if(indexPath.row > 0) {
            item = [self.itemsParent objectAtIndex:indexPath.row - 1];
            self.curParent = item;
            self.itemsSub = [ShopDataManager regionListWithParent:item.regionID];
            // 回调界面选择
            if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectParentRegion:)]) {
                [self.tableViewDelegate tableView:self didSelectParentRegion:self.curParent];
            }
            // 刷新子分类
            [_regionSub reloadData];
        }
        [_regionParent reloadData];
    }
    else if(_regionSub == tableView){
        // 点击子分类
        if(indexPath.row == 0) {
            // 回调界面选择
            if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRegion:)]) {
                [self.tableViewDelegate tableView:self didSelectRegion:self.curParent];
            }
        }
        else if(indexPath.row > 0) {
            item = [self.itemsSub objectAtIndex:indexPath.row - 1];
            // 回调界面选择
            if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRegion:)]) {
                [self.tableViewDelegate tableView:self didSelectRegion:item];
            }
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


@end
