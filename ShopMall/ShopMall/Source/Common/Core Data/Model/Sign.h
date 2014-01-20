//
//  Sign.h
//  ShopMall
//
//  Created by KingsleyYau on 13-7-23.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Custom, File, Shop, User;

@interface Sign : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * scoreEnv;
@property (nonatomic, retain) NSNumber * scoreOth;
@property (nonatomic, retain) NSNumber * scorePdu;
@property (nonatomic, retain) NSNumber * scoreSrv;
@property (nonatomic, retain) NSNumber * signID;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) File *attachment;
@property (nonatomic, retain) Custom *custom;
@property (nonatomic, retain) Shop *shop;
@property (nonatomic, retain) User *user;

@end
