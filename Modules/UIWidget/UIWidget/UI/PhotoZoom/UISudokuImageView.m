//
//  UISudokuImageView.m
//  
//
//  Created by fgx_lion on 13-2-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//  图片按九宫格拉伸

#import "UISudokuImageView.h"

@interface UISudokuImageView()
@property (nonatomic, retain) UIImage*  leftTopImage;
@property (nonatomic, retain) UIImage*  leftImage;
@property (nonatomic, retain) UIImage*  leftBottomImage;
@property (nonatomic, retain) UIImage*  topImage;
@property (nonatomic, retain) UIImage*  rightTopImage;
@property (nonatomic, retain) UIImage*  rightImage;
@property (nonatomic, retain) UIImage*  rightBottomImage;
@property (nonatomic, retain) UIImage*  bottomImage;
@property (nonatomic, retain) UIImage*  centerImage;

- (UIImage*)cutImageWithRect:(UIImage*)image rect:(CGRect)rect;

// 把目标大小转换为9宫格大小
- (CGRect)getLeftTopRect:(CGRect)desRect;
- (CGRect)getLeftRect:(CGRect)desRect;
- (CGRect)getLeftBottomRect:(CGRect)desRect;
- (CGRect)getTopRect:(CGRect)desRect;
- (CGRect)getRightTopRect:(CGRect)desRect;
- (CGRect)getRightRect:(CGRect)desRect;
- (CGRect)getRightBottomRect:(CGRect)desRect;
- (CGRect)getBottomRect:(CGRect)desRect;
- (CGRect)getCenterRect:(CGRect)desRect;
@end

@implementation UISudokuImageView
@synthesize leftTopImage = _leftTopImage;
@synthesize leftImage = _leftImage;
@synthesize leftBottomImage = _leftBottomImage;
@synthesize topImage = _topImage;
@synthesize rightTopImage = _rightTopImage;
@synthesize rightImage = _rightImage;
@synthesize rightBottomImage = _rightBottomImage;
@synthesize bottomImage = _bottomImage;
@synthesize centerImage = _centerImage;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        _sudokuLeftOffset = 0;
        _sudokuRightOffset = 0;
        _sudokuTopOffset = 0;
        _sudokuBottomOffset = 0;
        
        self.leftTopImage = nil;
        self.leftImage = nil;
        self.leftBottomImage = nil;
        self.topImage = nil;
        self.rightTopImage = nil;
        self.rightImage = nil;
        self.rightBottomImage = nil;
        self.bottomImage = nil;
        self.centerImage = nil;
    }
    return self;
}

- (void)dealloc
{
    self.leftTopImage = nil;
    self.leftImage = nil;
    self.leftBottomImage = nil;
    self.topImage = nil;
    self.rightTopImage = nil;
    self.rightImage = nil;
    self.rightBottomImage = nil;
    self.bottomImage = nil;
    self.centerImage = nil;
    [super dealloc];
}

- (void)setSudokuImage:(UIImage*)image left:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom
{
    CGSize imageSize = image.size;
    _sudokuLeftOffset = left;
    _sudokuRightOffset = right;//imageSize.width - right;
    _sudokuTopOffset = top;
    _sudokuBottomOffset = bottom;//imageSize.height - bottom;
    
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.leftTopImage = [self cutImageWithRect:image rect:[self getLeftTopRect:imageRect]];
    self.leftImage = [self cutImageWithRect:image rect:[self getLeftRect:imageRect]];
    self.leftBottomImage = [self cutImageWithRect:image rect:[self getLeftBottomRect:imageRect]];
    self.topImage = [self cutImageWithRect:image rect:[self getTopRect:imageRect]];
    self.rightTopImage = [self cutImageWithRect:image rect:[self getRightTopRect:imageRect]];
    self.rightImage = [self cutImageWithRect:image rect:[self getRightRect:imageRect]];
    self.rightBottomImage = [self cutImageWithRect:image rect:[self getRightBottomRect:imageRect]];
    self.bottomImage = [self cutImageWithRect:image rect:[self getBottomRect:imageRect]];
    self.centerImage = [self cutImageWithRect:image rect:[self getCenterRect:imageRect]];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setNeedsDisplay];
}

- (UIImage*)cutImageWithRect:(UIImage*)image rect:(CGRect)rect
{
    CGImageRef imageToSplit = image.CGImage;
    CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, rect);
    //CGImageRelease(imageToSplit);
    UIImage *partOfImage = [UIImage imageWithCGImage:partOfImageAsCG];
    CGImageRelease(partOfImageAsCG);
    return partOfImage;
}

- (void)drawRect:(CGRect)rect
{
    [self.leftTopImage drawAtPoint:CGPointMake(0, 0)];
    [self.leftImage drawInRect:[self getLeftRect:rect]];
    [self.leftBottomImage drawInRect:[self getLeftBottomRect:rect]];
    [self.topImage drawInRect:[self getTopRect:rect]];
    [self.rightTopImage drawInRect:[self getRightTopRect:rect]];
    [self.rightImage drawInRect:[self getRightRect:rect]];
    [self.rightBottomImage drawInRect:[self getRightBottomRect:rect]];
    [self.bottomImage drawInRect:[self getBottomRect:rect]];
    [self.centerImage drawInRect:[self getCenterRect:rect]];
}

#pragma mark - 目标大小转换为9宫格大小
// 左上角
- (CGRect)getLeftTopRect:(CGRect)desRect
{
    CGRect rect = CGRectMake(0, 0, _sudokuLeftOffset, _sudokuTopOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}

// 左侧
- (CGRect)getLeftRect:(CGRect)desRect
{
    CGRect rect =  CGRectMake(0, _sudokuTopOffset, _sudokuLeftOffset, desRect.size.height - _sudokuTopOffset - _sudokuBottomOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}

// 左下角
- (CGRect)getLeftBottomRect:(CGRect)desRect
{
    CGRect rect = CGRectMake(0, desRect.size.height - _sudokuBottomOffset, _sudokuLeftOffset, _sudokuBottomOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}

// 上侧
- (CGRect)getTopRect:(CGRect)desRect
{
    CGRect rect = CGRectMake(_sudokuLeftOffset, 0, desRect.size.width - _sudokuLeftOffset - _sudokuRightOffset, _sudokuTopOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}

// 右上角
- (CGRect)getRightTopRect:(CGRect)desRect
{
    CGRect rect = CGRectMake(desRect.size.width - _sudokuRightOffset, 0, _sudokuRightOffset, _sudokuTopOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}

// 右侧
- (CGRect)getRightRect:(CGRect)desRect
{
    CGRect rect = CGRectMake(desRect.size.width - _sudokuRightOffset, _sudokuTopOffset, _sudokuRightOffset, desRect.size.height - _sudokuTopOffset - _sudokuBottomOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}

// 右下角
- (CGRect)getRightBottomRect:(CGRect)desRect
{
    CGRect rect = CGRectMake(desRect.size.width - _sudokuRightOffset, desRect.size.height - _sudokuTopOffset, _sudokuRightOffset, _sudokuBottomOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}

// 下侧
- (CGRect)getBottomRect:(CGRect)desRect
{
    CGRect rect = CGRectMake(_sudokuLeftOffset, desRect.size.height - _sudokuBottomOffset, desRect.size.width - _sudokuLeftOffset - _sudokuRightOffset, _sudokuBottomOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}

// 中间
- (CGRect)getCenterRect:(CGRect)desRect
{
    CGRect rect = CGRectMake(_sudokuLeftOffset, _sudokuTopOffset, desRect.size.width - _sudokuLeftOffset - _sudokuRightOffset, desRect.size.height - _sudokuTopOffset - _sudokuBottomOffset);
    rect.origin.x += desRect.origin.x;
    rect.origin.y += desRect.origin.y;
    return rect;
}
@end
