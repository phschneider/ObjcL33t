//
//  PSMoreViewController.h
//  leetspeak
//
//  Created by Philip Schneider on 03.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "GAITrackedViewController.h"
#import <UIKit/UIKit.h>

@interface PSMoreViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray * menu;

@end
