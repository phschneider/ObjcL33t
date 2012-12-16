//
//  PSTextView.m
//  leetspeak
//
//  Created by Philip Schneider on 15.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSTextView.h"

@implementation PSTextView
@synthesize firstResponderEnabled = _firstResponderEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setCanBecomeFirstResponder:(BOOL) enabled
{
    _firstResponderEnabled = enabled;
}


- (BOOL)canBecomeFirstResponder {
    // Damit kein Copy & Paste ausgelöst wird
    return _firstResponderEnabled;
}

@end
