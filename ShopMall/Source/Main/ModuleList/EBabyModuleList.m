#import "EBabyModuleList.h"

#import "ShopModule.h"
#import "ShopNewsModule.h"
#import "MemberModule.h"
#import "MoreModule.h"

@interface EBabyModuleList () {
    
}
@property (nonatomic, strong) NSArray *items;
@end

@implementation EBabyModuleList
@dynamic modules;
- (NSArray *)createModules {
    // The order of this array is the default module order
    NSMutableArray *moduleArray = [NSMutableArray array];
    EBabyModule *module;

    module = [[ShopModule alloc] init];
    [moduleArray addObject:module];
    
    module = [[ShopNewsModule alloc] init];
    [moduleArray addObject:module];
    
    module = [[MemberModule alloc] init];
    [moduleArray addObject:module];

    
    module = [[MoreModule alloc] init];
    [moduleArray addObject:module];

    return moduleArray;
}
- (NSArray *)modules {
    if(!self.items) {
        self.items = [self createModules];
    }
    return self.items;
}
- (EBabyModule *)moduleForTabBarItem:(UITabBarItem *)aItem {
    for (EBabyModule *aModule in self.modules) {
        if ([aModule.viewController.tabBarItem isEqual:aItem]) {
            return aModule;
        }
    }
    return nil;
}
@end
