//
//  CitySearchTableView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-3-26.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CitySearchTableView;
@class City;
@protocol CitySearchTableViewDelegate <NSObject>
@optional
- (void)needReloadData:(CitySearchTableView *)tableView;
- (void)tableView:(CitySearchTableView *)tableView didSelectSearchCity:(City *)item;
@end

@interface CitySearchTableView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, weak) IBOutlet id <CitySearchTableViewDelegate> tableViewDelegate;
@property (nonatomic, retain) NSArray *items;
@end
