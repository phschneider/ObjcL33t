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
#import "PSWikiViewController.h"
#import "PSMoreViewController.h"
#import "PSUserDefaults.h"

#import "PSScreenSaverManager.h"
#import "PSWizzardManager.h"

#include "ATConnect.h"
#import "ATAppRatingFlow.h"

#import "Crittercism.h"

#ifndef CONFIGURATION_AppStore
    #import "TestFlight.h"
#endif

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import "UserVoice.h"

@implementation PSAppDelegate


@synthesize reminderArray = _reminderArray;



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
        [GAI sharedInstance].debug = NO;
        // Create tracker instance.
        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37082737-1"];
        [tracker setAnonymize:YES];
    }
    #endif
}

- (void) startApptentive
{
    DLogFuncName();
//    NSString *kApptentiveAPIKey =
//    @"4b3c5f4c2ced2b2ee16a00b1d4c5c53f3079f79690f0f091eaea268e663cd742";
//    ATConnect *connection = [ATConnect sharedConnection];
//    connection.apiKey = kApptentiveAPIKey;
//
//    ATAppRatingFlow *sharedFlow =
//    [ATAppRatingFlow sharedRatingFlowWithAppID:APP_STORE_ID];
//    
//    [sharedFlow appDidLaunch:YES viewController:self.window.rootViewController];
}


- (void) setAppearance
{
    DLogFuncName();
//    UIColor * backgroundColor = [[UIColor alloc]initWithRed: 0.129412 green: 0.129412 blue: 0.129412 alpha: 1 ];

//    [[UIView appearance] setBackgroundColor:backgroundColor];
//    [[UILabel appearance] setTextColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}


- (void) initUserDefaults
{
    DLogFuncName();
    // F??r neue Version Clipboard zur??cksetzen
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
    [self startGoogleAnalytics];

    [self startTestFlight];
    
    [self setAppearance];
    [self initUserDefaults];
    
    NSLog(@"isiOS6 = %d", IS_IOS6);
    NSLog(@"isiOS7 = %d", IS_IOS7);
    NSLog(@"isSimulator = %d", IS_SIMULATOR);
    
    self.reminderArray = [NSArray arrayWithObjects:@"Random First Reminder Title",@"Random Second Reminder Title", @"Random Third Reminder Title", @"Random Fourth Reminder Title", @"Random Fifth Reminder Title", nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.tabBarController = [[PSTabBarController alloc] init];
    self.tabBarController.viewControllers = @[[[PSAlphaBetViewController alloc] init], [[PSInputViewController alloc] init], [[UINavigationController alloc] initWithRootViewController:[[PSWikiViewController alloc] init]]];
    self.tabBarController.selectedViewController = [[self.tabBarController viewControllers] objectAtIndex:1];

    [[NSNotificationCenter defaultCenter] postNotificationName:USERDEFAULTS_LEET_STRENGTH_CHANGES object:nil];

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    [[PSUserDefaults sharedPSUserDefaults] incrementAppDidFinishLaunchingCount];
    [[PSScreenSaverManager sharedInstance] startScreenSaverTimer];

    if( [[PSUserDefaults sharedPSUserDefaults] isFirstStart] || [[PSUserDefaults sharedPSUserDefaults] isFirstVersionStart] )
    {
        [[PSWizzardManager sharedInstance] showWizzard];
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
    
//    ATAppRatingFlow *sharedFlow =
//    [ATAppRatingFlow sharedRatingFlowWithAppID:APP_STORE_ID];
//    [sharedFlow appDidEnterForeground:YES viewController:self.window.rootViewController];
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
