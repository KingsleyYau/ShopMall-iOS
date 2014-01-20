//
//  MAOfflineCity.h
//
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    MAOfflineCityStatusNone = 0,    /* 不存在. */
    MAOfflineCityStatusCached,      /* 缓存状态. */
    MAOfflineCityStatusInstalled,   /* 已安装. */
    MAOfflineCityStatusExpired      /* 已过期. */
}MAOfflineCityStatus;

@interface MAOfflineCity : NSObject<NSCoding>

/*!
 @brief 城市编码
 */
@property (nonatomic, copy, readonly) NSString *cityCode;

/*!
 @brief 城市名称
 */
@property (nonatomic, copy, readonly) NSString *cityName;

/*!
 @brief 下载地址
 */
@property (nonatomic, copy, readonly) NSString *urlString;

/*!
 @brief 数据包大小
 */
@property (nonatomic, assign, readonly) long long size;

/*!
 @brief 离线数据状态
 */
@property (nonatomic, assign, readonly) MAOfflineCityStatus status;

/*!
 @brief 表示已缓存离线数据的大小(单位Byte), 当status == MAOfflineCityStatusCached 有效
 */
@property (nonatomic, assign, readonly) long long downloadedSize;

@end
