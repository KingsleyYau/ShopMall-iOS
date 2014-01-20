//
//  NavigationBarEntitlement.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-20.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationBarEntitlement : NSObject 
{
@private
    BOOL        _isShowImage;
    UIImage*    _titleImage;
    NSString*   _titleString;
    UIColor*    _tintColor;
}

@property (nonatomic, assign) BOOL      isShowImage;
@property (nonatomic, retain) UIImage*  titleImage;
@property (nonatomic, retain) NSString* titleString;
@property (nonatomic, retain) UIColor*  tintColor;
@end
