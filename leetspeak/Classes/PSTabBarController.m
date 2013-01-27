//
//  PSTabBarController.m
//  leetspeak
//
//  Created by Philip Schneider on 13.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

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
        
    }
    return self;
}


- (void) viewWillLayoutSubviews
{
    DLogFuncName();
    if (APPDELEGATE.screenSaverStarted)
    {
        
        [UIView animateWithDuration:10
                              delay:0
                            options: UIViewAnimationCurveLinear
                         animations:^{
                             self.tabBar.alpha = .0;
                         }
                         completion:^(BOOL finished){
                             self.tabBar.hidden = YES;
                             self.tabBar.alpha = 1.0;
                         }];

    }
    else
    {
        self.tabBar.hidden = NO;
        self.tabBar.alpha = 1.0;
    }
}


@end
