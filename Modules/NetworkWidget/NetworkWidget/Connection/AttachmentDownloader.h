//
//  AttachmentDownloader.h
//  DrPalm
//
//  Created by fgx_lion on 12-4-27.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AttachmentDownloader;
@protocol AttachmentDownloaderDelegate <NSObject>
@optional
- (void)attachmentDownloader:(AttachmentDownloader*)attachmentDownloader downloadFinish:(NSData*)data contentType:(NSString*)contentType;
- (void)attachmentDownloader:(AttachmentDownloader *)attachmentDownloader downloadFail:(NSError*)error;
@end

@interface AttachmentDownloader : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData   *_data;
    NSString        *_contentType;
    NSURLConnection *_urlConnection;
    NSString        *_url;
    id<AttachmentDownloaderDelegate>    _delegate;
}

@property (nonatomic, retain) id<AttachmentDownloaderDelegate>  delegate;
@property (nonatomic, readonly) NSString    *url;

- (BOOL)startDownload:(NSString*)url delegate:(id<AttachmentDownloaderDelegate>)delegate;
- (BOOL)stopDownload;
@end
