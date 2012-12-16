//
//  PSWikiViewController.h
//  leetspeak
//
//  Created by Philip Schneider on 02.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "GAITrackedViewController.h"
#import <UIKit/UIKit.h>

@interface PSWikiViewController : GAITrackedViewController <UIWebViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end
