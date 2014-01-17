//
//  RequestOperator.h
//  DrPalm
//
//  Created by KingsleyYau on 12-11-20.
//  Copyright (c) 2012年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
// 公共协议
#import "CommonRequestDefine.h"
#import "CommonRequestLanguageDef.h"
// Http发送类
#import "HttpClient.h"
// Json解析类
#import "MITJSON.h"
@protocol RequestOperatorDelegate <NSObject>
- (void)requestFinish:(id)data;
- (void)requestFail:(NSString*)error;
@end
@interface RequestOperator : NSObject <HttpClientDelegate>{
    dispatch_queue_t _requestQueue;
}
@property (nonatomic, retain) HttpClient *httpClient;
@property (nonatomic, retain) id paramOperation;
@property (nonatomic, assign) id<RequestOperatorDelegate> delegate;
// 取消上次请求
- (void)cancel;
// 发送Get请求
- (BOOL)sendSingleGet:(NSString *)urlPath paramDict:(NSDictionary *)paramNewDict;
// 发送Post请求
//- (BOOL)sendSinglePost:(NSString *)urlPath body:(NSData *)body;
- (BOOL)sendSinglePost:(NSString *)urlPath paramArray:(NSArray *)paramArray;
// 判断请求是否成功
- (BOOL)isParsingOpretSuccess:(id)data errorCode:(NSMutableString *)errorCode;
// - (BOOL)isParsingOpretSuccess:(id)data error:(NSMutableString*)error;

// 组建参数
- (HttpClientPostBody *)buildPostParam:(NSString*)paramName content:(NSString*)content;
- (HttpClientPostBody *)buildFilePostParam:(NSString*)paramName contentType:(NSString*)contentType data:(NSData*)data fileName:(NSString*)fileName;
//- (NSString*)buildPostParam:(NSString*)paramName content:(NSString*)content;
//- (NSData*)buildFilePostParam:(NSString*)paramName contentType:(NSString*)contentType data:(NSData*)data fileName:(NSString*)fileName;
@end
