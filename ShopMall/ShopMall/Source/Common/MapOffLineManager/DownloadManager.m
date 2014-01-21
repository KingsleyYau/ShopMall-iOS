//
//  DownloadManager.m
//  DrPalm
//
//  Created by fgx_lion on 12-5-15.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager()
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@end

@implementation DownloadManager
@synthesize delegate = _delegate;
@synthesize contentType = _contentType;
@synthesize urlConnection = _urlConnection;
@synthesize url = _url;

- (id)init
{
    self = [super init];
    if (nil != self){
        _data = [[NSMutableData data] retain];
        self.contentType = nil;
        _contentLength = 0;
        self.delegate = nil;
        self.urlConnection = nil;
        _url = nil;
    }
    return self;
}

- (void)dealloc
{
    [self stopDownload];
    self.delegate = nil;
    self.contentType = nil;
    
    [_data release];
    _data = nil;
    
    [super dealloc];
}

- (BOOL)startDownload:(NSString*)url  delegate:(id<DownloadManagerDelegate>)delegate
{
    BOOL result = NO;
    NSURL *requestUrl = [NSURL URLWithString:url];
    if (nil == self.urlConnection
        && nil != requestUrl){
        [_data setData:[NSData data]];
        self.contentType = nil;
        self.delegate = delegate;
        self.urlConnection = [[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:requestUrl] delegate:self] autorelease];
        _url = [url retain];
        result = (nil != self.urlConnection);
    }
    return result;
}

- (BOOL)stopDownload
{
    [self.urlConnection cancel];
    self.urlConnection = nil;
    [_url release];
    _url = nil;
    return YES;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	if ([response isKindOfClass:[NSHTTPURLResponse class]]){
        NSHTTPURLResponse *httpRespones = (NSHTTPURLResponse*)response;
        NSDictionary *dict = [httpRespones allHeaderFields];
        self.contentType = [dict objectForKey:@"Content-Type"];
        _contentLength = [[dict objectForKey:@"Content-Length"] integerValue];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[_data appendData:data];
    if (nil != self.urlConnection
        && [self.delegate respondsToSelector:@selector(downloadManager:downloadProcess:total:)]){
        [self.delegate downloadManager:self downloadProcess:[_data length] total:_contentLength];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	if (nil != self.urlConnection
        && [self.delegate respondsToSelector:@selector(downloadManager:downloadFinish:contentType:)]){
        [self.urlConnection cancel];
        self.urlConnection = nil;
        [self.delegate downloadManager:self downloadFinish:_data contentType:self.contentType];
    }
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error 
{
	if (nil != self.urlConnection
        && [self.delegate respondsToSelector:@selector(downloadManager:downloadFail:)]){
        [self.urlConnection cancel];
        self.urlConnection = nil;
        [self.delegate downloadManager:self downloadFail:error];
    }
}
@end
