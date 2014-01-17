//
//  ShopNewTypeManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-23.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewTypeManager.h"
#import "ShopCommonDef.h"

#define MAX_REQUEST_NUMBER 3
@interface ShopNewTypeManager () <ShopRequestOperatorDelegate> {
    BOOL _isAllSucceed;
    BOOL _isCategorySuccess;
    BOOL _isRankSuccess;
    BOOL _isNewsTypeSuccess;
}

- (BOOL)loadCategoryFromServer;
- (BOOL)loadRankFromServer;
- (BOOL)loadNewsType;

@property (nonatomic, retain) NSMutableArray *requestArray;
@property (nonatomic, retain) NSMutableDictionary *requestSuccessDict;
@end

@implementation ShopNewTypeManager
@synthesize delegate;
@synthesize requestArray;
- (id)init {
    if(self = [super init]) {
        self.requestArray = [NSMutableArray array];
        _isAllSucceed = NO;
        
        self.requestSuccessDict = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)dealloc {
    [self cancel];
    [self.requestArray removeAllObjects];
    self.requestArray = nil;
    self.requestSuccessDict = nil;
    [super dealloc];
}
- (void)cancel {
    [self.requestSuccessDict removeAllObjects];
    for(ShopRequestOperator *requestOperator in self.requestArray) {
        [requestOperator cancel];
    }
}
- (void)loadAllListFromServer {
    if(_isAllSucceed) {
        if([self.delegate respondsToSelector:@selector(updateFinished:)]){
            [self.delegate updateFinished:self];
        }
        return;
    }
    [self cancel];
    
    [self loadCategoryFromServer];
    [self loadRankFromServer];
    [self loadNewsType];
}
#pragma mark - 请求行业分类
- (BOOL)loadCategoryFromServer {
    ShopRequestOperator *requestOperator = [[[ShopRequestOperator alloc] init] autorelease];
    requestOperator.delegate = self;
    [self.requestArray addObject:requestOperator];
    return [requestOperator updateCategoryList:0];
}
- (BOOL)loadCategoryFromServer:(NSNumber *)categoryID {
    ShopRequestOperator *requestOperator = [[[ShopRequestOperator alloc] init] autorelease];
    requestOperator.delegate = self;
    [self.requestArray addObject:requestOperator];
    return [requestOperator updateCategoryList:categoryID];
}
#pragma mark - 请求排行榜
- (BOOL)loadRankFromServer {
    ShopRequestOperator *requestOperator = [[[ShopRequestOperator alloc] init] autorelease];
    requestOperator.delegate = self;
    [self.requestArray addObject:requestOperator];
    return [requestOperator updateShopNewsRankList];
}
#pragma mark - 资讯类型
- (BOOL)loadNewsType {
    ShopRequestOperator *requestOperator = [[[ShopRequestOperator alloc] init] autorelease];
    requestOperator.delegate = self;
    [self.requestArray addObject:requestOperator];
    return [requestOperator updateShopNewsTypeList];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateCategory:{
            BOOL bFlag = YES;
            for(ShopCategory *category in [ShopDataManager categoryList]) {
                if(category.categorySubs.count == 0) {
                    bFlag = NO;
                    [self loadCategoryFromServer:category.categoryID];
                }
            }
            if(bFlag) {
                [self.requestSuccessDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateCategory]];
            }
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopNewsType:{
            // 资讯类型
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateShopNewsType]];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopNewsRankList:{
            // 行业排行榜
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateShopNewsRankList]];
            break;
        }
        default:break;
    }
    if(self.requestSuccessDict.count == MAX_REQUEST_NUMBER) {
        BOOL bFlag = YES;
        for(NSNumber *success in self.requestSuccessDict) {
            if([success boolValue] == NO) {
                bFlag = NO;
                break;
            }
        }
        [self cancel];
        if(bFlag) {
            _isAllSucceed = YES;
            if([self.delegate respondsToSelector:@selector(updateFinished:)]){
                [self.delegate updateFinished:self];
            }
        }
        else {
            if([self.delegate respondsToSelector:@selector(updateFail:)]){
                [self.delegate updateFail:self];
            }
        }
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateCategory:{
            // 行业分类
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateCategory]];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopNewsType:{
            // 资讯类型
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateShopNewsType]];
            break;
        }
        case ShopRequestOperatorStatus_UpdateShopNewsRankList:{
            // 行业排行榜
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateShopNewsRankList]];
            break;
        }

        default:break;
    }
    [self cancel];
    if([self.delegate respondsToSelector:@selector(updateFail:)]){
        [self.delegate updateFail:self];
    }
}
@end
