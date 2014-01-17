//
//  BadgeImageView.h
//  DrPalm
//
//  Created by drcom on 13-3-29.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeImageView : UIImageView {
    NSString *badgeValue;
}
@property (nonatomic, retain) NSString *badgeValue;
@end
