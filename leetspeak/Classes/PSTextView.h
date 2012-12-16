//
//  PSTextView.h
//  leetspeak
//
//  Created by Philip Schneider on 15.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSTextView : UITextView

@property (nonatomic) BOOL firstResponderEnabled;

- (void)setCanBecomeFirstResponder:(BOOL) enabled;

@end
