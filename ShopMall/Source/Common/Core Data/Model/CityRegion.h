//
//  CityRegion.h
//  ShopMall
//
//  Created by KingsleyYau on 13-5-2.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface CityRegion : NSManagedObject

@property (nonatomic, retain) NSString * cityRegionName;
@property (nonatomic, retain) NSSet *cities;
@end

@interface CityRegion (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(City *)value;
- (void)removeCitiesObject:(City *)value;
- (void)addCities:(NSSet *)values;
- (void)removeCities:(NSSet *)values;
@end
