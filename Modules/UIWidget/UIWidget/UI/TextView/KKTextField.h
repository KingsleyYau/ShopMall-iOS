//
//  KKTextField.h
//  ShopMall
//
//  Created by KingsleyYau on 13-4-14.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKTextField;
@protocol KKTextFieldDelegate <NSObject>
@optional
- (void)textFieldDoneInput:(KKTextField *)kkTextField;
//- (void)textFieldDidChange:(KKTextField *)kkTextField;
@end

@interface KKTextField : UITextField {
    UILabel *_tipsLabel;
}
@property (nonatomic, assign) id<KKTextFieldDelegate> kkTextFieldDelegate;
@property (nonatomic, assign) UILabel *tipsLabel;
@end
