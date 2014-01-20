//
//  AppEnviroment.m
//  DrPalm
//
//  Created by jiangbo on 2/3/12.
//  Copyright (c) 2012 DrCOM. All rights reserved.
//

#import "AppEnviroment.h"
#import "UIColor+RGB.h"
#import "ResourceManager.h"
#import "UIImage+ResourcePath.h"
@interface AppEnviroment(private)
-(void)initValue;
-(void)parsingClientEntitlement:(NSDictionary*)dict;
-(void)parsingGlobalUIEntitlement:(NSDictionary*)dict;

-(void)parsingNavigationBarEntitlement:(NSDictionary*)dict;
-(void)parsingSearchBarEntitlement:(NSDictionary*)dict;
-(void)parsingBaseViewControllerEntitlement:(NSDictionary*)dict;
-(void)parsingEGOColorEntitlement:(NSDictionary*)dict;

-(void)parsingCalendarEntitlement:(NSDictionary*)dict;
-(void)parsingShareEntitlement:(NSDictionary*)dict;
@end

@implementation AppEnviroment
@synthesize clientEntitlement = _clientEntitlement;
@synthesize globalUIEntitlement = _globalUIEntitlement;
@synthesize calendarEntitlement = _calendarEntitlement;
@synthesize shareEntitlement = _shareEntitlement;
@synthesize showAboutInSetting = _showAboutInSetting;
@synthesize applyUrl = _applyUrl;

-(id)init
{
    if (self = [super init])
    {
        self.clientEntitlement = nil;
        self.globalUIEntitlement = nil;
        self.calendarEntitlement = nil;
        self.shareEntitlement = nil;
        self.showAboutInSetting = NO;
        self.applyUrl = nil;
        
        [self initValue];
    }
    return self;
}

-(void)dealloc
{
    self.clientEntitlement = nil;
    self.globalUIEntitlement = nil;
    self.calendarEntitlement = nil;
    self.shareEntitlement = nil;
    self.showAboutInSetting = NO;
    self.applyUrl = nil;
    [super dealloc];
}

-(void)initValue
{
    NSString *realPath = [ResourceManager pathForResource:@"Enviroment" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:realPath];
    if(dict == nil)
        return;
    
    // 是否在 Settting 模块中显示 About
    _showAboutInSetting = [[dict objectForKey:@"Show about in setting"] boolValue];
    
    // 解释ClientEntitlement
    [self parsingClientEntitlement:dict];
    // 解释GlobalUIEntitlement
    [self parsingGlobalUIEntitlement:dict];
    // 解释CalendarEntitlement
    [self parsingCalendarEntitlement:dict];
    // 解释ShareEntitlement
    [self parsingShareEntitlement:dict];
    
    // 解释申请链接
    self.applyUrl = [dict objectForKey:@"ApplyUrl"];
    if ([self.applyUrl length] == 0){
        NSString *infoPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
        self.applyUrl = [infoDict objectForKey:@"ApplyUrl"];
    }
}

#pragma mark - 解释ClientEntitlement
-(void)parsingClientEntitlement:(NSDictionary*)dict
{
    if (nil == self.clientEntitlement){
        self.clientEntitlement = [[[ClientEntitlement alloc] init] autorelease];
    }
    
    NSDictionary *clientEntitlementDict = [dict objectForKey:@"ClientEntitlement"];
    
    // 解释 CenterDomain
    self.clientEntitlement.centerDomain = [clientEntitlementDict objectForKey:@"CenterDomain"];
    // 解释 SchoolKey
    self.clientEntitlement.schoolKey = [clientEntitlementDict objectForKey:@"SchoolKey"];
    // 解释 iTunesId
    //self.clientEntitlement.iTunesId = [clientEntitlementDict objectForKey:@"iTunesId"];
}

#pragma mark - 解释GlobalUIEntitlement
-(void)parsingGlobalUIEntitlement:(NSDictionary*)dict
{
    if (nil == self.globalUIEntitlement){
        self.globalUIEntitlement = [[[GlobalUIEntitlement alloc] init] autorelease];
    }
    
    NSDictionary *globalUIDict = [dict objectForKey:@"GlobalUI"];
    [self parsingNavigationBarEntitlement:globalUIDict];
    [self parsingSearchBarEntitlement:globalUIDict];
    [self parsingBaseViewControllerEntitlement:globalUIDict];
    [self parsingEGOColorEntitlement:globalUIDict];
}

// 解释NavigationBarEntitlement
-(void)parsingNavigationBarEntitlement:(NSDictionary*)dict
{
    if (nil == self.globalUIEntitlement.navigationBarEntitlement){
        self.globalUIEntitlement.navigationBarEntitlement = [[[NavigationBarEntitlement alloc] init] autorelease];
    }
    
    NSDictionary *navBarDict = [dict objectForKey:@"NavigationBar"];
    
    // 解释NavigationBarTitle
    NSDictionary *navBarTitleDict = [navBarDict objectForKey:@"NavigationBarTitle"];
    self.globalUIEntitlement.navigationBarEntitlement.isShowImage = [[navBarTitleDict objectForKey:@"isShowImage"] boolValue];
    self.globalUIEntitlement.navigationBarEntitlement.titleString = [navBarTitleDict objectForKey:@"title"];
    self.globalUIEntitlement.navigationBarEntitlement.titleImage = [UIImage imageNamedWithData:[ResourceManager resourceFilePath:[navBarTitleDict objectForKey:@"image path"]]];
    
    // 解释NavigationBarTintColor
    NSDictionary *navBarTintColorDict = [navBarDict objectForKey:@"NavigationBarTintColor"];
    NSNumber* Red = [navBarTintColorDict objectForKey:@"Red"];
    NSNumber* Green = [navBarTintColorDict objectForKey:@"Green"];
    NSNumber* Blue = [navBarTintColorDict objectForKey:@"Blue"];
    NSNumber* Alpha = [navBarTintColorDict objectForKey:@"Alpha"];
    self.globalUIEntitlement.navigationBarEntitlement.tintColor = [UIColor colorWithIntRGB:[Red integerValue] green:[Green integerValue] blue:[Blue integerValue] alpha:[Alpha integerValue]];
}

// 解释SearchBarEntitlement
-(void)parsingSearchBarEntitlement:(NSDictionary*)dict
{
    if (nil == self.globalUIEntitlement.searchBarEntitlement){
        self.globalUIEntitlement.searchBarEntitlement = [[[SearchBarEntitlement alloc] init] autorelease];
    }
    
    NSDictionary *searchBarDict = [dict objectForKey:@"SearchBar"];
    
    // 解释SearchBarTintColor
    {
        NSDictionary *searchBarTintColorDict = [searchBarDict objectForKey:@"SearchBarTintColor"];
        NSNumber* Red = [searchBarTintColorDict objectForKey:@"Red"];
        NSNumber* Green = [searchBarTintColorDict objectForKey:@"Green"];
        NSNumber* Blue = [searchBarTintColorDict objectForKey:@"Blue"];
        NSNumber* Alpha = [searchBarTintColorDict objectForKey:@"Alpha"];
        self.globalUIEntitlement.searchBarEntitlement.searchBarTintColor = [UIColor colorWithIntRGB:[Red integerValue] green:[Green integerValue] blue:[Blue integerValue] alpha:[Alpha integerValue]];
    }
        
    // 解释SectionBackgroundColor
    {
        NSDictionary *sectionBackgroundColor = [searchBarDict objectForKey:@"SectionBackgroundColor"];
        NSNumber* Red = [sectionBackgroundColor objectForKey:@"Red"];
        NSNumber* Green = [sectionBackgroundColor objectForKey:@"Green"];
        NSNumber* Blue = [sectionBackgroundColor objectForKey:@"Blue"];
        NSNumber* Alpha = [sectionBackgroundColor objectForKey:@"Alpha"];
        self.globalUIEntitlement.searchBarEntitlement.sectionBackgroundColor = [UIColor colorWithIntRGB:[Red integerValue] green:[Green integerValue] blue:[Blue integerValue] alpha:[Alpha integerValue]];
    }
    
    // 解释SectionFontColor
    {
        NSDictionary* sectionFontColor = [searchBarDict objectForKey:@"SectionFontColor"];
        NSNumber* red = [sectionFontColor objectForKey:@"Red"];
        NSNumber* green = [sectionFontColor objectForKey:@"Green"];
        NSNumber* blue = [sectionFontColor objectForKey:@"Blue"];
        NSNumber* alpha = [sectionFontColor objectForKey:@"Alpha"];
        self.globalUIEntitlement.searchBarEntitlement.sectionFontColor = [UIColor colorWithIntRGB:[red integerValue] green:[green integerValue] blue:[blue integerValue] alpha:[alpha integerValue]];
    }
}

// TODO:解释BaseViewEntitlement
-(void)parsingBaseViewControllerEntitlement:(NSDictionary*)dict {
    id color = [dict objectForKey:@"BaseViewControllerBackgroundColor"];
    if(nil != color && color != [NSNull null] && [color isKindOfClass:[NSString class]]) {
        self.globalUIEntitlement.baseViewControllerBackgroundColor = [UIColor colorWithHexString:color];
    }

}
// TODO:解释EGOEntitlement
-(void)parsingEGOColorEntitlement:(NSDictionary*)dict {
    id color = [dict objectForKey:@"EGORefreshTableHeaderViewColor"];
    if(nil != color && color != [NSNull null] && [color isKindOfClass:[NSString class]]) {
        self.globalUIEntitlement.egoRefreshTableHeaderViewColor = [UIColor colorWithHexString:color];
    }
}

#pragma mark - 解释CalendarEntitlement
-(void)parsingCalendarEntitlement:(NSDictionary*)dict
{
    if (nil == self.calendarEntitlement){
        self.calendarEntitlement = [[[CalendarEntitlement alloc] init] autorelease];
    }
    NSDictionary *calendarModuleDict = [dict objectForKey:@"CalendarModule"];
    
    // 解释 DatePickerTintColor
    NSDictionary *datePickerTintColorDict = [calendarModuleDict objectForKey:@"DatePickerTintColor"];
    NSNumber* Red = [datePickerTintColorDict objectForKey:@"Red"];
    NSNumber* Green = [datePickerTintColorDict objectForKey:@"Green"];
    NSNumber* Blue = [datePickerTintColorDict objectForKey:@"Blue"];
    NSNumber* Alpha = [datePickerTintColorDict objectForKey:@"Alpha"];
    self.calendarEntitlement.datePickerTintColor = [UIColor colorWithIntRGB:[Red integerValue] green:[Green integerValue] blue:[Blue integerValue] alpha:[Alpha integerValue]];
}

#pragma mark - 解释ShareEntitlement
-(void)parsingShareEntitlement:(NSDictionary*)dict
{
    if (nil == self.shareEntitlement){
        self.shareEntitlement = [[[ShareEntitlement alloc] init] autorelease];
    }
    NSArray *shares = [dict objectForKey:@"shares"];

    // 解释每个share
    NSMutableArray  *shareItems = [NSMutableArray array];
    for (NSDictionary *shareItemDict in shares){
        ShareItemEntitlement *shareItemEntitlement = [[[ShareItemEntitlement alloc] init] autorelease];
//        shareItemEntitlement.name = ShareTitle([shareItemDict objectForKey:@"name"]);
        shareItemEntitlement.type = [shareItemDict objectForKey:@"type"];
        shareItemEntitlement.show = [[shareItemDict objectForKey:@"show"] boolValue];
        shareItemEntitlement.url = [shareItemDict objectForKey:@"url"];
        shareItemEntitlement.appKey = [shareItemDict objectForKey:@"appkey"];
        shareItemEntitlement.logo = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:[shareItemDict objectForKey:@"logo"]]];
        [shareItems addObject:shareItemEntitlement];
    }
    self.shareEntitlement.shares = shareItems;
}

#pragma mark - +function
+ (NSString*)appVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleVersion"];
}

#pragma mark - 修改 Enviroment.plist
- (void)setSchoolKey:(NSString*)schoolKey
{
    self.clientEntitlement.schoolKey = schoolKey;
    
    NSString *realPath = [ResourceManager pathForResource:@"Enviroment" ofType:@"plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
    NSMutableDictionary *client = [dict objectForKey:@"ClientEntitlement"];
    [client setObject:schoolKey forKey:@"SchoolKey"];
    [dict writeToFile:realPath atomically:YES];
}

- (void)setDefaultSchoolKey
{
    NSString *realPath = [NSString stringWithFormat:@"%@/%@", [ResourceManager defaultResourcePath], @"Enviroment.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
    NSMutableDictionary *client = [dict objectForKey:@"ClientEntitlement"];
    [self setSchoolKey:[client objectForKey:@"SchoolKey"]];
}
@end
