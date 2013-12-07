//
//  PSAlphaBetViewController.h
//  leetspeak
//
//  Created by Philip Schneider on 03.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSViewController.h"

@interface PSAlphaBetViewController : PSViewController <UITableViewDataSource, UITableViewDelegate>
{
    dispatch_queue_t tableQueue;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISlider *slider;

@property (strong, nonatomic) UIImageView * strengthImage;
@property (strong, nonatomic) UITapGestureRecognizer * tapGestureRecognizer;

- (void)valueChanged:(id)sender;

@end
