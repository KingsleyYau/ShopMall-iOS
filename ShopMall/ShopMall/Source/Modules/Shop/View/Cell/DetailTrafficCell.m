//
//  DetailTrafficCell.m
//  DrPalm4EBaby
//
//  Created by KingsleyYau on 13-9-5.
//  Copyright (c) 2013年 KingsleyYau. All rights reserved.
//

#import "DetailTrafficCell.h"

@implementation DetailTrafficCell
#pragma mark - UIWebView模板
+ (NSString *)htmlStringFromString:(NSString *)source {
	NSURL *baseURL = [NSURL fileURLWithPath:[ResourceManager resourcePath] isDirectory:YES];
	NSURL *fileURL = [NSURL URLWithString:@"template/body-default.html" relativeToURL:baseURL];
	NSError *error;
	NSMutableString *target = [NSMutableString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
	if (!target) {
		NSLog(@"Failed to load template at %@. %@", fileURL, [error userInfo]);
	}
    
    //    NSString *maxWidth = [NSString stringWithFormat:@"%.0f", _webViewBody.frame.size.width - 2 * WEB_VIEW_PADDING];
    //    [target replaceOccurrencesOfString:@"__WIDTH__" withString:maxWidth options:NSLiteralSearch range:NSMakeRange(0, target.length)];
    NSString *body = @"";
    if(source.length > 0) {
        body = source;
    }
	[target replaceOccurrencesOfStrings:[NSArray arrayWithObject:@"__BODY__"]
							withStrings:[NSArray arrayWithObject:body]
								options:NSLiteralSearch];
    
	return target;
}
+ (NSString *)cellIdentifier {
    return @"DetailTrafficCell";
}
+ (NSInteger)cellHeight {
    return 44;
}
+ (NSInteger)cellHeight:(UITableView *)tableView titleString:(NSString *)titleString webViewHeight:(NSInteger)webViewHeight {
    NSInteger height = 23;
    if(titleString.length > 0) {
        height += [titleString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.frame.size.width * 0.9375, MAXFLOAT)
                               lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    height += webViewHeight;
    return height;
}
+ (id)getUITableViewCell:(UITableView*)tableView {
    DetailTrafficCell *cell = (DetailTrafficCell *)[tableView dequeueReusableCellWithIdentifier:[DetailTrafficCell cellIdentifier]];
    if (nil == cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamedWithFamily:[DetailTrafficCell cellIdentifier] owner:tableView options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titleLabel.text = @"";
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    
    NSInteger curIndexY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + BLANKING_Y;
    
    self.webView.frame = CGRectMake(self.webView.frame.origin.x, curIndexY, self.webView.frame.size.width, self.webView.frame.size.height);
}
@end
