//
//  Shop.h
//  ShopMall
//
//  Created by KingsleyYau on 13-7-23.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Comment, Credit, File, Product, Rank, Recommend, Region, ShopCategory, ShopImage, ShopNews, Sign, User;

@interface Shop : NSManagedObject

@property (nonatomic, retain) NSDate * addDate;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * isCard;
@property (nonatomic, retain) NSNumber * isDiscount;
@property (nonatomic, retain) NSNumber * isDsf;
@property (nonatomic, retain) NSNumber * isGift;
@property (nonatomic, retain) NSNumber * isHyf;
@property (nonatomic, retain) NSNumber * isPromo;
@property (nonatomic, retain) NSString * lastComment;
@property (nonatomic, retain) NSNumber * lastCommentStar;
@property (nonatomic, retain) NSDate * lastCommentTime;
@property (nonatomic, retain) NSString * lastCommentUser;
@property (nonatomic, retain) NSDate * lastDate;
@property (nonatomic, retain) NSNumber * lastInfoCount;
@property (nonatomic, retain) NSString * lastInfoTitle;
@property (nonatomic, retain) NSString * lastSignDetail;
@property (nonatomic, retain) NSDate * lastSignTime;
@property (nonatomic, retain) NSString * lastSignUser;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * phone2;
@property (nonatomic, retain) NSNumber * priceAvg;
@property (nonatomic, retain) NSString * priceText;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * scoreEnv;
@property (nonatomic, retain) NSNumber * scoreOth;
@property (nonatomic, retain) NSNumber * scorePdu;
@property (nonatomic, retain) NSNumber * scoreSrv;
@property (nonatomic, retain) NSString * scoreText;
@property (nonatomic, retain) NSNumber * shopID;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSString * shopNameEng;
@property (nonatomic, retain) NSString * shopTag;
@property (nonatomic, retain) NSNumber * shopTagID;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSNumber * totalComment;
@property (nonatomic, retain) NSNumber * totalSign;
@property (nonatomic, retain) NSString * trafficInfo;
@property (nonatomic, retain) NSString * writeUp;
@property (nonatomic, retain) ShopCategory *category;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *credit;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) File *logo;
@property (nonatomic, retain) NSSet *products;
@property (nonatomic, retain) NSSet *rank;
@property (nonatomic, retain) NSSet *recommends;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) NSSet *shopNews;
@property (nonatomic, retain) NSSet *signs;
@property (nonatomic, retain) NSSet *userBookmark;
@end

@interface Shop (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;
- (void)addCreditObject:(Credit *)value;
- (void)removeCreditObject:(Credit *)value;
- (void)addCredit:(NSSet *)values;
- (void)removeCredit:(NSSet *)values;
- (void)addImagesObject:(ShopImage *)value;
- (void)removeImagesObject:(ShopImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;
- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;
- (void)addProducts:(NSSet *)values;
- (void)removeProducts:(NSSet *)values;
- (void)addRankObject:(Rank *)value;
- (void)removeRankObject:(Rank *)value;
- (void)addRank:(NSSet *)values;
- (void)removeRank:(NSSet *)values;
- (void)addRecommendsObject:(Recommend *)value;
- (void)removeRecommendsObject:(Recommend *)value;
- (void)addRecommends:(NSSet *)values;
- (void)removeRecommends:(NSSet *)values;
- (void)addShopNewsObject:(ShopNews *)value;
- (void)removeShopNewsObject:(ShopNews *)value;
- (void)addShopNews:(NSSet *)values;
- (void)removeShopNews:(NSSet *)values;
- (void)addSignsObject:(Sign *)value;
- (void)removeSignsObject:(Sign *)value;
- (void)addSigns:(NSSet *)values;
- (void)removeSigns:(NSSet *)values;
- (void)addUserBookmarkObject:(User *)value;
- (void)removeUserBookmarkObject:(User *)value;
- (void)addUserBookmark:(NSSet *)values;
- (void)removeUserBookmark:(NSSet *)values;
@end
