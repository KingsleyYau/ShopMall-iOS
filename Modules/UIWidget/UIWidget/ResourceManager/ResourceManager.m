//
//  ResourceManager.m
//  DrPalm
//
//  Created by fgx_lion on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"

#define DefaultResourcePath [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Resource"]
//#define ResourcePath        [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DrPalm"]
#define ResourcePath        DefaultResourcePath
#define DefaultPacketFilename   @"packet.zip"

@implementation ResourceManager
+ (NSString*)defaultResourcePath
{
    return DefaultResourcePath;
}

+ (NSString*)resourcePath
{
    return ResourcePath;
}

+ (NSString*)resourceFilePath:(NSString*)filePath
{
    NSString *path = nil;
    if ([@"/" isEqualToString:[filePath substringWithRange:NSMakeRange(0, 1)]]
        || [@"\\" isEqualToString:[filePath substringWithRange:NSMakeRange(0, 1)]]){
        path = [NSString stringWithFormat:@"%@%@", ResourcePath, filePath];
    }
    else{
        path = [NSString stringWithFormat:@"%@/%@", ResourcePath, filePath];
    }
    return path;
}

+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext
{
    return [NSString stringWithFormat:@"%@/%@.%@", ResourcePath, name, ext];
}

+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath
{
    return [NSString stringWithFormat:@"%@/%@/%@.%@", ResourcePath, subpath, name, ext];
}

// 判断资源目录是否存在
+ (BOOL)isResourcePathExist
{
    return [[NSFileManager defaultManager] fileExistsAtPath:ResourcePath];
}
// 复制默认资源到使用资源目录
+ (BOOL)copyDefaultResourceToResourcePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = NO;
    
    // 创建目录
    success = [fileManager createDirectoryAtPath:ResourcePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    // copy资源
    NSArray* subPaths = [fileManager contentsOfDirectoryAtPath:DefaultResourcePath error:nil];
    for (NSString* subPath in subPaths) {
        NSString* srcPath = [NSString stringWithFormat:@"%@/%@", DefaultResourcePath, subPath];
        NSString* dstPath = [NSString stringWithFormat:@"%@/%@", ResourcePath, subPath];
        
        if([fileManager fileExistsAtPath:dstPath]) {
            [fileManager removeItemAtPath:dstPath error:nil];
        }
        success &= [fileManager copyItemAtPath:srcPath toPath:dstPath error:nil];
        
        if (!success){
            break;
        }
    }
    
    return success;
}
+ (BOOL)createDir:(NSString*)path {
    BOOL success = YES;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        success = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return success;
}
+ (BOOL)removeDir:(NSString*)path
{
    BOOL success = YES;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        success = [fileManager removeItemAtPath:path error:nil];
    }
    return success;
}
@end
