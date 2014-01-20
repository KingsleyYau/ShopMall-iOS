#import <Foundation/Foundation.h>

@interface EBabyModule : NSObject {
}
#pragma mark - 模块名字
@property (nonatomic, readonly) NSString *moduleName;

#pragma mark - 界面控制器
@property (nonatomic, readonly) UIViewController *viewController;

#pragma mark - 图标
@property (nonatomic, readonly) NSString *iconName;
@property (nonatomic, readonly) UIImage *icon;        // 更多 (color)
@property (nonatomic, readonly) UIImage *tabBarIcon;  // 系统风格(上图下文字)(black and white)
@property (nonatomic, readonly) UIImage *tabBarUnSelectedIcon;  // 自定义风格未选中
@property (nonatomic, readonly) UIImage *tabBarSelectedIcon;    // 自定义风格选中

@end
