//
//  PSAppDelegate.h
//  leetspeak
//
//  Created by Philip Schneider on 02.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//


//#import "BWQuincyManager.h"
#import <UIKit/UIKit.h>


@interface PSAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, strong) NSArray * reminderArray;


@end
