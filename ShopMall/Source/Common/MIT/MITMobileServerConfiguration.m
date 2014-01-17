//
//  MITMobileServerConfiguration.m
//

#import <Foundation/Foundation.h>
#import "MITMobileServerConfiguration.h"
//#import "Secret.h"

#ifndef MobileAPI_DefaultServerIndex
    #define MobileAPI_DefaultServerIndex 0
#endif

static NSMutableArray* g_apiServerArray = nil;
BOOL SetAPIServerList(NSArray* array)
{
    [g_apiServerArray release];
    g_apiServerArray = [[NSMutableArray alloc] initWithArray:array];
    return (nil != g_apiServerArray && g_apiServerArray.count > 0);
}



NSArray* MITMobileWebGetAPIServerList( void ) {
    
    static NSMutableArray* array = nil;
    
    // 2011-12-26 fgx add for test
//    if (nil == g_apiServerArray)
//    {
//        if (array == nil) {
//            array = [[NSMutableArray alloc] init];
//            for (int i = 0; MobileAPIServers[i] != nil; ++i) {
//                NSURL *url = [NSURL URLWithString:MobileAPIServers[i]];
//                if (url != nil) {
//                    DLog( @"Got %@", [url absoluteString]);
//                    [array addObject:url];
//                } else {
//                    ELog(@"API URL '%@' is malformed", url);
//                }
//            }
//            
//            NSCAssert(([array count] >= 1),@"There must be at least 1 valid API server");
//        }
//    }
//    else
//    {
        array = g_apiServerArray;
//    }
    
    return [[array copy] autorelease];
}


NSURL* MITMobileWebGetDefaultServerURL( void ) {
    return [[[MITMobileWebGetAPIServerList() objectAtIndex:MobileAPI_DefaultServerIndex] copy] autorelease];
}


BOOL MITMobileWebSetCurrentServerURL(NSURL* serverURL) {
    NSArray *servers = MITMobileWebGetAPIServerList();
    
    if (![servers containsObject:serverURL])
        return NO;
    else {
        [[NSUserDefaults standardUserDefaults] setURL:serverURL forKey:@"api_server"];
        return YES;
    }
}


NSURL* MITMobileWebGetCurrentServerURL( void ) {
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSURL* server = [defaults URLForKey:@"api_server"];
//    NSArray* serverList = MITMobileWebGetAPIServerList();
//    
//    if ((server == nil) || (![serverList containsObject:server] )) {
//        server = MITMobileWebGetDefaultServerURL();
//        [defaults setURL:server
//                  forKey:@"api_server"];
//    }
    NSURL* server = MITMobileWebGetDefaultServerURL();
    //server = [NSURL URLWithString:@"http://58.67.148.65:8000/Market/webapi/"];
    return server;
}


NSString* MITMobileWebGetCurrentServerDomain( void ) {
    NSURL* server = MITMobileWebGetCurrentServerURL();
    return [server host];
}


MITMobileWebServerType MITMobileWebGetCurrentServerType( void ) {
    NSURL *server = MITMobileWebGetCurrentServerURL();
    NSRange foundRange = [[server host] rangeOfString:@"-dev."];

    if (foundRange.location != NSNotFound) {
        return MITMobileWebDevelopment;
    }
    
    foundRange = [[server host] rangeOfString:@"-stage."];
    if (foundRange.location != NSNotFound) {
        return MITMobileWebStaging;
    }
    
    return MITMobileWebProduction;
}