//
// Created by pschneider on 10.11.13.
//
// Copyright (c) 2013 Haus & Gross communications. All rights reserved.
//

#import "PSUserDefaults.h"
#import "PSWizzardManager.h"
#import "PSWizzardViewController.h"

@interface PSWizzardManager ()

@property (nonatomic) BOOL wizzardStarted;
@property (nonatomic, strong) PSWizzardViewController * wizzardViewController;

@end

@implementation PSWizzardManager

static PSWizzardManager * instance = nil;

+ (PSWizzardManager*) sharedInstance
{
    DLogFuncName();
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [PSWizzardManager new];
        }
    }
    return instance;
}

- (id) init
{
    DLogFuncName();
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideWizzard) name:NOTIFICATION_WIZZARD_HIDE object:nil];

    }
    return self;
}


#pragma mark - Helper
- (BOOL) showsWizzard
{
    DLogFuncName();
    return self.wizzardStarted;
}


#pragma mark - Wizzard
- (void) showWizzard
{
    DLogFuncName();
    self.wizzardViewController = nil;
    self.wizzardStarted = YES;

    self.wizzardViewController = [[PSWizzardViewController alloc] init];
    [APPDELEGATE.window.rootViewController.view addSubview:self.wizzardViewController.view];
    [self.wizzardViewController viewDidAppear:YES];

    [[PSUserDefaults sharedPSUserDefaults] wizzaredStarted];
}


- (void) hideWizzard
{
    [[PSUserDefaults sharedPSUserDefaults] wizzardFinished];

    // Teste des Cristercism
//    [NSException raise:NSInvalidArgumentException
//                format:@"Foo must not be nil"];

    [UIView animateWithDuration:1.0
                     animations:^{
                         self.wizzardViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self.wizzardViewController.view removeFromSuperview];
                         //                                    self.wizzardViewController = nil;
                         self.wizzardStarted = NO;
                         [APPDELEGATE.tabBarController.view layoutSubviews];
                     }];

}

@end