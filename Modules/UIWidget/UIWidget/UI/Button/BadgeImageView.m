//
//  BadgeImageView.m
//  DrPalm
//
//  Created by drcom on 13-3-29.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "BadgeImageView.h"
#import "ResourceManager.h"
#import "../ImageDefine.h"

@implementation BadgeImageView
@synthesize badgeValue;

- (NSString *)badgeValue {
    return badgeValue;
}

#define BADGE_TAG 200
#define BADGE_LABEL_TAG 201
- (void)setBadgeValue:(NSString *)newValue {
    [badgeValue release];
    badgeValue = [newValue retain];
    
    UIView *badgeView = [self viewWithTag:BADGE_TAG];
    
    if (badgeValue) {
        UIFont *labelFont = [UIFont boldSystemFontOfSize:13.0f];
        
        if (!badgeView) {
            UIImage *image = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:BadgeButtonImage]];
            UIImage *stretchableImage = [image stretchableImageWithLeftCapWidth:floor(image.size.width / 2) - 1 topCapHeight:0];
            
            badgeView = [[[UIImageView alloc] initWithImage:stretchableImage] autorelease];
            badgeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
            badgeView.tag = BADGE_TAG;
            
            UILabel *badgeLabel = [[[UILabel alloc] initWithFrame:badgeView.frame] autorelease];
            badgeLabel.backgroundColor = [UIColor clearColor];
            badgeLabel.textColor = [UIColor whiteColor];
            badgeLabel.font = labelFont;
            badgeLabel.textAlignment = UITextAlignmentCenter;
            badgeLabel.tag = BADGE_LABEL_TAG;
            [badgeView addSubview:badgeLabel];
        }
        UILabel *badgeLabel = (UILabel *)[badgeView viewWithTag:BADGE_LABEL_TAG];
        CGSize size = [badgeValue sizeWithFont:labelFont];
        CGFloat padding = 7.0;
        CGRect frame = badgeView.frame;
        
        if (size.width + 2 * padding > frame.size.width) {
            // resize label for more digits
            frame.size.width = size.width;
            frame.origin.x += padding;
            badgeLabel.frame = frame;
            
            // resize bubble
            frame = badgeView.frame;
            frame.size.width = size.width + padding * 2;
            badgeView.frame = frame;
        }
        badgeLabel.text = badgeValue;
        
        // place badgeView on top right corner
        frame.origin = CGPointMake(self.frame.size.width - floor(badgeView.frame.size.width)+5,
                                   - floor(badgeView.frame.size.height / 2) + 5);
        badgeView.frame = frame;
        
        [self addSubview:badgeView];
    } else {
        [badgeView removeFromSuperview];
    }
}

- (void)dealloc {
    self.badgeValue = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
