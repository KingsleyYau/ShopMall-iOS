//
//  BadgeButton.h
//  DrPalm
//
//  Created by KingsleyYau on 13-1-8.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeButton : UIButton {
    NSString *badgeValue;
}
@property (nonatomic, retain) NSString *badgeValue;
@end
