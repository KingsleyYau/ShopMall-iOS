//
//  ShopCategoryManager.m
//  DrPalm
//
//  Created by KingsleyYau on 13-3-17.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopCategoryManager.h"
#import "ShopCommonDef.h"

#define MAX_REQUEST_NUMBER 4
@interface ShopCategoryManager () <ShopRequestOperatorDelegate> {
    BOOL _isAllSucceed;
    BOOL _isCategorySuccess;
    BOOL _isRegionSuccess;
    BOOL _isRankSuccess;
    BOOL _isCreditSucess;
    BOOL _isSortSuccess;
    
    BOOL _isCallback;
}

- (BOOL)loadRegionFromServer;
- (BOOL)loadCategoryFromServer;
- (BOOL)loadRankFromServer;
- (BOOL)loadCreditFromServer;
- (BOOL)loadSortFromServer;

@property (nonatomic, retain) NSMutableArray *requestArray;
@property (nonatomic, retain) NSMutableDictionary *requestSuccessDict;
@end

@implementation ShopCategoryManager
@synthesize delegate;
@synthesize requestArray;
@synthesize isAllSucceed = _isAllSucceed;
- (id)init {
    if(self = [super init]) {
        self.requestArray = [NSMutableArray array];
        _isAllSucceed = NO;
        _isCallback = YES;
        self.requestSuccessDict = [NSMutableDictionary dictionary];
        
        // 清除本地数据
        //[ShopDataManager clearCategory];
        [ShopDataManager clearRegion];
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
- (void)setIsAllSucceed:(BOOL)isAllSucceed {
    if(!isAllSucceed) {
        // 清除本地数据
        //[ShopDataManager clearCategory];
        //[ShopDataManager clearRegion];
    }
    _isAllSucceed = isAllSucceed;
}
- (void)cancel {
    for(ShopRequestOperator *requestOperator in self.requestArray) {
        [requestOperator cancel];
    }
    
    [self.requestSuccessDict removeAllObjects];
    
    _isCallback = YES;
}
- (BOOL)loadAllListFromServer {
    if(_isAllSucceed) {
        if([self.delegate respondsToSelector:@selector(updateFinished:)]){
            [self.delegate updateFinished:self];
        }
        return NO;
    }
    [self cancel];
    
    [self loadRegionFromServer];
    [self loadCategoryFromServer];
    [self loadCreditFromServer];
    //[self loadRankFromServer];
    [self loadSortFromServer];
    return YES;
}
#pragma mark - 请求商区
- (BOOL)loadRegionFromServer {
    ShopRequestOperator *requestOperator = [[[ShopRequestOperator alloc] init] autorelease];
    requestOperator.delegate = self;
    [self.requestArray addObject:requestOperator];
    return [requestOperator updateRegionList:0];
}
- (BOOL)loadRegionFromServer:(NSNumber *)regionID {
    ShopRequestOperator *requestOperator = [[[ShopRequestOperator alloc] init] autorelease];
    requestOperator.delegate = self;
    [self.requestArray addObject:requestOperator];
    return [requestOperator updateRegionList:regionID];
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
    return [requestOperator updateRankList];
}
#pragma mark - 积分类型
- (BOOL)loadCreditFromServer {
    ShopRequestOperator *requestOperator = [[[ShopRequestOperator alloc] init] autorelease];
    requestOperator.delegate = self;
    [self.requestArray addObject:requestOperator];
    return [requestOperator updateCreditList];
}
#pragma mark - 请求排序类型
- (BOOL)loadSortFromServer {
    ShopRequestOperator *requestOperator = [[[ShopRequestOperator alloc] init] autorelease];
    requestOperator.delegate = self;
    [self.requestArray addObject:requestOperator];
    return [requestOperator updateSortList];
}
#pragma mark - 协议回调 (ShopRequestOperatorDelegate)
- (void)requestFinish:(id)data requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateRegionList:{
            // 商区
            BOOL bFlag = YES;
            for(Region *region in [ShopDataManager regionList]) {
                //if(region.subs.count == 0) {
                if(![region.isAlreadyLoad boolValue]) {
                    // 还没请求子分类
                    bFlag = NO;
                    [self loadRegionFromServer:region.regionID];
                }
            }
            if(bFlag) {
                [self.requestSuccessDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateRegionList]];
            }
            break;
        }
        case ShopRequestOperatorStatus_UpdateCategory:{
            BOOL bFlag = YES;
            for(ShopCategory *category in [ShopDataManager categoryList]) {
                //if(category.categorySubs.count == 0) {
                if(![category.isAlreadyLoad boolValue]) {
                    // 还没有获取子分类
                    bFlag = NO;
                    [self loadCategoryFromServer:category.categoryID];
                }
            }
            if(bFlag) {
                [self.requestSuccessDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateCategory]];
            }
            break;
        }
        case ShopRequestOperatorStatus_UpdateCredit:{
            // 积分类型
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateCredit]];
            break;
        }
        case ShopRequestOperatorStatus_UpdateSort:{
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateSort]];
            // 排序类型
            break;
        }
//        case ShopRequestOperatorStatus_UpdateRankList:{
//            // 行业排行榜
//            [self.requestSuccessDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateRankList]];
//            break;
//        }
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
        [self cancel];
    }
}
- (void)requestFail:(NSString*)error requestType:(ShopRequestOperatorStatus)type {
    switch(type){
        case ShopRequestOperatorStatus_UpdateRegionList:{
            // 商区
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateRegionList]];
            break;
        }
        case ShopRequestOperatorStatus_UpdateCategory:{
            // 行业分类
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateCategory]];
            break;
        }
        case ShopRequestOperatorStatus_UpdateCredit:{
            // 积分类型
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateCredit]];
            break;
        }
        case ShopRequestOperatorStatus_UpdateSort:{
            // 排序类型
            [self.requestSuccessDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateSort]];
            break;
        }
//        case ShopRequestOperatorStatus_UpdateRankList:{
//            // 行业排行榜
//            [self.requestSuccessDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", ShopRequestOperatorStatus_UpdateRankList]];
//            break;
//        }
        default:break;
    }
    if(_isCallback) {
        if([self.delegate respondsToSelector:@selector(updateFail:)]){
            [self.delegate updateFail:self];
            _isCallback = NO;
        }
    }
    [self cancel];
}
@end
