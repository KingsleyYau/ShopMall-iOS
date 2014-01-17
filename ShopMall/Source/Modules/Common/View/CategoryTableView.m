//
//  CategoryTableView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-2.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CategoryTableView.h"
#import "CenteralTextTableViewCell.h"

@interface CategoryTableView () <RequestImageViewDelegate>{
    
}

@property (nonatomic, retain) ShopCategory *curParent;
@property (nonatomic, retain) NSArray *itemsSub;
@property (nonatomic, retain) ShopCategory *curSub;
@end

@implementation CategoryTableView
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
    if(!_categoryParent) {
        _categoryParent = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height)];
        [self addSubview:_categoryParent];
        _categoryParent.delegate = self;
        _categoryParent.dataSource = self;
        _categoryParent.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _categoryParent.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categoryParent.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categoryParent.separatorColor = [UIColor grayColor];
        _categoryParent.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.8 alpha:1];
        _categoryParent.showsVerticalScrollIndicator = NO;
    }

    if(!_categorySub) {
        _categorySub = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height)];
        [self addSubview:_categorySub];
        _categorySub.delegate = self;
        _categorySub.dataSource = self;
        _categorySub.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _categoryParent.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categorySub.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categorySub.separatorColor = [UIColor grayColor];
        _categorySub.backgroundColor = [UIColor whiteColor];
        _categorySub.showsVerticalScrollIndicator = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}
- (void)reloadData {
    self.curParent = nil;
    self.curSub = nil;
    // 界面传入的分类
    if(self.category) {
        if([self.category.categoryID intValue] == TopCategoryID) {
            // 全部
            self.curParent = self.category;
            self.itemsSub = nil;
        }
        else if([self.category.categoryParent.categoryID integerValue] == TopCategoryID) {
            // 顶层分类
            self.curParent = self.category;
            self.itemsSub = [ShopDataManager categoryListWithParent:self.curParent.categoryID];
        }
        else {
            // 子分类
            self.curSub = self.category;
            self.curParent = self.curSub.categoryParent;
            self.itemsSub = [ShopDataManager categoryListWithParent:self.curParent.categoryID];
        }
    }
    
    [_categoryParent reloadData];
    [_categorySub reloadData];
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
    if(_categoryParent == tableView) {
        number = self.itemsParent.count + 1;
    }
    else if(_categorySub == tableView){
        if([self.curParent.categoryID integerValue] != TopCategoryID) {
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
    ShopCategory *item;
    if(_categoryParent == tableView) {
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.titleLabel.textColor = [UIColor blackColor];
        if(indexPath.row == 0) {
            // 全部分类
            item = [ShopDataManager topCategory];
            cell.titleLabel.text = item.categoryName;
            if([item.categoryID integerValue] == [self.curParent.categoryID integerValue]) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategoryListCellSelectedBackground ofType:@"png" inDirectory:nil]];
                [cell.backgroundImageView setImage:image];
                cell.titleLabel.textColor = [UIColor redColor];
            }
        }
        else if(indexPath.row > 0){
            // 一级分类
            item = [self.itemsParent objectAtIndex:indexPath.row - 1];
            cell.titleLabel.text = item.categoryName;
            if([item.categoryID integerValue] == [self.curParent.categoryID integerValue]) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategoryListCellSelectedBackground ofType:@"png" inDirectory:nil]];
                [cell.backgroundImageView setImage:image];
                cell.titleLabel.textColor = [UIColor redColor];
            }
        }
        result = cell;
    }
    else if(_categorySub == tableView){
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;

        cell.titleLabel.textColor = [UIColor blackColor];
        
        if(indexPath.row == 0) {
            NSString *title = [NSString stringWithFormat:@"全部%@", self.curParent.categoryName];
            cell.titleLabel.text = title;
//            cell.titleLabel.textColor = [UIColor redColor];
        }
        else if(indexPath.row > 0) {
            item = [self.itemsSub objectAtIndex:indexPath.row - 1];
            cell.titleLabel.text = item.categoryName;
            if([item.categoryID integerValue] == [self.curSub.categoryID integerValue]) {
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                cell.titleLabel.textColor = [UIColor redColor];
            }
        }
    }

    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopCategory *item;
    if(_categoryParent == tableView) {
        // 点击父分类
        if(indexPath.row == 0) {
            self.curParent = [ShopDataManager topCategory];
            self.itemsSub = nil;
            // 回调界面选择
            if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShopCategory:)]) {
                [self.tableViewDelegate tableView:self didSelectShopCategory:self.curParent];
            }
            [_categorySub reloadData];
        }
        else if(indexPath.row > 0) {
            item = [self.itemsParent objectAtIndex:indexPath.row - 1];
            self.curParent = item;
            self.itemsSub = [ShopDataManager categoryListWithParent:item.categoryID];
            // 回调界面选择
            if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShopParentCategory:)]) {
                [self.tableViewDelegate tableView:self didSelectShopParentCategory:self.curParent];
            }
            // 刷新子分类
            [_categorySub reloadData];
        }
        [_categoryParent reloadData];
    }
    else if(_categorySub == tableView){
        // 点击子分类
        if(indexPath.row == 0) {
            // 回调界面选择
            if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShopCategory:)]) {
                [self.tableViewDelegate tableView:self didSelectShopCategory:self.curParent];
            }
        }
        else if(indexPath.row > 0) {
            item = [self.itemsSub objectAtIndex:indexPath.row - 1];
            // 回调界面选择
            if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectShopCategory:)]) {
                [self.tableViewDelegate tableView:self didSelectShopCategory:item];
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
