//
//  PSSettingsViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 03.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSSettingsViewController.h"

@interface PSSettingsViewController ()

@end

@implementation PSSettingsViewController

@synthesize menu = _menu;

-(id) init
{
    DLogFuncName();
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        [self.tableView setBackgroundView:nil];
        [self.tableView setBackgroundView:[[UIView alloc] init]];
        [self.tableView setBackgroundColor: [[UIColor alloc]initWithRed: 0.129412 green: 0.129412 blue: 0.129412 alpha: 1 ]];

        self.menu = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Ignore for input ", @"Automatic add output", nil], nil]
                                                forKeys:[NSArray arrayWithObjects:@"Clipboard", nil]];

    }
    return self;
}

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

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DLogFuncName();
    return [[self.menu allKeys] objectAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    DLogFuncName();
    return [[self.menu allKeys] objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    DLogFuncName();
    return [self.menu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLogFuncName();
    return [[self.menu objectForKey:[[self.menu allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLogFuncName();
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        ///////////////////////////////////////first
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
    }

    
    cell.textLabel.text = [[self.menu objectForKey:[[self.menu allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    UISwitch * switcher = [[UISwitch alloc] initWithFrame:cell.accessoryView.bounds];
    switcher.tag = 99;
    
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                {
                    [switcher setOn:[[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_CLIPOARD_INPUT]];
                    [switcher addTarget:self action:@selector(IgnoreClipboardForInputStateChanged:) forControlEvents:UIControlEventValueChanged];
                }
                break;
            case 1:
                {
                    [switcher setOn:[[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_CLIPOARD_OUTPUT]];
                    [switcher addTarget:self action:@selector(IgnoreClipboardForOutputStateChanged:) forControlEvents:UIControlEventValueChanged];
                }
                break;
        }
    }
    
    cell.accessoryView = switcher;
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
}


- (void) IgnoreClipboardForInputStateChanged:(id)sender
{
    DLogFuncName();
    [[NSUserDefaults standardUserDefaults] setBool:[(UISwitch*)sender isOn] forKey:USERDEFAULTS_CLIPOARD_INPUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}


- (void) IgnoreClipboardForOutputStateChanged:(id)sender
{
    DLogFuncName();
    [[NSUserDefaults standardUserDefaults] setBool:[(UISwitch*)sender isOn] forKey:USERDEFAULTS_CLIPOARD_OUTPUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}
@end
