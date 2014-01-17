//
//  KKTextView.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-15.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKTextView;
@protocol KKTextViewDelegate <NSObject>
@optional
- (void)textViewDoneInput:(KKTextView *)kkTextView;
@end
@interface KKTextView : UITextView {
    UILabel *_tipsLabel;
}
@property (nonatomic, assign) IBOutlet id<KKTextViewDelegate> kkTextViewDelegate;
@property (nonatomic, assign) UILabel *tipsLabel;
@end
