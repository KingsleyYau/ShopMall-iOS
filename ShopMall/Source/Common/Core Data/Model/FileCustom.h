//
//  ShopFileCustom.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-18.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

#define FILE_TYPE_URL           0
#define FILE_TYPE_LOCALPATH     1

@interface File (Custom)
- (void)updateWithFileUrl:(NSString *)url isLocal:(Boolean)isLocal;
@end
