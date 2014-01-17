//
//  KKButton.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-26.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKImageButton : UIButton {
    UIImage *_kkImage;
    UIImage *kkSelectedImage;
}
@property (nonatomic, retain) UIImage *kkImage;
@property (nonatomic, retain) UIImage *kkSelectedImage;

- (void)setNeedSelectAction:(BOOL)needSelectAction;
- (void)setSelected:(BOOL)selected;
@end
