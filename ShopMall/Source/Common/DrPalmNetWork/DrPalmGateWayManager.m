//
//  DrPalmGateWayManager.m
//  MIT Mobile
//
//  Created by fgx_lion on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DrPalmGateWayManager.h"
#import "MITJSON.h"
#import "AppEnviroment.h"

//#define CENTERURL @"http://%@/netapp/org.drcom.drpalm.getAppGw.flow?schoolkey=%@"

#define CENTERURL @"http://%@/netapp/getAppGw?schoolkey=%@"

#define GATEWAYURL @"http://%@/Ebaby3/mobileapi/"
#define OPRET @"opret"
#define OPFLAG @"opflag"
#define OPFLAGSUCCESS 1
#define OPFLAGFAIL 0
#define OPCODE @"code"
#define SCHOOLID @"schoolid"
#define GWLIST @"gwlist"
#define GW @"gw"
#define ADDR @"addr"
#define PORT @"port"
#define ACCURL @"accurl"

@interface DrPalmGateWayManager() {
    
}
@property (nonatomic, retain) NSMutableSet  *delegates;

-(BOOL)parsingOpret:(id)opretDic opFlag:(NSInteger*)opFlag opCode:(NSString**)code;
-(NSArray*)parsingGatewayList:(id)gwlistArray;
//-(NSArray*)parsingAccUrlList:(id)gwlistArray;

- (NSString*)schoolKeyRecordPath;
@end

@implementation DrPalmGateWayManager
@synthesize schoolId = _schoolId;
@synthesize schoolKey = _schoolKey;
@synthesize delegates = _delegates;
@synthesize getPwdUrl = _getPwdUrl;
-(id)init
{
    if (self = [super init])
    {
        _schoolId = nil;
        _schoolKey = nil;
        _getPwdUrl = nil;
        //_schoolId = @"6361";
        _connectionWrapper = nil;
        _lock = [[NSLock alloc] init];
        _handling = NO;
        //self.currDelegates = [NSMutableSet set];
        self.delegates = [NSMutableSet set];
    }
    return self;
}

-(void)dealloc
{
    [self cancel];
    
    if(nil != _schoolId) {
        [_schoolId release];
        _schoolId = nil;
    }

    if(nil != _schoolKey) {
        [_schoolKey release];
        _schoolKey = nil;
    }
    
    if(nil != _getPwdUrl) {
        [_getPwdUrl release];
        _getPwdUrl = nil;
    }

    
    [self.delegates removeAllObjects];
    self.delegates = nil;
    
    if(nil != _lock) {
        [_lock release];
        _lock = nil;
    }

    [super dealloc];
}

-(BOOL)addDelegate:(id<DrPalmGateWayManagerDelegate>)delegate
{
    //    if ([_lock tryLock]){
    [_lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    [_delegates addObject:delegate];
    //    }
    [_lock unlock];
    return YES;
}

-(BOOL)removeDelegate:(id<DrPalmGateWayManagerDelegate>)delegate
{
    //    if ([_lock tryLock]){
    [_lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    [_delegates removeObject:delegate];
    //    }
    [_lock unlock];
    return YES;
}

-(BOOL)getGateWays:(id<DrPalmGateWayManagerDelegate>)delegate
{
        [self addDelegate:delegate];
    if (!_handling){
        [self cancel];
        _handling = YES;
        
        _connectionWrapper = [[ConnectionWrapper alloc] initWithDelegate:self];
//        NSURL* centerUrl = [NSURL URLWithString:[NSString stringWithFormat:CENTERURL, AppEnviromentInstance().clientEntitlement.centerDomain, AppEnviromentInstance().clientEntitlement.schoolKey]];
        
        // 用配置文件的schoolKey
        NSURL* centerUrl = [NSURL URLWithString:[NSString stringWithFormat:CENTERURL, AppEnviromentInstance().clientEntitlement.centerDomain, _schoolKey]];
        
        [_connectionWrapper requestDataFromURL:centerUrl];
    }
    
    return YES;
}

-(BOOL)getGateWays:(id<DrPalmGateWayManagerDelegate>)delegate schoolKey:(NSString*)schoolKey
{
        [self addDelegate:delegate];
    if (!_handling){
        [self cancel];
        _handling = YES;
        
        _connectionWrapper = [[ConnectionWrapper alloc] initWithDelegate:self];
        NSURL* centerUrl = [NSURL URLWithString:[NSString stringWithFormat:CENTERURL, AppEnviromentInstance().clientEntitlement.centerDomain, schoolKey]];      
        [_connectionWrapper requestDataFromURL:centerUrl];
    }
    
    return YES;
}

-(void)cancel
{
    [_connectionWrapper cancel];
    [_connectionWrapper release];
    _connectionWrapper = nil;
    
    _handling = NO;
}

#pragma mark - call delegate
-(void)callDelegateGetGatewaySuccess
{

    [_lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
        for (id<DrPalmGateWayManagerDelegate> delegate in self.delegates)
        {
            if ([delegate respondsToSelector:@selector(getGateWaySuccess)]){
                [delegate getGateWaySuccess];
            }
        }
        [self.delegates removeAllObjects];
    [_lock unlock];

}

-(void)callDelegateGetGatewayFail
{
    [_lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
        for (id<DrPalmGateWayManagerDelegate> delegate in self.delegates)
        {
            if ([delegate respondsToSelector:@selector(getGateWayFail)]){
                [delegate getGateWayFail];
            }
        }
        [self.delegates removeAllObjects];
    [_lock unlock];
}

#pragma mark - ConnectionWrapperDelegate
-(void)connection:(ConnectionWrapper *)wrapper handleData:(NSData *)data
{
    BOOL success = NO;

    id parsedData = [MITJSON objectWithJSONData:data];
    if (nil != parsedData && [parsedData isKindOfClass:[NSDictionary class]])
    {
        [_schoolId release];
        _schoolId = [[parsedData objectForKey:SCHOOLID] copy];
        
        NSInteger opflag = 0;
        NSString* code = nil;
        if ([self parsingOpret:[parsedData objectForKey:OPRET] opFlag:&opflag opCode:&code]
            && opflag == OPFLAGSUCCESS)
        {
            NSArray* gatewayList = [self parsingGatewayList:[parsedData objectForKey:GWLIST]];
            if (SetAPIServerList(gatewayList))
            {
                success = YES;
            }
        }
    }

    
    if (success)
    {
        [self callDelegateGetGatewaySuccess];
    }
    else
    {
        [self callDelegateGetGatewayFail];
    }
    
    _handling = NO;
}

-(void)connection:(ConnectionWrapper *)wrapper handleConnectionFailureWithError:(NSError *)error
{
    [self callDelegateGetGatewayFail];
    _handling = NO;
}

#pragma mark - ParsingProtocol
-(BOOL)parsingOpret:(id)opretDic opFlag:(NSInteger*)opFlag opCode:(NSString**)code
{
    BOOL result = NO;
    *opFlag = 0;
    *code = nil;
    
    if (nil != opretDic 
        && [opretDic isKindOfClass:[NSDictionary class]])
    {
        NSString* opflag = [opretDic objectForKey:OPFLAG];
        if (nil != opflag)
        {
            *opFlag = [opflag integerValue];
            *code = [opretDic objectForKey:OPCODE];
            result = YES;
        }
    }
    return result;
}

-(NSArray*)parsingGatewayList:(id)gwlistArray
{
    NSArray* result = nil;
    if (nil != gwlistArray
        && [gwlistArray isKindOfClass:[NSArray class]]
        && [gwlistArray count] > 0)
    {
        NSMutableArray* gatewayArray = [[NSMutableArray alloc] init];
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        for (NSDictionary* gateway in gwlistArray)
        {
            NSString* addr = [gateway objectForKey:ADDR];
            NSString* port = [gateway objectForKey:PORT];
            if (nil != addr && [addr length] > 0)
            {
                NSString *url = nil;
                if (nil != port && [port length]){
                    url = [NSString stringWithFormat:@"%@:%@", addr, port];
                }
                else{
                    url = addr;
                }
                [gatewayArray addObject:[NSURL URLWithString:[NSString stringWithFormat:GATEWAYURL, url]]];
            }
        }
        [pool drain];
        
        result = [NSArray arrayWithArray:gatewayArray];
        [gatewayArray release];
    }
    return result;
}
#pragma mark - (当前schoolKey记录) 
#define SCHOOLKEY_RECORD_PLIST @"SchoolKeyRecord"
// Keys
#define LAST_SCHOOLKEY  @"LastSchoolKey"
- (NSString*)schoolKeyRecordPath{
    NSString *mainPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.plist",  mainPath, SCHOOLKEY_RECORD_PLIST, nil];
    return path;
}
- (NSString *)lastSchoolKey {
    NSString *lastSchoolKey = @"";
    NSString *path = [self schoolKeyRecordPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    id foundValue = [dict objectForKey:LAST_SCHOOLKEY];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        lastSchoolKey = foundValue;
    }
    return lastSchoolKey;
}
- (void)setLastSchoolKey:(NSString *)schoolKey {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *path = [self schoolKeyRecordPath];
    [dict addEntriesFromDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:path]];
    [dict setObject:schoolKey forKey:LAST_SCHOOLKEY];
    [dict writeToFile:path atomically:YES];
}
@end
