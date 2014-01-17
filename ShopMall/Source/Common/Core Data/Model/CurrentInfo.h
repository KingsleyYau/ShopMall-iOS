//
//  CurrentInfo.h
//  ShopMall
//
//  Created by KingsleyYau on 13-7-23.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, User;

@interface CurrentInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * curDistanceType;
@property (nonatomic, retain) NSString * deviceInfo;
@property (nonatomic, retain) City *cityCurrent;
@property (nonatomic, retain) City *cityGPS;
@property (nonatomic, retain) User *user;

@end
