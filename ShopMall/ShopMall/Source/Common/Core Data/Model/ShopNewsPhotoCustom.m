//
//  ShopNewsPhotoCustom.m
//  ShopMall
//
//  Created by KingsleyYau on 13-4-15.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "ShopNewsPhotoCustom.h"
#import "CommonRequestDefine.h"
#import "ShopDataManager.h"
@implementation ShopNewsPhoto(Custom)
- (void)updateWithDict:(NSDictionary *)dict {
    id foundValue = nil;
    foundValue = [dict objectForKey:ShopNewsDetailPhoto];
    if(nil != foundValue && [NSNull null] != foundValue && [foundValue isKindOfClass:[NSString class]]) {
        File *file = [ShopDataManager fileWithUrl:foundValue isLocal:NO];
        self.image = file;
    }
}
@end
