//
//  ShopCategoryManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopCategoryManager;
@protocol ShopCategoryManagerDelegate <NSObject>
- (void)updateFinished:(ShopCategoryManager *)shopCategoryManager;
- (void)updateFail:(ShopCategoryManager *)shopCategoryManager;
@end
@interface ShopCategoryManager : NSObject
@property (nonatomic, assign)  id<ShopCategoryManagerDelegate> delegate;
@property (nonatomic, assign) BOOL isAllSucceed;
- (void)cancel;
- (BOOL)loadAllListFromServer;
@end
