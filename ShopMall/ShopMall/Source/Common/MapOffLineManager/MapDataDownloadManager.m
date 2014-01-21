//
//  MapDataDownloadManager.m
//  ShopMall
//
//  Created by KingsleyYau on 13-7-22.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "MapDataDownloadManager.h"
#import "DownloadManager.h"
#import "ZipArchive.h"


#define MapDataUrl @"http://mapdownload.autonavi.com/mobilemap/mapdatav3/20130705/GangAo.zip"
#define MapZipPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MapZip"]
#define MapUnZipPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/3dvmap"]

#define MapGangAo @"GangAo.zip"

@interface MapDataDownloadManager () <DownloadManagerDelegate> {
    
}
@property (nonatomic, retain) DownloadManager *downloadManager;
@property (nonatomic, retain) NSString *curDownloadFile;
@property (nonatomic, retain) NSString *unZipFilePath;

- (BOOL)unZipMapData;
@end

@implementation MapDataDownloadManager
- (id)init {
    self = [super init];
    if(self) {
        self.curDownloadFile = [NSString stringWithFormat:@"%@/%@", MapZipPath, MapGangAo];
        self.unZipFilePath = MapUnZipPath;
        
        // 创建目录
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL bFlag = [fileManager createDirectoryAtPath:MapZipPath withIntermediateDirectories:YES attributes:nil error:nil];
        bFlag = [fileManager createDirectoryAtPath:self.unZipFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return self;
}
- (void)dealloc {
    [self stopDownload];
    self.curDownloadFile = nil;
    [super dealloc];
}
- (BOOL)unZipMapData {
    BOOL bFlag = NO;
    ZipArchive* zip = [[[ZipArchive alloc] init] autorelease];
    if ([zip UnzipOpenFile:self.curDownloadFile]){
        bFlag = [zip UnzipFileTo:self.unZipFilePath overWrite:YES];
        [zip UnzipCloseFile];
    }
    
    return bFlag;
}

- (BOOL)isDownloadAlready {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.curDownloadFile];
}
- (BOOL)startDownload {
    if(!self.downloadManager) {
        self.downloadManager = [[[DownloadManager alloc] init] autorelease];
    }
    if([self isDownloadAlready]) {
        if ([self.delegate respondsToSelector:@selector(downloadFinish:)]){
            [self.delegate downloadFinish:self];
        }
        return YES;
    }
    else {
        return [self.downloadManager startDownload:MapDataUrl delegate:self];
    }
}
- (void)stopDownload
{
    [self.downloadManager stopDownload];
    self.downloadManager = nil;
}

#pragma mark 下载回调 (DownloadManagerDelegate)
- (void)downloadManager:(DownloadManager *)downloadManager downloadFinish:(NSData *)data contentType:(NSString*)contentType {

    // 保存zip
    BOOL bFlag = [data writeToFile:self.curDownloadFile atomically:YES];
    if(bFlag) {
        NSLog(@"保存离线地图成功%@", self.curDownloadFile);
        
        // 解压zip
        bFlag = [self unZipMapData];
        if(bFlag) {
            NSLog(@"解压离线地图成功%@", self.curDownloadFile);
            
            if ([self.delegate respondsToSelector:@selector(downloadFinish:)]){
                [self.delegate downloadFinish:self];
            }
        }
        else {
            NSLog(@"解压离线地图失败%@", self.curDownloadFile);
            
            if ([self.delegate respondsToSelector:@selector(downloadFail:error:)]){
                [self.delegate downloadFail:self error:@"解压离线地图失败"];
            }
        }
    }
    else {
        NSLog(@"保存离线地图失败%@", self.curDownloadFile);
    }
}
- (void)downloadManager:(DownloadManager *)downloadManager downloadFail:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(downloadFail:error:)]){
        [self.delegate downloadFail:self error:[error description]];
    }
}
- (void)downloadManager:(DownloadManager *)downloadManager downloadProcess:(NSInteger)processed total:(NSInteger)total {
    if ([self.delegate respondsToSelector:@selector(downloadProcess:processed:total:)]){
        [self.delegate downloadProcess:self processed:processed total:total];
    }
}
@end
