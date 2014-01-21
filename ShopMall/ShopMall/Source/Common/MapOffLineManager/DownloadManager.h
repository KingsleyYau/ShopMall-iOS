//
//  DownloadManager.h
//  DrPalm
//
//  Created by fgx_lion on 12-5-15.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadManager;
@protocol DownloadManagerDelegate <NSObject>
@optional
- (void)downloadManager:(DownloadManager*)downloadManager downloadFinish:(NSData*)data contentType:(NSString*)contentType;
- (void)downloadManager:(DownloadManager *)downloadManager downloadFail:(NSError*)error;
- (void)downloadManager:(DownloadManager*)downloadManager downloadProcess:(NSInteger)processed total:(NSInteger)total;
@end

@interface DownloadManager : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData   *_data;
    NSString        *_contentType;
    NSInteger       _contentLength;
    NSURLConnection *_urlConnection;
    NSString        *_url;
    id<DownloadManagerDelegate>    _delegate;
}

@property (nonatomic, assign) id<DownloadManagerDelegate>   delegate;
@property (nonatomic, readonly) NSString    *url;

- (BOOL)startDownload:(NSString*)url delegate:(id<DownloadManagerDelegate>)delegate;
- (BOOL)stopDownload;
@end
