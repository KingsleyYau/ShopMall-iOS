//
//  CityTableView.m
//  ShopMall
//
//  Created by KingsleyYau on 13-4-30.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "CityTableView.h"
#import "CenteralTextTableViewCell.h"

@interface CityTableView (){
    
}

@property (nonatomic, retain) CityRegion *curRegion;
@property (nonatomic, retain) NSArray *cities;
@property (nonatomic, retain) City *curCity;
@end

@implementation CityTableView
@synthesize tableViewDelegate;
@synthesize cityRegions;
@synthesize curRegion;
@synthesize cities;
@synthesize curCity;
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
    self.cityRegions = [ShopDataManager cityRegionList];
    if(!self.curRegion && self.cityRegions.count > 0) {
        self.curRegion = [self.cityRegions objectAtIndex:0];
    }
    if(self.curRegion) {
        self.cities = [ShopDataManager cityListByRegion:self.curRegion.cityRegionName];
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
        number = self.cityRegions.count;
    }
    else if(_categorySub == tableView){
        number = self.cities.count ;
    }
	return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ITEM_HEIGHT;
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result = nil;
    if(_categoryParent == tableView) {
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.titleLabel.textColor = [UIColor blackColor];

        CityRegion *item = [self.cityRegions objectAtIndex:indexPath.row];

        item = [self.cityRegions objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.cityRegionName;
            
        if([item.cityRegionName isEqualToString:self.curRegion.cityRegionName]) {
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ShopCategoryListCellSelectedBackground ofType:@"png" inDirectory:nil]];
            [((UIImageView*)cell.backgroundView) setImage:image];
            cell.titleLabel.textColor = [UIColor redColor];
        }
        result = cell;
    }
    else if(_categorySub == tableView){
        CenteralTextTableViewCell *cell = [CenteralTextTableViewCell getUITableViewCell:tableView];
        result = cell;
        
        cell.titleLabel.textColor = [UIColor blackColor];

        City *item = [self.cities objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.cityName;
//        if([item.cityName isEqualToString:self.curCity.cityName]) {
//            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            result.textLabel.textColor = [UIColor redColor];
//        }
    }
    
    return result;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_categoryParent == tableView) {
        // 点击父分类
        self.curRegion = [self.cityRegions objectAtIndex:indexPath.row];
        self.cities = [ShopDataManager cityListByRegion:self.curRegion.cityRegionName];
        if(self.cities.count > 0) {
            self.curCity = [self.cities objectAtIndex:0];
        }
        // 回调界面选择
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectCityRegion:)]) {
            [self.tableViewDelegate tableView:self didSelectCityRegion:self.curRegion];
        }
        // 刷新子分类
        [_categorySub reloadData];
        [_categoryParent reloadData];
    }
    else if(_categorySub == tableView){
        // 点击子分类
        self.curCity = [self.cities objectAtIndex:indexPath.row];
        // 回调界面选择
        if([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectCity:)]) {
            [self.tableViewDelegate tableView:self didSelectCity:self.curCity];
        }
        [_categorySub reloadData];
    }
}
@end
