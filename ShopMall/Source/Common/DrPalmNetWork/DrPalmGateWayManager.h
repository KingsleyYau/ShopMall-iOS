//
//  DrPalmGateWayManage.h
//  MIT Mobile
//
//  Created by fgx_lion on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//  负责向中心获取网关列表及学校ID

#import <Foundation/Foundation.h>
#import "ConnectionWrapper.h"
//#import "MIT_MobileAppDelegate.h"

//#define DrPalmGateWayManagerInstance() [MITAppDelegate() gatewayManager]

@protocol DrPalmGateWayManagerDelegate <NSObject>
@optional
-(void)getGateWaySuccess;
-(void)getGateWayFail;
@end

@interface DrPalmGateWayManager : NSObject<ConnectionWrapperDelegate>
{
    NSMutableSet *_delegates;
    //NSMutableSet *_currDelegates;
    ConnectionWrapper *_connectionWrapper;
    NSString *_schoolId;
    NSString *_schoolKey;
    NSString *_getPwdUrl;
    NSLock* _lock;
    BOOL _handling;
}
-(BOOL)addDelegate:(id<DrPalmGateWayManagerDelegate>)delegate;
-(BOOL)removeDelegate:(id<DrPalmGateWayManagerDelegate>)delegate;

-(BOOL)getGateWays:(id<DrPalmGateWayManagerDelegate>)delegate;
-(BOOL)getGateWays:(id<DrPalmGateWayManagerDelegate>)delegate schoolKey:(NSString*)schoolKey;
-(void)cancel;

- (NSString *)lastSchoolKey;
- (void)setLastSchoolKey:(NSString *)schoolKey;

@property (nonatomic, retain) NSString *schoolId;
@property (nonatomic, retain) NSString *schoolKey;
@property (nonatomic, retain) NSString *getPwdUrl;
@end
