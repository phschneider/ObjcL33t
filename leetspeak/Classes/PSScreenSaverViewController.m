//
//  PSScreenSaverViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 02.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSAppDelegate.h"
#import "PSScreenSaverViewController.h"

@interface PSScreenSaverViewController ()

@end

@implementation PSScreenSaverViewController

@synthesize backgroundView          = _backgroundView;
@synthesize backgroundImageView     = _backgroundImageView;
@synthesize isShowingLandscapeView  = _isShowingLandscapeView;

- (id) init
{
    DLogFuncName();
    self = [super init];
    if (self)
    {       
        self.isShowingLandscapeView = NO;
        self.trackedViewName = @"ScreenSaver Screen";
        self.backgroundView = [[UIView alloc] initWithFrame:[[APPDELEGATE window] bounds]];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.opaque = YES;
        self.backgroundView.alpha = .0;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UIImage * backgroundImage;
        if (IS_IPAD)
        {
            backgroundImage = [UIImage imageNamed:@"Default-Portrait"];
            if (  UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
            {
                backgroundImage = [UIImage imageNamed:@"Default-Landscape"];
            }
            else
            {
                backgroundImage = [UIImage imageNamed:@"Default-Portrait"];
            }
        }
        else if (IS_IPHONE_5)
        {
            backgroundImage = [UIImage imageNamed:@"Default-568h"];            
        }
        else {
            backgroundImage = [UIImage imageNamed:@"Default"];
        }
        
        self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundImageView.alpha = .0;
        self.backgroundImageView.backgroundColor = [UIColor blackColor];
        [self.backgroundView addSubview: self.backgroundImageView];
        [self.view addSubview:self.backgroundView];
    
        self.view.backgroundColor = [UIColor clearColor];
        self.view.opaque = YES;
        self.view.alpha = 1;

        self.backgroundView.frame = self.backgroundImageView.frame;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    DLogFuncName();
    [super viewDidLoad];
        
    [UIView animateWithDuration:10
                          delay:0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         self.backgroundView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [self blinkBackgroundAnimation];
                     }];

}


- (void) blinkBackgroundAnimation
{
    DLogFuncName();
    [UIView animateWithDuration:5
                          delay:0
                        options: (UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationCurveEaseInOut)
                     animations:^{
                         self.backgroundImageView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                     }];

}

- (void)orientationChanged:(NSNotification *)notification
{
    DLogFuncName();
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    UIImage * backgroundImage;
    
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !self.isShowingLandscapeView)
    {
        self.isShowingLandscapeView = YES;
        if (IS_IPAD)
        {
            backgroundImage = [UIImage imageNamed:@"Default-Landscape"];
        }
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) && self.isShowingLandscapeView)
    {
        self.isShowingLandscapeView = NO;
        if (IS_IPAD)
        {
            backgroundImage = [UIImage imageNamed:@"Default-Portrait"];
        }
    }
    
    
    if (!IS_IPAD)
    {
        if (IS_IPHONE_5)
        {
            backgroundImage = [UIImage imageNamed:@"Default-568h"];
        }
        else {
            backgroundImage = [UIImage imageNamed:@"Default"];
        }
    }
    
    
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.frame = CGRectMake(0,0,backgroundImage.size.width,backgroundImage.size.height);
    self.backgroundView.frame = self.backgroundImageView.frame;
}

- (void) viewWillLayoutSubviews
{
    DLogFuncName();
//    UIImage * backgroundImage;
//    if (  UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//    {
//        if (IS_IPAD)
//        {
//            backgroundImage = [UIImage imageNamed:@"Default-Landscape"];
//        }
//    }
//    else
//    {
//        if (IS_IPAD)
//        {
//            backgroundImage = [UIImage imageNamed:@"Default-Portrait"];
//        }
//    }
//    
//    self.backgroundImageView.image = backgroundImage;
//    self.backgroundImageView.frame = CGRectMake(0,0,backgroundImage.size.width,backgroundImage.size.height);
    
//    DLogFrame(self.view);
//    DLogBounds(self.view);
//    
//    DLogFrame(self.backgroundView);
//    DLogBounds(self.backgroundView);
//    
//    DLogFrame(self.backgroundImageView);
//    DLogBounds(self.backgroundImageView);
}


// Handles the start of a touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLogFuncName();
    [super touchesBegan:touches withEvent:event];
    
    [APPDELEGATE resetScreenSaverTimer];
    [APPDELEGATE hideScreenSaver];
	//[self dismissViewControllerAnimated:YES completion:NULL];
}
@end
