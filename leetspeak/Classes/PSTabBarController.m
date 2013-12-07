//
//  PSTabBarController.m
//  leetspeak
//
//  Created by Philip Schneider on 13.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSScreenSaverManager.h"
#import "PSWizzardManager.h"
#import "PSTabBarController.h"

@interface PSTabBarController ()

@end

@implementation PSTabBarController

- (id) init
{
    DLogFuncName();
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillLayoutSubviews) name:NOTIFICATION_SCREENSAVER_DID_HIDE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillLayoutSubviews) name:NOTIFICATION_SCREENSAVER_DID_SHOW object:nil];
    }
    return self;
}


- (void) viewWillLayoutSubviews
{
    DLogFuncName();
    if ([[PSScreenSaverManager sharedInstance] showsScreenSaver] || [[PSWizzardManager sharedInstance] showsWizzard])
    {
        
        [UIView animateWithDuration:10
                              delay:0
                            options: UIViewAnimationCurveLinear
                         animations:^{
                             self.tabBar.alpha = .0;
                         }
                         completion:^(BOOL finished){
                             if ([[PSScreenSaverManager sharedInstance] showsScreenSaver] || [[PSWizzardManager sharedInstance] showsWizzard])
                             {
                                 self.tabBar.hidden = YES;
                                 self.tabBar.alpha = 1.0;
                             }
                             else
                             {
                                 self.tabBar.hidden = NO;
                                 self.tabBar.alpha = 1.0;
                             }
                         }];

    }
    else
    {
        self.tabBar.hidden = NO;
        self.tabBar.alpha = 1.0;
    }
}


@end
