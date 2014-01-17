//
//  ShopNewsPhoto.h
//  ShopMall
//
//  Created by KingsleyYau on 13-12-4.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, ShopNews, User;

@interface ShopNewsPhoto : NSManagedObject

@property (nonatomic, retain) File *image;
@property (nonatomic, retain) ShopNews *shopNews;
@property (nonatomic, retain) User *user;

@end
