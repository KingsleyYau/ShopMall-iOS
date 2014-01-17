//
//  UIStatusView.h
//  DrPalm
//
//  Created by fgx_lion on 12-4-11.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStatusView : UIView
{
    UIImageView*    _backgroundView;
    UILabel*        _textLabel;
    NSMutableDictionary*    _msgKeyDictionary;
    NSMutableArray* _msgArray;
    NSTimer*        _timer;
    NSTimer*        _fastTimer;
    NSInteger       _height;
}

-(BOOL)addMessage:(NSString*)key message:(NSString*)message;
-(BOOL)addMessage:(NSString*)key message:(NSString*)message displayTimes:(NSInteger)displayTimes;
-(NSInteger)height;

@end
