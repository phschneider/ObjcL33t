//
//  PSSettingsViewController.h
//  leetspeak
//
//  Created by Philip Schneider on 03.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#warning TODO - Umbauen auf keine TableView
#import "GAITrackedViewController.h"
#import <UIKit/UIKit.h>

@interface PSSettingsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary * menu;

@end
