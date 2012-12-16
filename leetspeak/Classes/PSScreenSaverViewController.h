//
//  PSScreenSaverViewController.h
//  leetspeak
//
//  Created by Philip Schneider on 02.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "GAITrackedViewController.h"
#import <UIKit/UIKit.h>

@interface PSScreenSaverViewController : GAITrackedViewController

@property (nonatomic) BOOL isShowingLandscapeView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end
