//
//  MyNotifyView.m
//  InfoAlertDemo
//
//  Created by JiangBo on 13-8-16.
//  Copyright (c) 2013年 Drcom. All rights reserved.
//

#import "MyNotifyView.h"

@implementation MyNotifyView


// 画出圆角矩形背景
static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect),
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (id)initWithFrame:(CGRect)frame  text:(NSString*)text{
    CGRect viewR = CGRectMake(0, 0, frame.size.width+2*X_BLANKING, frame.size.height+2*Y_BLANKING);
    self = [super initWithFrame:viewR];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bgColor = [[UIColor darkGrayColor] CGColor];
        _text = [[NSString alloc] initWithString:text];
        _fontSize = frame.size;
    }
    return self;
}

-(void)dealloc
{
    [_text release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 背景0.8透明度
    CGContextSetAlpha(context, .8);
    addRoundedRectToPath(context, rect, 4.0f, 4.0f);
    CGContextSetFillColorWithColor(context, _bgColor);
    CGContextFillPath(context);
    
    // 文字1.0透明度
    CGContextSetAlpha(context, 1.0);
    CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 1, [[UIColor whiteColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    float x = (rect.size.width - _fontSize.width) / 2.0;
    float y = (rect.size.height - _fontSize.height) / 2.0;
    CGRect r = CGRectMake(x, y, _fontSize.width, _fontSize.height);
    [_text drawInRect:r withFont:[UIFont systemFontOfSize:Default_Font] lineBreakMode:NSLineBreakByTruncatingTail];
}

// 从上层视图移除并释放
- (void)remove{
    [self removeFromSuperview];
}

// 渐变消失
- (void)fadeAway{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5f];
    self.alpha = .0;
    [UIView commitAnimations];
    [self performSelector:@selector(remove) withObject:nil afterDelay:1.5f];
}

+(void)showText:(NSString *)text  inView:(UIView *)view vertical:(float)height delay:(float)delay
{
    height = height < 0 ? 0 : height > 1 ? 1 : height;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:Default_Font]
                   constrainedToSize:View_MaxSize];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    MyNotifyView* notifyView = [[MyNotifyView alloc] initWithFrame:frame text:text];
    notifyView.center = CGPointMake(view.center.x, view.frame.size.height*height);
    notifyView.alpha = 0;
    [view addSubview:notifyView];
    [notifyView release];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    notifyView.alpha = 1.0;
    [UIView commitAnimations];
    [notifyView performSelector:@selector(fadeAway) withObject:nil afterDelay:delay];
}


@end
