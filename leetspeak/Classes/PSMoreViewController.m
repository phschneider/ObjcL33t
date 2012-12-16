//
//  PSMoreViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 03.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSSettingsViewController.h"
#import "PSImprintViewController.h"
#import "PSWikiViewController.h"
#import "PSMoreViewController.h"

@interface PSMoreViewController ()

@end

@implementation PSMoreViewController

@synthesize menu = _menu;

-(id) init
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    self = [super init];
    if (self)
    {
        self.menu = [NSArray arrayWithObjects:@"What's Leetspeak?", @"Settings", nil];
        self.title = NSLocalizedString(@"Info", @"Info");
        self.tabBarItem.image = [UIImage imageNamed:@"42-info"];
    }
    return self;
}

- (BOOL) shouldAutorotate
{
    return (!IS_IPHONE);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (!IS_IPHONE);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        ///////////////////////////////////////first
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    

    cell.textLabel.text = [self.menu objectAtIndex:indexPath.row];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [APPDELEGATE resetScreenSaverTimer];
    UIViewController * viewController;
    switch (indexPath.row) {
        case 0:
            {
                viewController = [[PSWikiViewController alloc] init];
                viewController.title = @"From Wikipedia";
            }
            break;
        case 1:
            {
                viewController = [[PSSettingsViewController alloc] init];
                viewController.title = @"Settings";
            }
            break;
        case 2:
            {
                viewController = [[PSImprintViewController alloc] init];
                viewController.title = @"Imprint";
            }
            break;
    }
    
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
