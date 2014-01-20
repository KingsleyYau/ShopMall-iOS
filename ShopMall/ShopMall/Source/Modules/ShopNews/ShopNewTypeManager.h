//
//  ShopNewTypeManager.h
//  DrPalm
//
//  Created by KingsleyYau on 13-3-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopNewTypeManager;
@protocol ShopNewTypeManagerDelegate <NSObject>
- (void)updateFinished:(ShopNewTypeManager *)shopNewTypeManager;
- (void)updateFail:(ShopNewTypeManager *)shopNewTypeManager;
@end
@interface ShopNewTypeManager : NSObject
@property (nonatomic,assign)  id<ShopNewTypeManagerDelegate> delegate;
@property (nonatomic,assign) BOOL isAllSucceed;
- (void)cancel;
- (void)loadAllListFromServer;
@end
