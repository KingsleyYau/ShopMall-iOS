//
//  WebViewController.m
//  DrPalm
//
//  Created by fgx_lion on 12-3-6.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController() 
@property (nonatomic, retain) UIActivityIndicatorView   *activityIndicatorView;
@end

@implementation WebViewController
@synthesize webPath = _webPath;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _webPath = nil;
        _activityIndicatorView = nil;
    }
    return self;
}

- (void)dealloc
{
    self.webPath = nil;
    self.activityIndicatorView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // set WebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    // set URL
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webPath]]];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [webView release];
    
//    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _activityIndicatorView.hidesWhenStopped = YES;
////    _activityIndicatorView.hidden = YES;
//    _activityIndicatorView.center = self.view.center;
//    [self.view addSubview:_activityIndicatorView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.activityIndicatorView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    return YES;    
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
////    _activityIndicatorView.hidden = NO;
////    [_activityIndicatorView startAnimating];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
////    [_activityIndicatorView stopAnimating];
////    _activityIndicatorView.hidden = YES;
//}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [_activityIndicatorView stopAnimating];
//    _activityIndicatorView.hidden = YES;
    
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
    [alterview release];
}

@end
