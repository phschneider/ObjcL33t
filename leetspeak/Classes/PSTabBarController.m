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
        self.tabBar.hidden = YES;
    }
    else
    {
        self.tabBar.hidden = NO;
    }
}


@end
