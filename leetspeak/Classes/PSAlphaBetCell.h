//
//  PSAlphaBetCell.h
//  leetspeak
//
//  Created by Philip Schneider on 03.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAlphaBetCell : UITableViewCell
{
    NSMutableArray *columns;
}

- (void)addColumn:(CGFloat)position;

@end
