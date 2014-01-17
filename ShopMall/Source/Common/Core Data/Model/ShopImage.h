//
//  ShopImage.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Shop, User;

@interface ShopImage : NSManagedObject

@property (nonatomic, retain) NSNumber * imgID;
@property (nonatomic, retain) NSString * imgName;
@property (nonatomic, retain) NSString * imgType;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * star;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDate * uploadTime;
@property (nonatomic, retain) NSString * uploadUser;
@property (nonatomic, retain) File *fullFile;
@property (nonatomic, retain) Shop *shop;
@property (nonatomic, retain) File *thumFile;
@property (nonatomic, retain) User *user;

@end
