#import "MITMailComposeController.h"

@implementation MITMailComposeController

+ (void)presentMailControllerWithEmail:(UIViewController *)vc email:(NSString *)email subject:(NSString *)subject body:(NSString *)body isHtml:(BOOL)isHtml
{
	//Class mailClass = [MFMailComposeViewController class];//(NSClassFromString(@"MFMailComposeViewController"));
	if ([MFMailComposeViewController canSendMail]) {
		
		MFMailComposeViewController *aController = [[[MFMailComposeViewController alloc] init] autorelease];
		aController.mailComposeDelegate = [[MITMailComposeController alloc] init];//(id<MFMailComposeViewControllerDelegate>)aController;// releases self when dismissed

		if (email != nil) {
            NSArray *toRecipient = [NSArray arrayWithObject:email]; 
            [aController setToRecipients:toRecipient];
        }
        if (subject != nil) {
            [aController setSubject:subject];
        }
        if (body != nil) {
            [aController setMessageBody:body isHTML:isHtml];
        }
		
        [vc presentModalViewController:aController animated:YES];
        
	} else {
        NSMutableArray *array = [NSMutableArray array];
        if (subject != nil) {
            [array addObject:[NSString stringWithFormat:@"&subject=%@", [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        }
        if (body != nil) {
             [array addObject:[NSString stringWithFormat:@"&body=%@", [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        }
        NSString *urlString = [NSString stringWithFormat:@"mailto:%@?%@",
                               (email != nil ? email : @""),
                               [array componentsJoinedByString:@"&"]];
        
		NSURL *externURL = [NSURL URLWithString:urlString];
		if ([[UIApplication sharedApplication] canOpenURL:externURL])
			[[UIApplication sharedApplication] openURL:externURL];
	}
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[controller dismissModalViewControllerAnimated:YES];
    [self release];
}

@end
