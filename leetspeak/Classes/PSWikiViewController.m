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
        self.title = NSLocalizedString(@"Wiki TabBar Title",nil);
        self.tabBarItem.image = [UIImage imageNamed:@"white-42-info"];

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
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    DLog(@"Location = %@", [NSLocale currentLocale]);
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *language = [languages objectAtIndex:0];
    DLog(@"Language = %@", language);

    NSString * resource;
    NSString * request;
    if ([[language uppercaseString] isEqualToString:@"DE"])
    {
        resource = @"DE-Leetspeak–Wikipedia";
        request = @"http://de.wikipedia.org/wiki/Leetspeak";
    }
    else
    {
        resource = @"EN-Leetspeak–Wikipedia";
        request = @"http://en.wikipedia.org/wiki/Leetspeak";
    }
    DLog(@"Resource = %@",resource);
    NSString * path = [[NSBundle mainBundle] pathForResource:resource ofType:@"webarchive"];
    DLog(@"Path = %@", path);
    if (path)
    {
        [[self navigationItem] setTitle:NSLocalizedString(@"Wikipedia Navigation Title",nil)];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path isDirectory:NO]]];
        [self.webView becomeFirstResponder];
    }
    else
    {
        [[self navigationItem] setTitle:NSLocalizedString(@"Wikipedia Navigation Title",nil)];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request]]];
        [self.webView becomeFirstResponder];
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    DLog(@"didFailLoadWithError %@",error);

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    DLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    DLog(@"webViewDidFinishLoad");
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
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
