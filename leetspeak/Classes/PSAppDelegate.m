//
//  PSAppDelegate.m
//  leetspeak
//
//  Created by Philip Schneider on 02.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSAppDelegate.h"

#import "iRate.h"
#import "iVersion.h"

#import "PSTabBarController.h"
#import "PSAlphaBetViewController.h"
#import "PSInputViewController.h"
#import "PSScreenSaverViewController.h"
#import "PSWikiViewController.h"
#import "PSMoreViewController.h"

@implementation PSAppDelegate

@synthesize screenSaverViewController = _screenSaverViewController;

@synthesize number = _number;
@synthesize screenSaverStarted = _screenSaverStarted;
@synthesize screenSaverTimer = _screenSaverTimer;


#pragma mark -
#pragma mark BWHockeyControllerDelegate

-(NSString *)customDeviceIdentifier {
    DLogFuncName();
#if !defined (CONFIGURATION_AppStore_Distribution)
    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
#endif
    return nil;
}

#pragma mark - BWQuincyManagerDelegate & BWHockeyControllerDelegate
- (void)connectionOpened {
    DLogFuncName();
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connectionClosed {
    DLogFuncName();
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



#pragma mark - Timer

- (void)startScreenSaverTimer
{
//    DLogFuncName();
    if (!self.screenSaverTimer)
    {
//        NSLog(@"Timer Started");
        self.screenSaverTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    else if ([self.screenSaverTimer isValid])
    {
//        NSLog(@"Timer isValid");
    }
    else if (![self.screenSaverTimer isValid])
    {
//        NSLog(@"Timer isInValid");
        self.screenSaverTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }

}

- (void)resetScreenSaverTimer
{
//    DLogFuncName();
    self.number = 0;
    [self.screenSaverTimer invalidate];
    self.screenSaverStarted = NO;
    [self startScreenSaverTimer];
}

- (void)updateTimer
{
//    DLogFuncName();
    if (!self.screenSaverStarted)
    {
        self.number++;

//        NSLog(@"Number = %d",self.number);
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

- (void) showScreenSaver
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_STARTED object:nil];

    self.screenSaverStarted = YES;
    [self.screenSaverTimer invalidate];
    
    self.screenSaverViewController = [[PSScreenSaverViewController alloc] init];
    //[self.window.rootViewController presentModalViewController:screenSaver animated:NO];
    [self.window.rootViewController.view addSubview:self.screenSaverViewController.view];
}

- (void) hideScreenSaver
{
    DLogFuncName();
    [self.screenSaverViewController.view removeFromSuperview];
}

- (BOOL) applicationSupportsShakeToEdit
{
    DLogFuncName();
    return YES;
}


- (void) startCrashReporter
{
    DLogFuncName();
    NSLog(@"Init BWQuincyManager");
    [[BWQuincyManager sharedQuincyManager] setSubmissionURL:@"http://crash.phschneider.net/crash_v200.php"];
    [[BWQuincyManager sharedQuincyManager] setAutoSubmitCrashReport:YES];
    [[BWQuincyManager sharedQuincyManager] setFeedbackActivated:YES];
    [[BWQuincyManager sharedQuincyManager] setDelegate:self];
}


- (void) startBetaUpdateChecker
{
    DLogFuncName();
    #ifndef CONFIGURATION_AppStore
        // Add these two lines if you want to activate the authorization feature
        //    [BWHockeyManager sharedHockeyManager].requireAuthorization = YES;
        //    [BWHockeyManager sharedHockeyManager].authenticationSecret = @"ChangeThisToYourOwnSecretString";
        
        NSLog(@"Init BWHockeyManager");
        [BWHockeyManager sharedHockeyManager].updateURL = @"http://beta.phschneider.net";
        [BWHockeyManager sharedHockeyManager].delegate = self;
        
        // optionally enable logging to get more information about states.
        [BWHockeyManager sharedHockeyManager].loggingEnabled = YES;
    #endif
}

- (void) startGoogleAnalytics
{
    DLogFuncName();
    
    // Optional: automatically track uncaught exceptions with Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37082737-1"];
}


- (void) setAppearance
{
    DLogFuncName();
//    UIColor * backgroundColor = [[UIColor alloc]initWithRed: 0.129412 green: 0.129412 blue: 0.129412 alpha: 1 ];

//    [[UIView appearance] setBackgroundColor:backgroundColor];
//    [[UILabel appearance] setTextColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}


- (void) initUserDefaults
{
    DLogFuncName();
    // Für neue Version Clipboard zurücksetzen
    // Clipboard
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERDEFAULTS_CLIPOARD_INPUT];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USERDEFAULTS_CLIPOARD_OUTPUT];

    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_APP_FIRST_START])
    {
        //Slider
        [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:USERDEFAULTS_LEET_STRENGTH];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERDEFAULTS_APP_FIRST_START];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


//AppDelegate Initialize Functions
+ (void)initialize
{
    DLogFuncName();
    [iVersion sharedInstance].applicationBundleID = @"net.phschneider.l33t";
    [iVersion sharedInstance].showOnFirstLaunch = YES;
#ifdef DEBUG
    [iVersion sharedInstance].previewMode = YES;
    [iVersion sharedInstance].verboseLogging = YES;
#endif
    
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].applicationBundleID = @"net.phschneider.l33t";
    [iRate sharedInstance].usesUntilPrompt = 15;
    [iRate sharedInstance].promptAgainForEachNewVersion = YES;
    
#ifdef DEBUG
    [iRate sharedInstance].previewMode = YES;
    [iRate sharedInstance].verboseLogging = YES;
#endif
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DLogFuncName();
    [self startCrashReporter];
    [self startBetaUpdateChecker];
    [self startGoogleAnalytics];
    
    [self setAppearance];
    [self initUserDefaults];
    
    NSLog(@"isiOS6 = %d", IS_IOS6);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2, *viewController3;
    viewController1 = [[PSAlphaBetViewController alloc] init];
    viewController2 = [[PSInputViewController alloc] init];
//    viewController3 = [[UINavigationController alloc] initWithRootViewController:[[PSMoreViewController alloc] init]];
//    viewController3 = [[PSWikiViewController alloc] init];
    viewController3 = [[UINavigationController alloc] initWithRootViewController:[[PSWikiViewController alloc] init]];
    
    self.tabBarController = [[PSTabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3];
    self.tabBarController.selectedViewController = viewController2;

    [[NSNotificationCenter defaultCenter] postNotificationName:USERDEFAULTS_LEET_STRENGTH_CHANGES object:nil];

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    [self startScreenSaverTimer];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DLogFuncName();
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLogFuncName();
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLogFuncName();
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLogFuncName();
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLogFuncName();
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end