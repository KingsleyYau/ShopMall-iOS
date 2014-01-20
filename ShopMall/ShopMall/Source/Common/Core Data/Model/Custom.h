//
//  Custom.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-16.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, File, Recommend, Sign;

@interface Custom : NSManagedObject

@property (nonatomic, retain) NSString * customID;
@property (nonatomic, retain) NSString * customName;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) File *logo;
@property (nonatomic, retain) Recommend *recommends;
@property (nonatomic, retain) NSSet *signs;
@end

@interface Custom (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;
- (void)addSignsObject:(Sign *)value;
- (void)removeSignsObject:(Sign *)value;
- (void)addSigns:(NSSet *)values;
- (void)removeSigns:(NSSet *)values;
@end
