//
//  ResourceManager.h
//  DrPalm
//
//  Created by fgx_lion on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject
// 获取程序默认资源路径
+ (NSString*)defaultResourcePath;
// 获取程序使用的资源路径
+ (NSString*)resourcePath;
+ (NSString*)resourceFilePath:(NSString*)filePath;
+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext;
+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

// 判断资源目录是否存在
+ (BOOL)isResourcePathExist;
// 复制默认资源到使用资源目录
+ (BOOL)copyDefaultResourceToResourcePath;
// 创建目录
+ (BOOL)createDir:(NSString*)path;
// 删除目录及其子文件
+ (BOOL)removeDir:(NSString*)path;
@end
