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
#import "PSWizzardViewController.h"
#import "PSUserDefaults.h"

#import "Crittercism.h"
#import "TestFlight.h"
#import "UserVoice.h"

@implementation PSAppDelegate

@synthesize screenSaverViewController = _screenSaverViewController;

@synthesize number = _number;
@synthesize screenSaverStarted = _screenSaverStarted;
@synthesize screenSaverTimer = _screenSaverTimer;
@synthesize reminderArray = _reminderArray;


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
    if (!self.wizzardStarted)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_STARTED object:nil];

        self.screenSaverStarted = YES;
        [self.screenSaverTimer invalidate];
        
        self.screenSaverViewController = [[PSScreenSaverViewController alloc] init];
        //[self.window.rootViewController presentModalViewController:screenSaver animated:NO];
        [self.window.rootViewController.view addSubview:self.screenSaverViewController.view];
    }
}

- (void) hideScreenSaver
{
    DLogFuncName();
    self.screenSaverStarted = NO;
    [self.tabBarController.view layoutSubviews];
    [self.screenSaverViewController.view removeFromSuperview];
}


#pragma mark - LocalNotifications
- (void) clearReminder
{
    DLogFuncName();
    // Kill old notification
    DLog(@"Notifications are = %@",[[[UIApplication sharedApplication] scheduledLocalNotifications] copy]);
    
    for (UILocalNotification * notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        DLog(@"Kill notifications %@",notification);
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}

- (void) updateReminder
{
    DLogFuncName();
    [self clearReminder];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) {
        return;
    }
    
    // random von 0 bis 3
    int r = arc4random() % [self.reminderArray count];
    // Erinnere mich in 14 Tagen
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow: 60 * 60 * 24 * 14];
#ifdef DEBUG
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow: 60];
#endif
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = NSLocalizedString([self.reminderArray objectAtIndex:r], nil);
    localNotif.alertAction = nil;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.userInfo = nil;
    

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    DLog(@"NOTIFICATIONS ARE =======================================");
    for (UILocalNotification * notification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        DLog(@"Notification %@", notification.fireDate);
        DLog(@"Notification %@", notification.alertBody);
        DLog(@"Notification %@", notification.alertAction);
    }
    DLog(@"=======================================");
}


#pragma mark - Helpers
- (BOOL) applicationSupportsShakeToEdit
{
    DLogFuncName();
    return YES;
}


- (void) startCrashReporter
{
    DLogFuncName();
    NSLog(@"Init Crittercism");
    UVConfig *config = [UVConfig configWithSite:@"phschneider.uservoice.com"
                                         andKey:@"1JvcH5Qx7INYHhEH3Wyhew"
                                      andSecret:@"fRjBfLRyUbuOIuj9A6mISs4zYmMftKkPRsR2HNdnc0"];
//    [UserVoice presentUserVoiceInterfaceForParentViewController:self.window.rootViewController andConfig:config];
    
    [Crittercism enableWithAppID: @"51a9c284c463c259ca000009"];
    

    

    
//    NSLog(@"Init BWQuincyManager");
//    if (!IS_SIMULATOR)
//    {
//        [[BWQuincyManager sharedQuincyManager] setSubmissionURL:@"http://crash.phschneider.net/crash_v200.php"];
//        [[BWQuincyManager sharedQuincyManager] setAutoSubmitCrashReport:YES];
//        [[BWQuincyManager sharedQuincyManager] setFeedbackActivated:YES];
//        [[BWQuincyManager sharedQuincyManager] setDelegate:self];
//    }
}


- (void) startTestFlight
{
    DLogFuncName();
    
#ifdef CONFIGURATION_Beta
    [TestFlight takeOff:@"dbf621ea-1434-439b-92b6-c38292542f98"];
#endif
    
#ifdef CONFIGURATION_Debug
    [TestFlight takeOff:@"0c8f417c-5a0a-41b3-a743-770753d520eb"];
#endif
}

- (void) startBetaUpdateChecker
{
    DLogFuncName();
    #ifndef CONFIGURATION_AppStore
        #ifdef CONFIGURATION_Beta
        if (!IS_SIMULATOR)
        {
            // Add these two lines if you want to activate the authorization feature
            //    [BWHockeyManager sharedHockeyManager].requireAuthorization = YES;
            //    [BWHockeyManager sharedHockeyManager].authenticationSecret = @"ChangeThisToYourOwnSecretString";
            
            NSLog(@"Init BWHockeyManager");
            [BWHockeyManager sharedHockeyManager].updateURL = @"http://beta.phschneider.net";
            [BWHockeyManager sharedHockeyManager].delegate = self;
            
            // optionally enable logging to get more information about states.
            [BWHockeyManager sharedHockeyManager].loggingEnabled = YES;
        }
        #endif
    #endif
}


- (void) startGoogleAnalytics
{
    DLogFuncName();
    #ifdef CONFIGURATION_AppStore
    if (!IS_SIMULATOR)
    {
        // Optional: automatically track uncaught exceptions with Google Analytics.
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 20;
        // Optional: set debug to YES for extra debugging information.
        [GAI sharedInstance].debug = YES;
        // Create tracker instance.
        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37082737-1"];
    }
    #endif
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



#pragma mark - Wizzard
- (void) showWizzard
{
    DLogFuncName();
    self.wizzardViewController = nil;
    self.wizzardStarted = YES;
    self.wizzardViewController = [[PSWizzardViewController alloc] init];
    [self.window.rootViewController.view addSubview:self.wizzardViewController.view];
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
                         [self.tabBarController.view layoutSubviews];
                     }];
    
}


#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DLogFuncName();
    DLog(@"Source Application = %@",sourceApplication);
    [self handleUrl:url];
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    DLogFuncName();
    [self handleUrl:url];
    return YES;
}


- (void) handleUrl:(NSURL*) url
{
    DLogFuncName();
    //    if (self.hiplo24ViewController && self.hiplo24ViewController.view.superview)
    //    {
    //        if ([self.hiplo24ViewController respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
    //        {
    //            [self.hiplo24ViewController dismissModalViewControllerAnimated:YES];
    //        }
    //        else if ( [self.hiplo24ViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    //        {
    //            [self.hiplo24ViewController dismissViewControllerAnimated:YES completion:nil];
    //        }
    //    }
    //
    //    [self showPreviousTab];
    //    
    
    DLog(@"Url = %@", url);
}

#pragma mark - Application Delegate - URL
//AppDelegate Initialize Functions
+ (void)initialize
{
    DLogFuncName();
    if (!IS_SIMULATOR)
    {
        [iVersion sharedInstance].applicationBundleID = @"net.phschneider.l33t";
        [iVersion sharedInstance].showOnFirstLaunch = YES;
    #ifdef DEBUG
        [iVersion sharedInstance].previewMode = YES;
        [iVersion sharedInstance].verboseLogging = YES;
    #endif
        
        //configure iRate
//        [iRate sharedInstance].daysUntilPrompt = 10;
        [iRate sharedInstance].applicationBundleID = @"net.phschneider.l33t";
//        [iRate sharedInstance].usesUntilPrompt = 15;
        [iRate sharedInstance].promptAgainForEachNewVersion = YES;
        [iRate sharedInstance].remindPeriod = 7;
        [iRate sharedInstance].eventCount = 100;
        
    #ifdef DEBUG
        [iRate sharedInstance].previewMode = YES;
        [iRate sharedInstance].verboseLogging = YES;
    #endif
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DLogFuncName();
    if (application.applicationState == UIApplicationStateInactive )
    {
        DLog(@"app not running");
    }
    else if(application.applicationState == UIApplicationStateActive )
    {
        DLog(@"app running");
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DLogFuncName();
    DLog(@"Notification = %@", notification);
    
    [[PSUserDefaults sharedPSUserDefaults] incrementAppDidReceiveLocalNotification];
    
    if ( [notification.alertAction isEqualToString:@"open app"] )
    {
    }
    
    if ( [notification.alertAction isEqualToString:@"rate the app"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=546965677"]];
    }
    
    NSString * state = @"Unknown";
    
    if ( application.applicationState == UIApplicationStateInactive ) {
        //The application received the notification from an inactive state, i.e. the user tapped the "View" button for the alert.
        //If the visible view controller in your view controller stack isn't the one you need then show the right one.
        state = @"UIApplicationStateInactive";
    }
    
    if( application.applicationState == UIApplicationStateActive ) {
        //The application received a notification in the active state, so you can display an alert view or do something appropriate.
        state = @"UIApplicationStateActive";
    }
    
    DLog(@"State: %@, Notification: %@",state, notification.alertAction);
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DLogFuncName();
    DLog(@"launchOptions = %@",launchOptions);
    UILocalNotification *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notif)
    {
        DLog(@"Launched with notifications");
    }
    
    
    [self startCrashReporter];
    [self startBetaUpdateChecker];
    [self startGoogleAnalytics];

    [self startTestFlight];
    
    [self setAppearance];
    [self initUserDefaults];
    
    NSLog(@"isiOS6 = %d", IS_IOS6);
    NSLog(@"isSimulator = %d", IS_SIMULATOR);
    
    self.reminderArray = [NSArray arrayWithObjects:@"Random First Reminder Title",@"Random Second Reminder Title", @"Random Third Reminder Title", @"Random Fourth Reminder Title", @"Random Fifth Reminder Title", nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2, *viewController3;
    viewController1 = [[PSAlphaBetViewController alloc] init];
    viewController2 = [[PSInputViewController alloc] init];
    viewController3 = [[UINavigationController alloc] initWithRootViewController:[[PSWikiViewController alloc] init]];
    
    self.tabBarController = [[PSTabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3];
    self.tabBarController.selectedViewController = viewController2;

    [[NSNotificationCenter defaultCenter] postNotificationName:USERDEFAULTS_LEET_STRENGTH_CHANGES object:nil];

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    [[PSUserDefaults sharedPSUserDefaults] incrementAppDidFinishLaunchingCount];

#warning umbauen
    [self startScreenSaverTimer];
    
    
    if( [[PSUserDefaults sharedPSUserDefaults] isFirstStart] || [[PSUserDefaults sharedPSUserDefaults] isFirstVersionStart] )
    {
        [self showWizzard];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    DLogFuncName();
    [self updateReminder];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLogFuncName();
    [self updateReminder];
    
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
//    [self updateReminder];
    [self clearReminder];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLogFuncName();
//    [self updateReminder];
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
