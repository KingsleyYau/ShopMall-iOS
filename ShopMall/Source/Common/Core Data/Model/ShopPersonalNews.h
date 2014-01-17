//
//  ShopPersonalNews.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-9.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Credit, File, Region, Shop, ShopCategory, ShopNewsPhoto, ShopNewsRank, ShopNewsType, User;

@interface ShopPersonalNews : NSManagedObject

@property (nonatomic, retain) NSDate * beginDate;
@property (nonatomic, retain) NSString * buyTips;
@property (nonatomic, retain) NSDate * cancelDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * getDate;
@property (nonatomic, retain) NSNumber * getType;
@property (nonatomic, retain) NSNumber * hassms;
@property (nonatomic, retain) NSDate * infoBeginDate;
@property (nonatomic, retain) NSString * infoDes;
@property (nonatomic, retain) NSDate * infoEndDate;
@property (nonatomic, retain) NSString * infoTitle;
@property (nonatomic, retain) NSNumber * myInfoID;
@property (nonatomic, retain) NSNumber * shopNewsID;
@property (nonatomic, retain) NSString * showTips;
@property (nonatomic, retain) NSNumber * showType;
@property (nonatomic, retain) NSString * smsinfo;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * useDate;
@property (nonatomic, retain) NSString * vericode;
@property (nonatomic, retain) NSSet *branch;
@property (nonatomic, retain) ShopCategory *category;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) NSSet *credit;
@property (nonatomic, retain) File *detailPhoto;
@property (nonatomic, retain) File *logo;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) Shop *shop;
@property (nonatomic, retain) ShopNewsPhoto *shopNewsPhoto;
@property (nonatomic, retain) NSSet *shopNewsRank;
@property (nonatomic, retain) ShopNewsType *shopNewsType;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) File *buyPhoto;
@end

@interface ShopPersonalNews (CoreDataGeneratedAccessors)

- (void)addBranchObject:(Shop *)value;
- (void)removeBranchObject:(Shop *)value;
- (void)addBranch:(NSSet *)values;
- (void)removeBranch:(NSSet *)values;
- (void)addCreditObject:(Credit *)value;
- (void)removeCreditObject:(Credit *)value;
- (void)addCredit:(NSSet *)values;
- (void)removeCredit:(NSSet *)values;
- (void)addShopNewsRankObject:(ShopNewsRank *)value;
- (void)removeShopNewsRankObject:(ShopNewsRank *)value;
- (void)addShopNewsRank:(NSSet *)values;
- (void)removeShopNewsRank:(NSSet *)values;
@end
