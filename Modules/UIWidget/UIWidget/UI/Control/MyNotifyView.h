//
//  MyNotifyView.h
//  InfoAlertDemo
//
//  Created by JiangBo on 13-8-16.
//  Copyright (c) 2013年 Drcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

  
#define Default_Font       14
#define View_MaxSize       CGSizeMake(200, 100)
#define X_BLANKING         10
#define Y_BLANKING         20

@interface MyNotifyView : UIView{
    CGColorRef   _bgColor;
    NSString     *_text;
    CGSize       _fontSize;
}

// text为提示信息，view是为消息框的superView, vertical 为垂直方向上出现的位置 从 取值 0 ~ 1。delay为View停留时间（单位/秒）
+(void)showText:(NSString *)text  inView:(UIView *)view vertical:(float)height delay:(float)delay;

@end
