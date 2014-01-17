//
//  UISudokuImageView.h
//  
//
//  Created by fgx_lion on 13-2-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//  图片按九宫格拉伸

#import <UIKit/UIKit.h>

@interface UISudokuImageView : UIView
{
    CGFloat _sudokuLeftOffset;          // 左边框偏移
    CGFloat _sudokuRightOffset;         // 右边框偏移
    CGFloat _sudokuTopOffset;           // 上边框偏移
    CGFloat _sudokuBottomOffset;        // 下边框偏移
    UIImage*    _leftTopImage;
    UIImage*    _leftImage;
    UIImage*    _leftBottomImage;
    UIImage*    _topImage;
    UIImage*    _rightTopImage;
    UIImage*    _rightImage;
    UIImage*    _rightBottomImage;
    UIImage*    _bottomImage;
    UIImage*    _centerImage;
}

- (void)setSudokuImage:(UIImage*)image left:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom;
@end
