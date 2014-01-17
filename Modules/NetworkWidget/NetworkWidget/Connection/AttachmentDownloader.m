//
//  AttachmentDownloader.m
//  DrPalm
//
//  Created by fgx_lion on 12-4-27.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "AttachmentDownloader.h"

@interface AttachmentDownloader()
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@end

@implementation AttachmentDownloader
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

- (BOOL)startDownload:(NSString*)url  delegate:(id<AttachmentDownloaderDelegate>)delegate
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
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	if (nil != self.urlConnection
        && nil != self.delegate
        && [self.delegate respondsToSelector:@selector(attachmentDownloader:downloadFinish:contentType:)]){
        [self.urlConnection cancel];
        self.urlConnection = nil;
        [self.delegate attachmentDownloader:self downloadFinish:_data contentType:self.contentType];
    }
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error 
{
	if (nil != self.urlConnection
        && nil != self.delegate
        && [self.delegate respondsToSelector:@selector(attachmentDownloader:downloadFail:)]){
        [self.urlConnection cancel];
        self.urlConnection = nil;
        [self.delegate attachmentDownloader:self downloadFail:error];
    }
}
@end
