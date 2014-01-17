//
//  KKButtonBar.h
//  DrPalm
//
//  Created by KingsleyYau on 13-2-20.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKButtonBar;
@protocol KKButtonBarDelegete <NSObject>
@optional
- (void)itemsDidLayout:(KKButtonBar *)kkButtonBar;
@end
@interface KKButtonBar : UIView {
    
}
@property (nonatomic, assign) IBOutlet id<KKButtonBarDelegete> delegate;
@property (nonatomic, copy)   NSArray   *items;
@property (nonatomic, assign) CGFloat blanking;
@property (nonatomic, assign) BOOL isVertical;

- (void)setItems:(NSArray *)items animated:(BOOL)animated;   // will fade in or out or reorder and adjust spacing
- (void)setBackgroundImage:(UIImage *)backgroundImage;
@end
