//
//  PSAppDelegate.h
//  leetspeak
//
//  Created by Philip Schneider on 02.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//


//#import "BWQuincyManager.h"
#import <UIKit/UIKit.h>

@class PSScreenSaverViewController;
@class PSWizzardViewController;

@interface PSAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {


}
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) PSScreenSaverViewController * screenSaverViewController;
        
@property (nonatomic) BOOL wizzardStarted;
@property (nonatomic, strong) PSWizzardViewController * wizzardViewController;
        
@property (nonatomic, strong) NSArray * reminderArray;
        
@property (nonatomic) int number;
@property (nonatomic) BOOL screenSaverStarted;
@property (nonatomic, strong) NSTimer * screenSaverTimer;

- (void)startScreenSaverTimer;
- (void)resetScreenSaverTimer;
- (void) hideScreenSaver;
        
- (void) showWizzard;
- (void) hideWizzard;
        
@end
