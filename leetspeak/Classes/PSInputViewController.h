//
//  PSInputViewController.h
//  leetspeak
//
//  Created by Philip Schneider on 02.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>
#import "GAITrackedViewController.h"
#import <UIKit/UIKit.h>
#import "leet.h"

@class PSTextView;
@interface PSInputViewController : GAITrackedViewController <UITextInputDelegate, UITextViewDelegate, UIAlertViewDelegate>


@property (nonatomic) BOOL convertToLeet;

@property (strong, nonatomic) PSTextView *input;
@property (strong, nonatomic) PSTextView *output;
@property (strong, nonatomic) PSTextView *editingTextView;
@property (strong, nonatomic) PSTextView * topTextField;
@property (strong, nonatomic) PSTextView * bottomTextField;

@property (strong, nonatomic) UISlider *slider;

@property (strong, nonatomic) UIAlertView *clipboardAlertView;
@property (strong, nonatomic) UIAlertView *ignoreClipboardAlertView;

@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UIButton *importButton;
@property (strong, nonatomic) UIButton *exportButton;
@property (strong, nonatomic) UIButton *switchButton;

@property (strong, nonatomic) UIImageView * strengthImage;

@property (readwrite)   CFURLRef        soundFileURLRef;
@property (readonly)    SystemSoundID    soundKiss;

- (void)clearButtonTouched:(id)sender;
- (void)importButtonTouched:(id)sender;
- (void)exportButtonTouched:(id)sender;
- (void)switchButtonTouched:(id)sender;

- (void)valueChanged:(id)sender;

@end
