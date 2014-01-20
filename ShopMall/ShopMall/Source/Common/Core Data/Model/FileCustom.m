//
//  ShopFileCustom.m
//  DrPalm
//
//  Created by KingsleyYau on 13-2-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "FileCustom.h"
@implementation File (Custom)
- (void)updateWithFileUrl:(NSString *)url isLocal:(Boolean)isLocal {
    if(nil != self.path && ![self.path isEqualToString:url]) {
        // 文件路径更新，清除旧数据
        self.data = nil;
        if(isLocal) {
            // 本地文件
            self.pathType = [NSNumber numberWithInt:FILE_TYPE_LOCALPATH];
        }
        else {
            // 网络文件
            self.pathType = [NSNumber numberWithInt:FILE_TYPE_URL];
        }
    }
    self.path = url;
}
@end
