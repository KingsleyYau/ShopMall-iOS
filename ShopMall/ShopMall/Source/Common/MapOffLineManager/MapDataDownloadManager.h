//
//  MapDataDownloadManager.h
//  ShopMall
//
//  Created by KingsleyYau on 13-7-22.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MapDataDownloadManager;
@protocol MapDownloadManagerDelegate <NSObject>
@optional
- (void)downloadFinish:(MapDataDownloadManager*)mapDownloadManager;
- (void)downloadFail:(MapDataDownloadManager*)mapDownloadManager error:(NSString*)error;
- (void)downloadProcess:(MapDataDownloadManager*)mapeDownloadManager processed:(NSInteger)processed total:(NSInteger)total;
@end

@interface MapDataDownloadManager : NSObject {

}
@property (nonatomic, assign) id<MapDownloadManagerDelegate> delegate;

- (BOOL)isDownloadAlready;
- (BOOL)startDownload;
- (void)stopDownload;
@end
