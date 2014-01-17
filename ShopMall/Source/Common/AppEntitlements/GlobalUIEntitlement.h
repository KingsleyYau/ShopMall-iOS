//
//  GlobalUIEntitlement.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-22.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigationBarEntitlement.h"
#import "SearchBarEntitlement.h"

@interface GlobalUIEntitlement : NSObject{
@private
    NavigationBarEntitlement*   _navigationBarEntitlement;
    SearchBarEntitlement*       _searchBarEntitlement;
    UIColor*                    _baseViewControllerBackgroundColor;
    UIColor*                    _egoRefreshTableHeaderViewColor;
}
@property (nonatomic, retain) NavigationBarEntitlement* navigationBarEntitlement;
@property (nonatomic, retain) SearchBarEntitlement*     searchBarEntitlement;
@property (nonatomic, retain) UIColor*                  baseViewControllerBackgroundColor;
@property (nonatomic, retain) UIColor*                  egoRefreshTableHeaderViewColor;
@end
