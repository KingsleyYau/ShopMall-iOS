//
//  KKListItemSelector.h
//  ShopMall
//
//  Created by KingsleyYau on 13-3-27.
//  Copyright (c) 2013年 DrCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKListItemSelector;
@protocol KKListItemSelectorDelegete <NSObject>
@optional
- (void)didPressRefresh:(KKListItemSelector *)kkListItemSelector;
- (void)didPressPre:(KKListItemSelector *)kkListItemSelector;
- (void)didPressNext:(KKListItemSelector *)kkListItemSelector;
@end
@interface KKListItemSelector : UIView {
    UIButton *_buttonRefresh;
    
    UILabel *_labelText;
    UIButton *_buttonPre;
    UIButton *_buttonNext;
}
@property (nonatomic, assign) id<KKListItemSelectorDelegete> delegate;
@property (nonatomic, readonly) UIButton *buttonRefresh;
@property (nonatomic, readonly) UILabel *labelText;
@property (nonatomic, readonly) UIButton *buttonPre;
@property (nonatomic, readonly) UIButton *buttonNext;
@end
