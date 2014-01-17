//
//  UICheckBox.h
//  DrPalm
//
//  Created by JiangBo on 13-2-22.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UICheckBox;
@protocol UICheckBoxDelegate <NSObject>
@optional
- (void)checkBoxChange:(UICheckBox *)checkBox checked:(BOOL)checked;
@end

@interface UICheckBox : UIControl
{
    UILabel*    label;
    UIImageView* icon;
    BOOL  checked;
}

@property (nonatomic,retain) UILabel* label;
@property (nonatomic,retain) UIImageView* icon;
@property (nonatomic, assign) IBOutlet id <UICheckBoxDelegate> delegate;

-(BOOL)isChecked;
-(void)setChecked:(BOOL)flag;
@end
