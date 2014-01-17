//
//  UpdateAppManager.m
//  DrPalm
//
//  Created by Kingsley on 12-11-6.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "UpdateAppManager.h"
#import "UpdateAppRequest.h"

#define UPDATEINFO_DIRECTORY    @"UpdateVersion"
#define UPDATEINFO_PLIST        @"UpdateVersionInfo"

@interface UpdateAppManager () <UpdateAppRequestDelegate>{
    
}
@property (nonatomic, retain) UpdateAppRequest *updateAppRequest;

- (void)cancel;
- (BOOL)isNewVersion:(NSString *)newVersion;
@end

@implementation UpdateAppManager
@synthesize updateAppRequest;
@synthesize delegate;

- (void)dealloc {
    [self cancel];
    [super dealloc];
}
- (void)cancel {
    self.updateAppRequest = nil;
}
- (void)updateApp {
    [self cancel];
    self.updateAppRequest = [[[UpdateAppRequest alloc] init] autorelease];
    self.updateAppRequest.delegate = self;
    [updateAppRequest sendUpdateRequest];
}
- (BOOL)isNewVersion:(NSString *)newVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *curVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSArray *curArray = [curVersion componentsSeparatedByString:@"."];
    NSArray *newArray = [newVersion componentsSeparatedByString:@"."];
    // 从前面开始,比较相同位置的版本号,其中一个比当前新则返回真
    NSInteger arrayCount = MIN([curArray count], [newArray count]);
    for(int i = 0; i< arrayCount; i++) {
        if([[newArray objectAtIndex:i] integerValue] > [[curArray objectAtIndex:i] integerValue]) {
            return YES;
        }
        else if([[newArray objectAtIndex:i] integerValue] < [[curArray objectAtIndex:i] integerValue]){
            return NO;
        }
    }
    // 前面的版本号都相等,则当新版本号比当前版本号长返回真
    return ([newArray count] > [curArray count]?YES:NO);
}

#pragma mark - UpdateVersionInfoFunction
- (NSString*)updateVersionInfoPath
{
    // 创建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], UPDATEINFO_DIRECTORY]  withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], UPDATEINFO_DIRECTORY, UPDATEINFO_PLIST, @"plist"];
    
    return path;
}
- (BOOL)isBanned:(NSString *)newVersion {
    NSString *path = [self updateVersionInfoPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    id isBanned = [dict objectForKey:newVersion];
    return [isBanned boolValue];
}
- (BOOL)setUpdateVersionInfoBanned:(NSString *)version {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *path = [self updateVersionInfoPath];
    [dict addEntriesFromDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:path]];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:version];
    return [dict writeToFile:path atomically:YES];
}

#pragma mark - UpdateAppRequestDelegate
- (void)updateFinish:(NSString *)url version:(NSString *)version notes:(NSString *)notes {
    // 是新版本,并且不再提示的文件中没有纪录该版本
    if([self isNewVersion:version] && ![self isBanned:version])
    {
        if(delegate) {
            if([(id)delegate respondsToSelector:@selector(updateFinish:version:notes:)]){
                [(id)delegate updateFinish:url version:version notes:notes];
            }
        }
    }
}
- (void)updateFail:(NSString*)error {
    
}
@end
