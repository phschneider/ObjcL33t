//
//  PSWikiViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 02.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSWikiViewController.h"

@interface PSWikiViewController ()

@end

@implementation PSWikiViewController

@synthesize webView = _webView;

- (id) init
{
    self = [super init];
    if (self)
    {
        self.trackedViewName = @"Wiki Screen";
        self.title = NSLocalizedString(@"Wiki TabBar Title",nil);
        self.tabBarItem.image = [UIImage imageNamed:@"white-42-info"];

        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.scalesPageToFit = YES;
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.webView];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    DLog(@"Location = %@", [NSLocale currentLocale]);
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *language = [languages objectAtIndex:0];
    DLog(@"Language = %@", language);

    NSString * resource;
    
    if ([[language uppercaseString] isEqualToString:@"DE"])
    {
        resource = @"DE-Leetspeak–Wikipedia";
    }
    else
    {
        resource = @"EN-Leetspeak–Wikipedia";
    }
    
    [[self navigationItem] setTitle:NSLocalizedString(@"Wikipedia Navigation Title",nil)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:resource ofType:@"webarchive"] isDirectory:NO]]];
    [self.webView becomeFirstResponder];
}

- (BOOL) shouldAutorotate
{
    DLogFuncName();
    return (!IS_IPHONE);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    DLogFuncName();
    return (!IS_IPHONE);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    DLog(@"didFailLoadWithError %@",error);

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    DLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    DLog(@"webViewDidFinishLoad");
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLogFuncName();
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLogFuncName();
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLogFuncName();    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLogFuncName();
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLogFuncName();
}

@end
