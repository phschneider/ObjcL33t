//
//  PSImprintViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 03.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSImprintViewController.h"

@interface PSImprintViewController ()

@end

@implementation PSImprintViewController

@synthesize webView = _webView;

- (id) init
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    self = [super init];
    if (self)
    {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
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
    
    NSLog(@"Location = %@", [NSLocale currentLocale]);
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *language = [languages objectAtIndex:0];
    NSLog(@"Language = %@", language);
    
    NSString * resource;
    
    if ([[language uppercaseString] isEqualToString:@"DE"])
    {
        resource = @"Imprint";
    }
    else
    {
        resource = @"Imprint";
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:resource ofType:@"html"] isDirectory:NO]]];
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

@end
