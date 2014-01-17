#import "EBabyModule.h"
@implementation EBabyModule
#pragma mark -
- (NSString *)moduleName {
    return @"";
}
- (NSString *)iconName {
    return self.moduleName;
}
- (UIImage *)icon {
    UIImage *result = nil;
    if (self.iconName) {
        NSString *iconPath = [NSString stringWithFormat:@"%@%@", @"tab-", self.iconName];
        result = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:iconPath ofType:@"png"] ofType:@"png"];
    }
    return result;
}

- (UIImage *)tabBarIcon {
    UIImage *result = nil;
    if (self.iconName) {
        NSString *iconPath = [NSString stringWithFormat:@"%@%@", @"tab-", self.iconName];
        result = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:iconPath ofType:@"png"] ofType:@"png"];
    }
    return result;
}
- (UIImage *)tabBarUnSelectedIcon {
    UIImage *result = nil;
    if (self.iconName) {
        NSString *iconPath = [NSString stringWithFormat:@"%@%@%@", @"tab-", self.iconName, @"-unselected"];
        result = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:iconPath ofType:@"png"] ofType:@"png"];
    }
    return result;
}
- (UIImage *)tabBarSelectedIcon {
    UIImage *result = nil;
    if (self.iconName) {
        NSString *iconPath = [NSString stringWithFormat:@"%@%@%@", @"tab-", self.iconName, @"-selected"];
        result = [UIImage imageWithContentsOfFileLanguage:[[NSBundle mainBundle] pathForResource:iconPath ofType:@"png"] ofType:@"png"];
    }
    return result;
}
@end
