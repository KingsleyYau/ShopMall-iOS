//
//  UpdateAppManager.h
//  DrPalm
//
//  Created by Kingsley on 12-11-6.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateAppManagerDelegate <NSObject>
@optional
- (void)updateFinish:(NSString *)url version:(NSString *)version notes:(NSString *)notes;
@end

@interface UpdateAppManager : NSObject {
    
}
@property (nonatomic, assign) id<UpdateAppManagerDelegate> *delegate;
- (BOOL)setUpdateVersionInfoBanned:(NSString *)version;
- (void)updateApp;
@end
