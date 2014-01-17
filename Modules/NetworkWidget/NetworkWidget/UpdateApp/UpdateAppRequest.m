//
//  UpdateAppRequest.m
//  DrPalm
//
//  Created by Kingsley on 12-11-5.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "UpdateAppRequest.h"
#import "HttpClient.h"
#import "MITJSON.h"
//#import "AppEnviroment.h"

#define ITUNES_APPLE_COM_LOOKUP    @"http://itunes.apple.com/lookup"
#define ID_KEY                     @"id"
#define ID_VALUE                   @"531226196"
#define APPLEID                    @"AppleId"
#define CONTENT_TYPE_TEXT          @"text/plain; charset=UTF-8"
#define COUNTRY                    @"country"
#define LANG                       @"lang"

#define RESULTS                    @"results" 
#define VERSION                    @"version"
#define TRACKVIEWURL               @"trackViewUrl"
#define RELEASENOTES               @"releaseNotes"
#define GET_UPDATE_INFO_ERROR      @"get update info error."
#define NO_UPDATE_INFO_ERROR       @"no info error."
@interface UpdateAppRequest() <HttpClientDelegate>{

}
- (void)cancel;
- (void)handleUpdateRequest:(id)data;
@property (nonatomic, retain) HttpClient *httpClient;
@end

@implementation UpdateAppRequest
@synthesize httpClient;
@synthesize delegate;
#pragma mark - PrivateFunction
- (void)dealloc {
    [self cancel];
    [super dealloc];
}
- (void)cancel {
    self.httpClient = nil;
}
- (NSString *)getPreferredCountry {
    NSLocale *currentUsersLocale = [NSLocale currentLocale];
    NSString *localIdentifier = [currentUsersLocale localeIdentifier];
//    NSArray *codes = [NSLocale ISOCountryCodes];
    
    NSRange range = [localIdentifier rangeOfString:@"_"];
    NSString *country  = @"";
    if(range.location != NSNotFound) {
        country = [localIdentifier substringFromIndex:(range.location+range.length)];
    }
    return country;
}
- (NSString *)getPreferredLanguage {
    NSString *lang = @"en_us";
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
    
    if([preferredLang isEqualToString:@"zh-Hans"]){
        // 简体
        lang = @"zh_cn";
    }
    else if([preferredLang isEqualToString:@"zh-Hant"]){
        // 繁体
        lang = @"zh_cn";
    }
    return lang;
}
- (BOOL)sendUpdateRequest {
    [self cancel];
    self.httpClient = [[[HttpClient alloc] init] autorelease];
    self.httpClient.delegate = self;
    
    /* Post */
//    [self.httpClient resetBoundary];
//    NSMutableData *postData = [NSMutableData data];
//    NSMutableString *httpBody = [NSMutableString string];
//    [httpBody appendString:[self.httpClient buildPostParam:(NSString*)ID_KEY contentType:CONTENT_TYPE_TEXT content:ID_KEY]];
//    [postData appendData:[httpBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
//    return [self.httpClient sendSinglePost:ITUNES_APPLE_COM_LOOKUP body:postData];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
//   [paramDict setValue:ID_VALUE forKey:ID_KEY];
//   [paramDict setObject:AppEnviromentInstance().clientEntitlement.iTunesId forKey:ID_KEY];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appleId = [infoDict objectForKey:APPLEID];
    [paramDict setObject:appleId forKey:ID_KEY];
    
    NSString *lang = [self getPreferredLanguage];
    [paramDict setObject:lang forKey:LANG];
    
    NSString *country = [self getPreferredCountry];
    [paramDict setObject:country forKey:COUNTRY];
    
    return [self.httpClient sendSingleGet:ITUNES_APPLE_COM_LOOKUP paramDict:paramDict];
}
- (void)handleUpdateRequest:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        // parsing result list
        if ([[data objectForKey:RESULTS] isKindOfClass:[NSArray class]]
            && [[(NSArray*)[data objectForKey:RESULTS] lastObject] isKindOfClass:[NSDictionary class]])
        {
            BOOL bFlag = NO;
            for (NSDictionary* dict in (NSArray*)[data objectForKey:RESULTS])
            {
                bFlag = YES;
                NSString *version;
                NSString *url;
                NSString *notes;
                id foundValue = [dict objectForKey:VERSION];
                if (nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]]){
                    version = foundValue;
                }
                foundValue = [dict objectForKey:TRACKVIEWURL];
                if (nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]]){
                    url = foundValue;
                }
                foundValue = [dict objectForKey:RELEASENOTES];
                if (nil != foundValue && foundValue != [NSNull null] && [foundValue isKindOfClass:[NSString class]]){
                    notes = foundValue;
                }
                if(delegate) {
                    if([delegate respondsToSelector:@selector(updateFinish:version:notes:)]){
                        [delegate updateFinish:url version:version notes:notes];
                    }
                }
            }
            if(NO == bFlag) {
                if(delegate) {
                    if([delegate respondsToSelector:@selector(updateFail:)]){
                        [delegate updateFail:NO_UPDATE_INFO_ERROR];
                    }
                }
            }
        }
        else {
            if(delegate) {
                if([delegate respondsToSelector:@selector(updateFail:)]){
                    [delegate updateFail:GET_UPDATE_INFO_ERROR];
                }
            }
        }
    }
}

#pragma mark - HttpClientDelegate
- (void)requestFinish:(id)data {
    id json = [MITJSON objectWithJSONData:data];
    [self handleUpdateRequest:json];
}
- (void)requestFail:(NSString*)error {
    if(delegate) {
        if([delegate respondsToSelector:@selector(updateFail:)]){
            [delegate updateFail:error];
        }
    }
}

@end
