//
//  DynamicContainView.m
//  DrPalm
//
//  Created by KingsleyYau on 13-1-21.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import "DynamicContainView.h"

#import "CustomUIView.h"
#import "ResourceManager.h"
#import "../ImageDefine.h"

#define BUTTON_SIZE 44
@interface DynamicContainView () {
    BOOL _isDown;
    BOOL _isClose;

    CGRect orgFrame;
    CGRect orgButtonFrame;
    CGRect orgPithyFrame;
    CGRect orgDetailFrame;
    UIButton *_showButton;
}

@property (nonatomic, retain) UIView *detailView;
@property (nonatomic, retain) UIView *pithyView;

@end
           
@implementation DynamicContainView
@synthesize delegate;
@synthesize detailView;
@synthesize pithyView;
@synthesize showButton = _showButton;
@synthesize isDown = _isDown;
- (void)dealloc {
    self.detailView = nil;
    self.pithyView = nil;
    [super dealloc];
}
- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    
    if(!_showButton) {
        // 添加按钮
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_showButton];
        NSInteger buttonSize = MAX(0 ,self.frame.size.height - 10);
        CGRect buttonFrame = CGRectMake(self.frame.size.width - buttonSize, 5, buttonSize, buttonSize);
        _showButton.frame = buttonFrame;
        [_showButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _showButton.contentMode = UIViewContentModeScaleAspectFit;
        
    }

    orgFrame = self.frame;
    orgButtonFrame = _showButton.frame;
//    if(_isDown) {
//        // 下拉收起
//        [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewDownArrowImage]] forState:UIControlStateNormal];
//    }
//    else {
//        // 上拉收起
//        [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewUpArrowImage]] forState:UIControlStateNormal];
//    }
//    [self reLoadView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _isAnimating = NO;
    _isClose = YES;
    _isDown = YES;
    [self initialize];
}
- (id)initWithFrame:(CGRect)frame isDown:(BOOL)Down {
    self = [super initWithFrame:frame];
    if (self) {
        _isAnimating = NO;
        _isClose = YES;
        _isDown = YES;
//        _isAnimating = NO;
//        _isClose = YES;
//        _isDown = Down;
//        self.backgroundColor = [UIColor clearColor];
//        // 添加按钮
//        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self addSubview:_showButton];
//        NSInteger buttonSize = MAX(0 ,frame.size.height - 10);
//        CGRect buttonFrame = CGRectMake(frame.size.width - buttonSize, 5, buttonSize, buttonSize);
//        _showButton.frame = buttonFrame;
//        [_showButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        _showButton.contentMode = UIViewContentModeScaleAspectFit;
//        
//        orgFrame = frame;
//        orgButtonFrame = _showButton.frame;
//        if(_isDown) {
//            // 下拉收起
//            [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewDownArrowImage]] forState:UIControlStateNormal];
//        }
//        else {
//            // 上拉收起
//            [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewUpArrowImage]] forState:UIControlStateNormal];
//        }
        self.isDown = Down;
        [self initialize];
        [self reLoadView];
    }
    return self;
}
- (void)reLoadView {
//    if(self.isAnimating) {
//        return;
//    }
    if(_isDown) {
        // 下拉收起
        [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewDownArrowImage]] forState:UIControlStateNormal];
    }
    else {
        // 上拉收起
        [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewUpArrowImage]] forState:UIControlStateNormal];
    }
    
    self.frame = orgFrame;
    _showButton.frame = orgButtonFrame;
    NSInteger buttonSize = MAX(0 ,self.frame.size.height - 10);
    CGRect pithyFrame = CGRectMake(0, 0, self.frame.size.width - buttonSize, self.frame.size.height);
    if([self.delegate respondsToSelector:@selector(dynamicContainView:viewForPithy:wholeFrame:)]){
        [self.pithyView removeFromSuperview];
        self.pithyView = [delegate dynamicContainView:self viewForPithy:pithyFrame wholeFrame:self.frame];
        if(self.pithyView) {
            self.pithyView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            orgPithyFrame = self.pithyView.frame;
            [self addSubview:self.pithyView];
            [self bringSubviewToFront:_showButton];
        }
    }
    // 详细界面
    if([self.delegate respondsToSelector:@selector(viewForDetail:)]){
        [self.detailView removeFromSuperview];
        self.detailView = [self.delegate viewForDetail:self];
        if(self.detailView) {
            if(_isDown) {
                // 向下展开
                self.detailView.frame = CGRectMake(0, -self.detailView.frame.size.height, self.detailView.frame.size.width, detailView.frame.size.height);
            }
            else {
                // 向上展开
                self.detailView.frame = CGRectMake(0, self.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height);
            }
            orgDetailFrame = self.detailView.frame;
            self.detailView.alpha = 0.0;
            [self addSubview:self.detailView];
            [self bringSubviewToFront:self.detailView];
//            // 原先已经打开
//            [self show:NO];

        }
    }

}
- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark － 界面（Action）
- (void)buttonAction:(id)sender {
    if(_isClose) {
        [self show:YES];
    }
    else {
        [self hide:YES];
    }
}
#pragma mark － 收起
- (void)hide:(BOOL)animated{
    if(_isClose || _isAnimating)
        return;
    _isClose = YES;
    if(_isDown) {
        // 下拉收起
        [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewDownArrowImage]] forState:UIControlStateNormal];
    }
    else {
        // 上拉收起
        [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewUpArrowImage]] forState:UIControlStateNormal];
    }
    if(!detailView) {
        return;
    }
    CGFloat duration = 0.0;
    // 是否显示动画
    if(animated) {
        _showButton.enabled = NO;
        duration = MAX(0.5 * fabs(detailView.frame.size.height) / 88, 0.5);
        [UIView animateWithDuration:duration animations:^{
            _isAnimating = YES;
            //CGRect newFrame = orgFrame;
            //动画的内容
            if(_isDown) {
                // 向上收起
                detailView.frame = CGRectMake(0, -detailView.frame.size.height, detailView.frame.size.width, detailView.frame.size.height);
                pithyView.frame = CGRectMake(pithyView.frame.origin.x, 0, pithyView.frame.size.width, pithyView.frame.size.height);
                _showButton.frame = CGRectMake(_showButton.frame.origin.x, _showButton.frame.origin.y - detailView.frame.size.height, _showButton.frame.size.width, _showButton.frame.size.height);
            }
            else {
                // 向下收起
                self.frame = orgFrame;
            }
            //self.frame = orgFrame;
            detailView.alpha = 0.0;

            //动画结束
        } completion:^(BOOL finished) {
            if(_isDown) {
                // 向上收起
                self.frame = orgFrame;
                pithyView.frame = orgPithyFrame;
                detailView.frame = orgDetailFrame;
                _showButton.frame = orgButtonFrame;
            }
            else {
                // 向下收起
                self.frame = orgFrame;
            }
            _isAnimating = NO;
            _showButton.enabled = YES;
        }];
    }
    else {
        //动画的内容
        if(_isDown) {
            // 向上收起
            detailView.frame = CGRectMake(0, -detailView.frame.size.height, detailView.frame.size.width, detailView.frame.size.height);
        }
        else {
            // 向下收起
            detailView.frame = CGRectMake(0, orgFrame.size.height, detailView.frame.size.width, detailView.frame.size.height);
        }
        self.frame = orgFrame;
        detailView.alpha = 0.0;
    }
    if([delegate respondsToSelector:@selector(didHideDynamicContainView:boundsSize:duration:)]) {
        [delegate didHideDynamicContainView:self boundsSize:CGSizeMake(detailView.frame.size.width, detailView.frame.size.height) duration:duration];
    }
}
- (void)show:(BOOL)animated{
    if(!_isClose || _isAnimating)
        return;
    _isClose = NO;
    if(_isDown) {
        // 下拉展开
        [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewUpArrowImage]] forState:UIControlStateNormal];
    }
    else {
        // 上拉展开
        [_showButton setImage:[UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:DynamicContainViewDownArrowImage]] forState:UIControlStateNormal];
    }
    // 记录原始大小
    //orgFrame = self.frame;
    CGRect newFrame = orgFrame;
    
    // 详细界面
    if(detailView) {
    }
    else {
        // 没有详细直接返回
        return;
    }

    CGFloat duration = 0.0;
    // 是否显示动画
    if(animated) {
        _showButton.enabled = NO;
        duration = MAX(0.5 * fabs(detailView.frame.size.height) / 88, 0.5);
        [UIView animateWithDuration:duration animations:^{
            _isAnimating = YES;
            // 整个view移动
            CGRect newFrame = orgFrame;
            //动画的内容
            if(_isDown) {
                // 向下展开
                newFrame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y + detailView.frame.size.height, orgFrame.size.width, orgFrame.size.height);
            }
            else {
                // 向上展开
                newFrame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y - detailView.frame.size.height, orgFrame.size.width, orgFrame.size.height);
            }
            self.frame = newFrame;
            detailView.alpha = 1.0;
            //动画结束
        } completion:^(BOOL finished) {
            // 改变view大小,重新计算子view位置
            if(_isDown) {
                // 向下展开
                self.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y, orgFrame.size.width, orgFrame.size.height + detailView.frame.size.height);
                detailView.frame = CGRectMake(0, 0, detailView.frame.size.width, detailView.frame.size.height);
                pithyView.frame = CGRectMake(pithyView.frame.origin.x, detailView.frame.size.height, pithyView.frame.size.width, pithyView.frame.size.height);
                _showButton.frame = CGRectMake(_showButton.frame.origin.x, _showButton.frame.origin.y + detailView.frame.size.height, _showButton.frame.size.width, _showButton.frame.size.height);
            }
            else {
                // 向上展开
                self.frame = CGRectMake(orgFrame.origin.x, self.frame.origin.y, orgFrame.size.width, orgFrame.size.height + detailView.frame.size.height);
            }
            _isAnimating = NO;
            _showButton.enabled = YES;
        }];
    }
    else {
        if(_isDown) {
            // 向下展开
            newFrame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y + detailView.frame.size.height, orgFrame.size.width, orgFrame.size.height);
        }
        else {
            // 向上展开
            newFrame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y - detailView.frame.size.height, orgFrame.size.width, orgFrame.size.height);
        }
        self.frame = newFrame;
        detailView.alpha = 1.0;
    }
    if([delegate respondsToSelector:@selector(didShowDynamicContainView:boundsSize:duration:)]) {
        [delegate didShowDynamicContainView:self boundsSize:CGSizeMake(detailView.frame.size.width, detailView.frame.size.height) duration:duration];
    }
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
