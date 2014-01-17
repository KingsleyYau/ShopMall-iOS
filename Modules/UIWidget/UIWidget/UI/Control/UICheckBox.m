//
//  UICheckBox.m
//  DrPalm
//
//  Created by JiangBo on 13-2-22.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "UICheckBox.h"
#import "ResourceManager.h"
#import "../ImageDefine.h"
#define CONTROLHEIGHT 30
#define LABELWIDTH 100

@implementation UICheckBox

@synthesize label;
@synthesize icon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];        
    }
    return self;
}
- (void)initialize {
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CONTROLHEIGHT, CONTROLHEIGHT)];
    [self setChecked:NO];
    [self addSubview:icon];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(CONTROLHEIGHT+10, 0, LABELWIDTH, CONTROLHEIGHT)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}
-(void)clicked
{
    [self setChecked:!checked];
    if([self.delegate respondsToSelector:@selector(checkBoxChange:checked:)]) {
        [self.delegate checkBoxChange:self checked:self.isChecked];
    }
}



-(BOOL)isChecked
{
    return checked;
}

-(void)setChecked:(BOOL)flag
{
    checked = flag;
    
    UIImage* imgChecked = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:CheckBoxChecked]];
    UIImage* imgUnChecked = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:CheckBoxUnChecked]];
    
    if(checked)
       [icon setImage:imgChecked];
    else
        [icon setImage:imgUnChecked];
        
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
