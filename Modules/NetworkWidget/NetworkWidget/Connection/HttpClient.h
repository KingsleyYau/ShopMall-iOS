//
//  HttpRequest.h
//  DrPalm
//  
//  Created by Kingsley on 12-11-5.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define CONNECTION_ERROR @"Connection Error"
#define CONNECTION_ERROR NSLocalizedString(@"CONNECTION_ERROR", nil)
@protocol HttpClientDelegate <NSObject>
@optional
- (void)requestFinish:(id)data;
- (void)requestFail:(NSString*)error;
@end
@interface HttpClient : NSObject {
}
@property (nonatomic, assign) id<HttpClientDelegate> delegate;
- (void)cancel;
/* buildPostParam */
- (NSString*)buildPostParam:(NSString*)paramName content:(NSString*)content;
/* buildFilePostParam */
- (NSData*)buildFilePostParam:(NSString*)paramName contentType:(NSString*)contentType data:(NSData*)data fileName:(NSString*)fileName;
- (void)resetBoundary;
- (BOOL)sendSinglePost:(NSString *)urlString body:(NSData *)body;
- (BOOL)sendSingleGet:(NSString *)urlString paramDict:(NSDictionary *)paramDict;

@end

@interface HttpClientPostBody : NSObject{
    
}
@property (nonatomic, assign) BOOL isFile;
@property (nonatomic, retain) NSString *paramName;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *fileName;
@end
