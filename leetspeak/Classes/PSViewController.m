//
//  PSViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 10.11.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSScreenSaverManager.h"
#import "PSViewController.h"

@interface PSViewController ()

@end

@implementation PSViewController

- (id) init
{
    DLogFuncName();
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = APP_BACKGROUND_COLOR;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    DLogFuncName();
    [super viewDidAppear:animated];

    [[PSScreenSaverManager sharedInstance] resetScreenSaverTimer];
}


#pragma mark - Rotation
- (BOOL) shouldAutorotate
{
    DLogFuncName();
    return (!IS_IPHONE);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    DLogFuncName();
    return (!IS_IPHONE);
}
@end
