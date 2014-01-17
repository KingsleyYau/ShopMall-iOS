//
//  File.h
//  ShopMall
//
//  Created by KingsleyYau on 13-7-23.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Credit, Custom, Product, Rank, Shop, ShopCategory, ShopImage, ShopNews, ShopNewsPhoto, ShopNewsRank, ShopNewsType, Sign, User;

@interface File : NSManagedObject

@property (nonatomic, retain) NSString * contentType;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * pathType;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSSet *category;
@property (nonatomic, retain) NSSet *credit;
@property (nonatomic, retain) NSSet *custom;
@property (nonatomic, retain) NSSet *fullFile;
@property (nonatomic, retain) NSSet *product;
@property (nonatomic, retain) NSSet *rank;
@property (nonatomic, retain) NSSet *shop;
@property (nonatomic, retain) NSSet *shopNews;
@property (nonatomic, retain) NSSet *shopNewsDetail;
@property (nonatomic, retain) NSSet *shopNewsPhoto;
@property (nonatomic, retain) NSSet *shopNewsRank;
@property (nonatomic, retain) NSSet *shopNewsType;
@property (nonatomic, retain) NSSet *thumbFile;
@property (nonatomic, retain) NSSet *user;
@property (nonatomic, retain) NSSet *signAttment;
@end

@interface File (CoreDataGeneratedAccessors)

- (void)addCategoryObject:(ShopCategory *)value;
- (void)removeCategoryObject:(ShopCategory *)value;
- (void)addCategory:(NSSet *)values;
- (void)removeCategory:(NSSet *)values;
- (void)addCreditObject:(Credit *)value;
- (void)removeCreditObject:(Credit *)value;
- (void)addCredit:(NSSet *)values;
- (void)removeCredit:(NSSet *)values;
- (void)addCustomObject:(Custom *)value;
- (void)removeCustomObject:(Custom *)value;
- (void)addCustom:(NSSet *)values;
- (void)removeCustom:(NSSet *)values;
- (void)addFullFileObject:(ShopImage *)value;
- (void)removeFullFileObject:(ShopImage *)value;
- (void)addFullFile:(NSSet *)values;
- (void)removeFullFile:(NSSet *)values;
- (void)addProductObject:(Product *)value;
- (void)removeProductObject:(Product *)value;
- (void)addProduct:(NSSet *)values;
- (void)removeProduct:(NSSet *)values;
- (void)addRankObject:(Rank *)value;
- (void)removeRankObject:(Rank *)value;
- (void)addRank:(NSSet *)values;
- (void)removeRank:(NSSet *)values;
- (void)addShopObject:(Shop *)value;
- (void)removeShopObject:(Shop *)value;
- (void)addShop:(NSSet *)values;
- (void)removeShop:(NSSet *)values;
- (void)addShopNewsObject:(ShopNews *)value;
- (void)removeShopNewsObject:(ShopNews *)value;
- (void)addShopNews:(NSSet *)values;
- (void)removeShopNews:(NSSet *)values;
- (void)addShopNewsDetailObject:(ShopNews *)value;
- (void)removeShopNewsDetailObject:(ShopNews *)value;
- (void)addShopNewsDetail:(NSSet *)values;
- (void)removeShopNewsDetail:(NSSet *)values;
- (void)addShopNewsPhotoObject:(ShopNewsPhoto *)value;
- (void)removeShopNewsPhotoObject:(ShopNewsPhoto *)value;
- (void)addShopNewsPhoto:(NSSet *)values;
- (void)removeShopNewsPhoto:(NSSet *)values;
- (void)addShopNewsRankObject:(ShopNewsRank *)value;
- (void)removeShopNewsRankObject:(ShopNewsRank *)value;
- (void)addShopNewsRank:(NSSet *)values;
- (void)removeShopNewsRank:(NSSet *)values;
- (void)addShopNewsTypeObject:(ShopNewsType *)value;
- (void)removeShopNewsTypeObject:(ShopNewsType *)value;
- (void)addShopNewsType:(NSSet *)values;
- (void)removeShopNewsType:(NSSet *)values;
- (void)addThumbFileObject:(ShopImage *)value;
- (void)removeThumbFileObject:(ShopImage *)value;
- (void)addThumbFile:(NSSet *)values;
- (void)removeThumbFile:(NSSet *)values;
- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;
- (void)addSignAttmentObject:(Sign *)value;
- (void)removeSignAttmentObject:(Sign *)value;
- (void)addSignAttment:(NSSet *)values;
- (void)removeSignAttment:(NSSet *)values;
@end
