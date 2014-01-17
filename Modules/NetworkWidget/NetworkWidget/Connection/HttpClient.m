//
//  HttpRequest.m
//  DrPalm
//
//  Created by Kingsley on 12-11-5.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "HttpClient.h"

#define REQUEST_METHOD_POST @"POST"
#define REQUEST_METHOD_GET  @"GET"
#define TIMEOUT_INTERVAL	15.0




@interface HttpClient () {
}
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSString *boundary;
@property (nonatomic, retain) NSMutableData *resultData;
- (void)cancel;

@end

@implementation HttpClient
@synthesize connection;
@synthesize boundary;
@synthesize resultData;
@synthesize delegate;

#pragma mark - PrivateFunction
- (id)init {
    self = [super init];
    if(self) {
        self.delegate = nil;
        [self cancel];
    }
    return self;
}
- (void)cancel
{
    [self.connection cancel];
    self.connection = nil;
    self.resultData = nil;
    [self resetBoundary];
}
- (void)dealloc {
    [self cancel];
    self.delegate = nil;
    self.boundary = nil;
    [super dealloc];
}

#pragma mark - PostFunction
#define ReturnString    @"\r\n"
- (NSString*)buildPostParam:(NSString*)paramName content:(NSString*)content
{
    NSMutableString *postString = [NSMutableString string];
    [postString appendFormat:@"--%@%@", self.boundary, ReturnString];
    [postString appendFormat:@"Content-Disposition: form-data; name=\"%@\"%@%@", paramName, ReturnString, ReturnString];
    [postString appendFormat:@"%@%@", content, ReturnString];
    return postString;
}

- (NSData*)buildFilePostParam:(NSString*)paramName contentType:(NSString*)contentType data:(NSData*)data fileName:(NSString*)fileName
{
    NSMutableData *paramData = [NSMutableData data];
    NSMutableString *postString = [NSMutableString string];
    [postString appendFormat:@"--%@%@", self.boundary, ReturnString];
    [postString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"%@", paramName, fileName, ReturnString];
    [postString appendFormat:@"Content-Transfer-Encoding: binary%@", ReturnString];
    [postString appendFormat:@"Content-Type: %@%@%@", contentType, ReturnString, ReturnString];
    [paramData appendData:[postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    [paramData appendData:data];
    [paramData appendData:[ReturnString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    return paramData;
}

- (void)resetBoundary {
    NSString *defineBoundary = [NSString stringWithFormat:@"--iosDrPalmHttpClient_%X", (NSInteger)[[NSDate date] timeIntervalSince1970]];
    self.boundary = defineBoundary;
}
- (BOOL)sendSinglePost:(NSString *)urlString body:(NSData *)body{
    //[self cancel];
    // build url
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // bulid request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:REQUEST_METHOD_POST];
    // bulid header
    NSString *theContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
    [request setValue:theContentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset"];
    // body end
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:body];
    [postBody appendData:[[NSString stringWithFormat:@"--%@--%@", boundary, ReturnString] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    // bulid body
    [request setHTTPBody:postBody];
    // bulid connection
    self.resultData = [NSMutableData data];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    return nil != self.connection;
}
#pragma mark - GetFunction
- (BOOL)sendSingleGet:(NSString *)urlString paramDict:(NSDictionary *)paramDict {
    // build url string
    NSMutableString *wholeUrlString = [NSMutableString stringWithString:urlString];
    // add param to url string
    if(nil != paramDict && [paramDict count] > 0){
        NSArray *keyArray = [paramDict allKeys];
        NSMutableArray *components = [NSMutableArray arrayWithCapacity:[keyArray count]];
        for(NSString *key in keyArray) {
            NSString *value = [[paramDict objectForKey:key] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            [components addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        NSString *paramString = [components componentsJoinedByString:@"&"];
        [wholeUrlString appendFormat:@"?%@", paramString, nil];
    }
    // build url 
    NSURL *url = [NSURL URLWithString:[wholeUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // bulid request
    NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;//(shouldCache) ? NSURLRequestReturnCacheDataElseLoad : NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    
    NSLog(@"Get method:\r%@", url, nil);
	NSURLRequest *request = [NSURLRequest requestWithURL:	url
											 cachePolicy:	cachePolicy	// Make sure not to cache in case of update for URL
										 timeoutInterval:	TIMEOUT_INTERVAL];
    
    if(![NSURLConnection canHandleRequest:request]) {
        return NO;
    }
    self.resultData = [NSMutableData data];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    return nil != self.connection;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    //    NSHTTPURLResponse * httpResponse;
    //    httpResponse = (NSHTTPURLResponse *) response;
    //    NSInteger status = httpResponse.statusCode;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    [self.resultData appendData:data];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self cancel];
    if(nil != self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestFail:)]){
            [self.delegate requestFail:CONNECTION_ERROR];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    if(nil != self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestFinish:)]){
                    [self.delegate requestFinish:self.resultData];
        }
    }
    [self cancel];
}

@end

@implementation HttpClientPostBody {
    
}
@synthesize isFile;
@synthesize paramName;
@synthesize content;
@synthesize contentType;
@synthesize data;
@synthesize fileName;
- (id)init {
    if(self = [super init]) {
        self.isFile = NO;
        self.paramName = @"";
        self.content = @"";
        self.contentType = @"";
        self.data = [NSData data];
        self.fileName = @"";
    }
    return self;
}
- (void)dealloc {
    self.paramName = nil;
    self.content = nil;
    self.contentType = nil;
    self.data = nil;
    self.fileName = nil;
    [super dealloc];
}
@end