//
//  ShareEntitlement.h
//  DrPalm
//
//  Created by fgx_lion on 12-5-29.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareItemEntitlement : NSObject{
    BOOL _show;
    NSString *_name;
    NSString *_type;
    NSString *_url;
    NSString *_appKey;
    UIImage *_logo;

}
@property (nonatomic, retain) NSString  *name;
@property (nonatomic, retain) NSString  *type;
@property (nonatomic, assign) BOOL  show;
@property (nonatomic, retain) NSString  *url;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) UIImage *logo;
@end

@interface ShareEntitlement : NSObject{
    NSArray *_shares;
}
@property (nonatomic, retain) NSArray   *shares;
@end
