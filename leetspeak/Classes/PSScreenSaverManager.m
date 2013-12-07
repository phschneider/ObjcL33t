//
//  PSScreenSaverManager.m
//  leetspeak
//
//  Created by Philip Schneider on 10.11.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSWizzardManager.h"

#import "PSScreenSaverManager.h"
#import "PSScreenSaverViewController.h"

@interface PSScreenSaverManager()

@property (nonatomic) int number;
@property (nonatomic) BOOL screenSaverStarted;
@property (nonatomic, strong) NSTimer * screenSaverTimer;
@property (nonatomic, strong) PSScreenSaverViewController * screenSaverViewController;

@end

@implementation PSScreenSaverManager

static PSScreenSaverManager * instance = nil;

+ (PSScreenSaverManager*) sharedInstance
{
    DLogFuncName();
    @synchronized (self)
    {
        if (instance == nil)
        {
            instance = [PSScreenSaverManager new];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetScreenSaverTimer) name:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideScreenSaver) name:NOTIFICATION_SCREENSAVER_HIDE object:nil];
    }
    return self;
}


#pragma mark - Helper
- (BOOL) showsScreenSaver
{
    DLogFuncName();
    return self.screenSaverStarted;
}


#pragma mark - Show/Hide
- (void) showScreenSaver
{
    DLogFuncName();
    if (![[PSWizzardManager sharedInstance] showsWizzard])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_SHOW object:nil];

        self.screenSaverStarted = YES;
        [self.screenSaverTimer invalidate];

        self.screenSaverViewController = [[PSScreenSaverViewController alloc] init];
        [APPDELEGATE.window.rootViewController.view addSubview:self.screenSaverViewController.view];
    }
}


- (void) hideScreenSaver
{
    DLogFuncName();
    self.screenSaverStarted = NO;
    [self.screenSaverViewController.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_DID_HIDE object:nil];
}


#pragma mark - Timer
- (void)startScreenSaverTimer
{
    DLogFuncName();
    if (!self.screenSaverTimer)
    {
        self.screenSaverTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    else if ([self.screenSaverTimer isValid])
    {

    }
    else if (![self.screenSaverTimer isValid])
    {
        self.screenSaverTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
}


- (void)updateTimer
{
    DLogFuncName();
    if (!self.screenSaverStarted)
    {
        self.number++;
        if (self.number == (1*APP_SCREENSAVER_TIMER))
        {
            self.number = 0;
            if (!self.screenSaverStarted)
            {
                [self showScreenSaver];
            }
        }
    }
    else
    {
        [self.screenSaverTimer invalidate];
    }
}


- (void)resetScreenSaverTimer
{
    DLogFuncName();
    self.number = 0;
    [self.screenSaverTimer invalidate];
    self.screenSaverStarted = NO;
    [self startScreenSaverTimer];
}


@end
