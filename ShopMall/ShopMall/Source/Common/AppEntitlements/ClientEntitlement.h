//
//  ClientEntitlement.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-21.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientEntitlement : NSObject{
@private
    NSString*   _centerDomain;
    NSString*   _schoolKey;
    //NSString*   _iTunesId;
}
@property (nonatomic, retain) NSString* centerDomain;
@property (nonatomic, retain) NSString* schoolKey;
//@property (nonatomic, retain) NSString* iTunesId;
@end
