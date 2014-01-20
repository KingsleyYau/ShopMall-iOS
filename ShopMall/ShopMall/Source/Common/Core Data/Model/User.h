//
//  User.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-9.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, CurrentInfo, File, Shop, ShopImage, ShopNewsPhoto, ShopPersonalNews, Sign;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * countComment;
@property (nonatomic, retain) NSNumber * countFavour;
@property (nonatomic, retain) NSNumber * countFavourUnread;
@property (nonatomic, retain) NSNumber * countInfo;
@property (nonatomic, retain) NSNumber * countPhoto;
@property (nonatomic, retain) NSNumber * countSign;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSNumber * scoreOther;
@property (nonatomic, retain) NSNumber * scoreSp;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPwd;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) CurrentInfo *currentInfoUser;
@property (nonatomic, retain) File *logo;
@property (nonatomic, retain) NSSet *shopBookmark;
@property (nonatomic, retain) NSSet *shopImages;
@property (nonatomic, retain) NSSet *shopNewsPhoto;
@property (nonatomic, retain) NSSet *shopPersonalNews;
@property (nonatomic, retain) NSSet *signs;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;
- (void)addShopBookmarkObject:(Shop *)value;
- (void)removeShopBookmarkObject:(Shop *)value;
- (void)addShopBookmark:(NSSet *)values;
- (void)removeShopBookmark:(NSSet *)values;
- (void)addShopImagesObject:(ShopImage *)value;
- (void)removeShopImagesObject:(ShopImage *)value;
- (void)addShopImages:(NSSet *)values;
- (void)removeShopImages:(NSSet *)values;
- (void)addShopNewsPhotoObject:(ShopNewsPhoto *)value;
- (void)removeShopNewsPhotoObject:(ShopNewsPhoto *)value;
- (void)addShopNewsPhoto:(NSSet *)values;
- (void)removeShopNewsPhoto:(NSSet *)values;
- (void)addShopPersonalNewsObject:(ShopPersonalNews *)value;
- (void)removeShopPersonalNewsObject:(ShopPersonalNews *)value;
- (void)addShopPersonalNews:(NSSet *)values;
- (void)removeShopPersonalNews:(NSSet *)values;
- (void)addSignsObject:(Sign *)value;
- (void)removeSignsObject:(Sign *)value;
- (void)addSigns:(NSSet *)values;
- (void)removeSigns:(NSSet *)values;
@end
