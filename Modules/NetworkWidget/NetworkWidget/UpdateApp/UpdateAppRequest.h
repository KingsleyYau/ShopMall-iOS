//
//  UpdateAppRequest.h
//  DrPalm
//
//  Created by Kingsley on 12-11-5.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateAppRequestDelegate <NSObject>
@optional
- (void)updateFinish:(NSString *)url version:(NSString *)version notes:(NSString *)notes;
- (void)updateFail:(NSString*)error;
@end

@interface UpdateAppRequest : NSObject {
    
}
@property (nonatomic, assign) id<UpdateAppRequestDelegate> delegate;
- (BOOL)sendUpdateRequest;
@end
