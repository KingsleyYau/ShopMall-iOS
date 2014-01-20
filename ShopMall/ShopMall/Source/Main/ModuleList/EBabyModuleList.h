#import <Foundation/Foundation.h>
#import "EBabyModule.h"
@interface EBabyModuleList : NSObject {
    
}
@property (nonatomic, readonly) NSArray *modules;
- (EBabyModule *)moduleForTabBarItem:(UITabBarItem *)aItem;
@end
