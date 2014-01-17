//
//  Comment.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Custom, Shop, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * commentID;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * scoreEnv;
@property (nonatomic, retain) NSNumber * scoreOth;
@property (nonatomic, retain) NSNumber * scorePdu;
@property (nonatomic, retain) NSNumber * scoreSrv;
@property (nonatomic, retain) NSNumber * star;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) Custom *custom;
@property (nonatomic, retain) Shop *shop;
@property (nonatomic, retain) User *user;

@end
