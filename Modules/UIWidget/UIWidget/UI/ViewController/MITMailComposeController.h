#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import "MFMailComposeViewController+RFC2368.h"
// TODO: add protocol for classes to do things after the controller is dismissed

@interface MITMailComposeController : NSObject <MFMailComposeViewControllerDelegate> {

}

+ (void)presentMailControllerWithEmail:(UIViewController *)vc email:(NSString *)email subject:(NSString *)subject body:(NSString *)body isHtml:(BOOL)isHtml;

@end
