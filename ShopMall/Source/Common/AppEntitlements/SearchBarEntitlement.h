//
//  SearchBarEntitlement.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-22.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchBarEntitlement : NSObject{
@private
    UIColor*    _searchBarTintColor;
    UIColor*    _sectionBackgroundColor;
    UIColor*    _sectionFontColor;
}
@property (nonatomic, retain) UIColor*  searchBarTintColor;
@property (nonatomic, retain) UIColor*  sectionBackgroundColor;
@property (nonatomic, retain) UIColor*  sectionFontColor;
@end
