//
//  PSInputViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 02.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PSUserDefaults.h"
#import "PSInputViewController.h"
#import "PSTextView.h"
#import "SVProgressHUD.h"
#import "iRate.h"


#import "PSLeetAlphabet.h"
#import "ATConnect.h"

@implementation PSInputViewController

@synthesize toolTips                    = _toolTips;
@synthesize darkViews                   = _darkViews;
@synthesize clipboardAlertView          = _clipboardAlertView;
@synthesize ignoreClipboardAlertView    = _ignoreClipboardAlertView;
@synthesize convertToLeet               = _convertToLeet;
@synthesize editingTextView             = _editingTextView;
@synthesize strengthImage               = _strengthImage;

@synthesize topTextField                = _topTextField;
@synthesize bottomTextField             = _bottomTextField;

@synthesize soundKiss                   = _soundKiss;
@synthesize soundFileURLRef             = _soundFileURLRef;

- (id) init
{
    DLogFuncName();
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Input TabBar Title", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"white-187-pencil"];
        
        self.toolTips = [[NSMutableArray alloc] initWithCapacity:10];
        self.darkViews = [[NSMutableArray alloc] initWithCapacity:100];
        
        // Create the sound ID
        NSString* path = [[NSBundle mainBundle]
                          pathForResource:@"kiss" ofType:@"aiff"];
        NSURL* url = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_soundKiss);
        
        self.rotationCounter = 1;
        
        int width, height, paddingX, paddingY;
        if (IS_IPAD)
        {
            width = INPUT_WIDTH_IPAD;
            paddingX = ceil((768-INPUT_WIDTH_IPAD)/2);
            paddingY = paddingX;
            height = INPUT_HEIGHT_IPAD_MAX_P;
        }
        else if (IS_IPHONE_5)
        {
            paddingX = paddingY = 20;
            width = INPUT_WIDTH_IPHONE-(3*paddingX);
            height = INPUT_HEIGHT_IPHONE5_MAX;
        }
        else
        {
            paddingX = paddingY = 20;
            width = INPUT_WIDTH_IPHONE-(3*paddingX);
            height = INPUT_HEIGHT_IPHONE_MAX;
        }

        if (IS_IOS7)
        {
            paddingY += 20;
        }
        
        CGRect textViewFrame = CGRectMake(paddingX,paddingY,width,height);
        self.input = [[PSTextView alloc] initWithFrame:textViewFrame];
        self.input.autoresizingMask = UIViewAutoresizingNone;
        self.input.text = @"Hi";
//        self.input.text = @"";
        self.input.delegate = self;
        [self.input setCanBecomeFirstResponder:YES];
        self.input.layer.borderWidth = 1;
        self.input.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.input.layer.borderColor = [[UIColor blackColor] CGColor];
        [self.view addSubview:self.input];
        
        
        CGRect buttonFrame = CGRectMake(textViewFrame.origin.x + textViewFrame.size.width, textViewFrame.origin.y, BUTTON_WIDTH,BUTTON_HEIGHT);
        buttonFrame.origin.y -= 6;
        self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clearButton.frame = buttonFrame;
        self.clearButton.accessibilityHint = NSLocalizedString(@"Clear Button AccessibiltyHint", @"");
        self.clearButton.accessibilityHint = NSLocalizedString(@"Clear Input",@"");
        [self.clearButton setImage:[UIImage imageNamed:@"white-298-circlex"] forState:UIControlStateNormal];
        [self.clearButton addTarget:self action:@selector(clearButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.clearButton];
        
        
        buttonFrame.origin.y = textViewFrame.origin.y + textViewFrame.size.height - buttonFrame.size.height;
        self.importButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.importButton.frame = buttonFrame;
        self.importButton.accessibilityHint = NSLocalizedString(@"Import Button AccessibiltyHint", @"");
        [self.importButton setImage:[UIImage imageNamed:@"white-265-download"] forState:UIControlStateNormal];
        [self.importButton addTarget:self action:@selector(importButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.importButton];
        
        
        textViewFrame.origin.y = textViewFrame.origin.y + textViewFrame.size.height + paddingX + paddingX;
        self.output = [[PSTextView alloc] initWithFrame:textViewFrame];
        self.output.delegate = self.input.delegate;
        self.output.autoresizingMask = self.input.autoresizingMask;
        self.output.editable = NO;
        self.output.keyboardAppearance = self.input.keyboardAppearance;
        [self.output setCanBecomeFirstResponder:NO];
        self.output.textColor = [UIColor whiteColor];
        self.output.layer.borderWidth = 1;
        self.output.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.output.backgroundColor =  APP_BACKGROUND_COLOR;
        [self.view addSubview:self.output];
        
        //self.input.layer.cornerRadius = 5;
        //self.output.layer.cornerRadius = 5;
        
        
        buttonFrame.origin.y = ceil((self.output.frame.origin.y - (self.input.frame.origin.y + self.input.frame.size.height))/2) + self.input.frame.origin.y + self.input.frame.size.height - ceil(buttonFrame.size.height/2);
        buttonFrame.origin.x = self.input.center.x - ceil(buttonFrame.size.width/2);
        
        self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.switchButton.frame = buttonFrame;
        self.switchButton.accessibilityHint = NSLocalizedString(@"Switch Button AccessibiltyHint", @"");
        [self.switchButton setImage:[UIImage imageNamed:@"white-288-retweet"] forState:UIControlStateNormal];
        [self.switchButton addTarget:self action:@selector(switchButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.switchButton];
        
        buttonFrame.origin.y = textViewFrame.origin.y + textViewFrame.size.height +10;
        buttonFrame.origin.x = textViewFrame.origin.x + textViewFrame.size.width;

        self.exportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.exportButton.frame = buttonFrame;
        self.exportButton.accessibilityHint = NSLocalizedString(@"Export Button AccessibiltyHint", @"");
        [self.exportButton setImage:[UIImage imageNamed:@"white-266-upload"] forState:UIControlStateNormal];
        [self.exportButton addTarget:self action:@selector(exportButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.exportButton];

        CGRect tmpButtonFrame = buttonFrame;
        tmpButtonFrame.origin.y = self.output.frame.origin.y  + (ceil(self.output.frame.size.height / 2)) - ceil(self.exportButton.frame.size.height / 2);
        
        self.mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mailButton.frame = tmpButtonFrame;
        self.mailButton.accessibilityHint = NSLocalizedString(@"Mail Button AccessibiltyHint", @"");
        [self.mailButton setImage:[UIImage imageNamed:@"white-18-envelope"] forState:UIControlStateNormal];
        [self.mailButton addTarget:self action:@selector(mailButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.mailButton];
        
        tmpButtonFrame.origin.y = self.output.frame.origin.y - 8;
        
        self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chatButton.frame = tmpButtonFrame;
        self.chatButton.accessibilityHint = NSLocalizedString(@"Chat Button AccessibiltyHint", @"");
        [self.chatButton setImage:[UIImage imageNamed:@"white-08-chat"] forState:UIControlStateNormal];
        [self.chatButton addTarget:self action:@selector(chatButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.chatButton];
                
        if (IS_IOS7)
        {
            paddingY += 20;
        }
        
        CGRect sliderFrame = CGRectMake(paddingX, self.view.frame.size.height - SLIDER_HEIGHT - paddingY, width, SLIDER_HEIGHT);
        
        self.slider = [[UISlider alloc] initWithFrame:sliderFrame];
        self.slider.accessibilityHint = NSLocalizedString(@"Slider AccessibiltyHint", @"");
        [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 8;
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        self.tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.slider addGestureRecognizer:self.tapGestureRecognizer];
    
        self.slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:self.slider];
        
        
        self.strengthImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white-89-dumbells"]];
        buttonFrame = self.strengthImage.frame;
        self.strengthImage.frame = buttonFrame;
        self.strengthImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:self.strengthImage];
        
        // verdammt wichtig!!!
        [self setConvertToLeet:YES];
        
        [self centerButtonsForWidth:width andPadding:paddingX];
        [self viewWillLayoutSubviews];
        
#ifdef DEBUG_GRAPHICS
        self.clearButton.layer.borderWidth = 1.0;
        self.clearButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.importButton.layer.borderWidth = 1.0;
        self.importButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.exportButton.layer.borderWidth = 1.0;
        self.exportButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.switchButton.layer.borderWidth = 1.0;
        self.switchButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.chatButton.layer.borderWidth = 1.0;
        self.chatButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.mailButton.layer.borderWidth = 1.0;
        self.mailButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        self.strengthImage.layer.borderWidth = 1.0;
        self.strengthImage.layer.borderColor = [[UIColor whiteColor] CGColor];
#endif
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSliderValue) name:USERDEFAULTS_LEET_STRENGTH_CHANGES object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenSaverStarted) name:NOTIFICATION_SCREENSAVER_DID_SHOW object:nil];
        
    }
    return self;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleBlackOpaque;
}


- (void) screenSaverStarted
{
    DLogFuncName();
    if ([self.topTextField isFirstResponder])
    {
        [self.topTextField resignFirstResponder];
    }
}


- (void) centerButtonsForWidth:(int)width andPadding:(int)padding
{
    // Center Buttons
    CGPoint buttonCenter;
    
    buttonCenter = self.clearButton.center;
    buttonCenter.x = ceil((self.view.frame.size.width - (self.slider.frame.origin.x + self.slider.frame.size.width))/2)+width+padding;
    self.clearButton.center = buttonCenter;
    
    buttonCenter = self.importButton.center;
    buttonCenter.x = ceil((self.view.frame.size.width - (self.slider.frame.origin.x + self.slider.frame.size.width))/2)+width+padding;
    self.importButton.center = buttonCenter;
    
    buttonCenter = self.exportButton.center;
    buttonCenter.x = ceil((self.view.frame.size.width - (self.slider.frame.origin.x + self.slider.frame.size.width))/2)+width+padding;
    self.exportButton.center = buttonCenter;
    
    buttonCenter = self.slider.center;
    buttonCenter.x = ceil((self.view.frame.size.width - (self.slider.frame.origin.x + self.slider.frame.size.width))/2)+width+padding;
    self.strengthImage.center = buttonCenter;
    
    buttonCenter = self.slider.center;
    buttonCenter.y =  ceil((self.bottomTextField.frame.origin.y - (self.topTextField.frame.origin.y + self.topTextField.frame.size.height)) / 2) + self.topTextField.frame.origin.y + self.topTextField.frame.size.height;
    self.switchButton.center = buttonCenter;
    DLogFrame(self.topTextField);
    DLogFrame(self.bottomTextField);
    DLogFrame(self.switchButton);
    
//    buttonCenter = self.mailButton.center;
//    buttonCenter.y =  ceil((self.bottomTextField.frame.origin.y - (self.topTextField.frame.origin.y + self.topTextField.frame.size.height)) / 2) + self.topTextField.frame.origin.y + self.topTextField.frame.size.height;
//    self.mailButton.center = buttonCenter;
    
    buttonCenter = self.mailButton.center;
    buttonCenter.x =  self.exportButton.center.x;
    self.mailButton.center = buttonCenter;
    
    buttonCenter = self.chatButton.center;
    buttonCenter.x =  self.exportButton.center.x;
    self.chatButton.center = buttonCenter;
//
//    buttonCenter = self.slider.center;
//    buttonCenter.x = ceil((self.view.frame.size.width - (self.slider.frame.origin.x + self.slider.frame.size.width))/2)+width+padding;
//    self.mailButton.center = buttonCenter;
    
#warning todo mail button
#warning todo chat button
}


- (void) viewDidAppear:(BOOL)animated
{
    DLogFuncName();
    [super viewDidAppear:animated];

    [self expandTextViewsWithAnimation:NO];
    
    self.input.font = [UIFont fontWithName:@"Bookman Old Style" size:16];
    self.output.font = [UIFont fontWithName:@"Bookman Old Style" size:16];
    
    [self updateSliderValue];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_CLIPOARD_INPUT])
    {
        [[UIPasteboard generalPasteboard] containsPasteboardTypes:UIPasteboardTypeListString];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (pasteboard.string != nil)
        {
#warning todo I18n
            // NSString * clipBoardText = pasteboard.string;
            self.clipboardAlertView = [[UIAlertView alloc] initWithTitle:@"Clipboard" message:@"There's something in your clipboard. Should I use it?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [self.clipboardAlertView show];
        }
    }
    
    [self setInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//    [self showToolTips];
}


- (void) viewWillDisappear:(BOOL)animated
{
    DLogFuncName();
    [super viewWillDisappear:animated];
}

- (void) setConvertToLeet:(BOOL)convertToLeet
{
    _convertToLeet = convertToLeet;
    if (_convertToLeet)
    {
        self.topTextField = self.input;
        self.bottomTextField = self.output;
    }
    else
    {
        self.topTextField = self.output;
        self.bottomTextField = self.input;
    }
}

- (void)viewDidUnload
{
    DLogFuncName();
    [self setSlider:nil];
    [self setOutput:nil];
    [self setInput:nil];
    [self setClearButton:nil];
    [self setImportButton:nil];
    [self setExportButton:nil];
    [super viewDidUnload];
}

#pragma mark - ToolTips
- (void) darkenGui
{
    DLogFuncName();
    for (UIView * view in self.view.subviews)
    {
        [self.darkViews addObject:view];
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             view.alpha = 0.5;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

- (void) lightenGui
{
    DLogFuncName();
    for (UIView * view in [self.darkViews copy])
    {
        [self.darkViews removeObject:view];
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             view.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}


#pragma mark - Rotation (iPad)
- (void) setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPAD)
    {
        int height, paddingX, paddingY;
        if (IS_LANDSCAPE)
        {
            paddingX = ceil((1024-INPUT_WIDTH_IPAD)/2);
            paddingY = ceil((768-INPUT_WIDTH_IPAD)/2);
            height = INPUT_HEIGHT_IPAD_MAX_L;
        }
        else
        {
            paddingX = ceil((768-INPUT_WIDTH_IPAD)/2);
            paddingY = paddingX;
            height = INPUT_HEIGHT_IPAD_MAX_P;
        }
        
        
        // Input-View
        CGRect oldInputRect = self.topTextField.frame;
        CGRect newInputRect = oldInputRect;
        newInputRect.size.height = height;
        newInputRect.origin.x = paddingX;
        newInputRect.origin.y = paddingY;
        self.topTextField.frame = newInputRect;
        
        //        // Import-Button
        //        CGRect oldImportButtonFrame = self.importButton.frame;
        //        oldImportButtonFrame.origin.y = newInputRect.origin.y + newInputRect.size.height - oldImportButtonFrame.size.height;
        //        oldImportButtonFrame.origin.y += 8;
        //        self.importButton.frame = oldImportButtonFrame;
        
        // Output-View
        CGRect oldOutputRect = self.bottomTextField.frame;
        CGRect newOutputRect = oldOutputRect;
        newOutputRect.size.height = height;
        newOutputRect.origin.x = paddingX;
        newOutputRect.origin.y = (oldOutputRect.origin.y - (oldInputRect.origin.y + oldInputRect.size.height)) + newInputRect.origin.y + newInputRect.size.height;
        self.bottomTextField.frame = newOutputRect;
        
        //        // Switch-Button
        //        CGRect oldSwitchButtonFrame = self.switchButton.frame;
        //        oldSwitchButtonFrame.origin.y = ceil((self.bottomTextField.frame.origin.y - (self.topTextField.frame.origin.y + self.topTextField.frame.size.height))/2) + self.topTextField.frame.origin.y + self.topTextField.frame.size.height - ceil(oldSwitchButtonFrame.size.height/2);
        //        self.switchButton.frame = oldSwitchButtonFrame;
        
        //        // Export-Button
        //        CGRect oldExportButtonFrame = self.exportButton.frame;
        //        oldExportButtonFrame.origin.y = newOutputRect.origin.y + newOutputRect.size.height - oldExportButtonFrame.size.height;
        //        oldExportButtonFrame.origin.y += 8;
        //        self.exportButton.frame = oldExportButtonFrame;
        
        if ([self.topTextField isFirstResponder])
        {
            [self shrinkTextViews];
        }
        else
        {
            [self expandTextViews];
        }
        
        
        CGRect sliderFrame = self.slider.frame;
        sliderFrame.origin.x = paddingX;
        self.slider.frame = sliderFrame;
        
        [self centerButtonsForWidth:INPUT_WIDTH_IPAD andPadding:paddingX];
    }
}

// iOS 6
- (BOOL) shouldAutorotate
{
    DLogFuncName();
    return (!IS_IPHONE);
}

// iOS2 - iOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    DLogFuncName();
    return (!IS_IPHONE);
}

// iOS 3 >
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    DLogFuncName();
    if (IS_IPAD)
    {
        [self setInterfaceOrientation:toInterfaceOrientation];
    }
}

// wird auch aufgerufen wenn shrink und expand gemacht wurde ... :(
- (void) viewWillLayoutSubviews
{
    DLogFuncName();
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView == self.clipboardAlertView)
        {
            [[UIPasteboard generalPasteboard] containsPasteboardTypes:UIPasteboardTypeListString];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            if (pasteboard.string != nil)
            {
                [self updateInputFromPasteBoardString:pasteboard.string];
            }
        }
        else if (alertView == self.ignoreClipboardAlertView)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERDEFAULTS_CLIPOARD_INPUT];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (buttonIndex == alertView.cancelButtonIndex && alertView == self.clipboardAlertView)
    {
#warning TODO - Internationalisation
        self.ignoreClipboardAlertView = [[UIAlertView alloc] initWithTitle:@"Ignore clipboard" message:@"Should I ignore clipboard's content for the future?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [self.ignoreClipboardAlertView show];
    }
}


- (void) updateInputFromPasteBoardString:(NSString*)pasteboardString
{
    DLogFuncName();
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         if (self.convertToLeet)
                         {
                             self.input.backgroundColor = APP_BACKGROUND_COLOR;
                         }
                         else
                         {
                             self.output.backgroundColor = [UIColor whiteColor];
                         }
                     }
                     completion:^(BOOL finished){
                         if (self.convertToLeet)
                         {
                             self.input.backgroundColor =  [UIColor whiteColor];
                             self.input.text = pasteboardString;
                         }
                         else
                         {
                             self.output.backgroundColor = APP_BACKGROUND_COLOR;
                             self.output.text = pasteboardString;
                         }
                         [self transformInput];
                     }];
}


#pragma mark - Slider
/**
 Slider weakness
 @param sender <#sender description#>
 */
- (void)handleTap:(UITapGestureRecognizer *)sender {
    DLogFuncName();
    if (sender.state == UIGestureRecognizerStateEnded)
    {         // handling code
        CGPoint loc = [sender locationInView:self.slider];
        DLogPoint(loc);
        CGRect frame = [self.slider thumbRectForBounds:self.slider.bounds trackRect:self.slider.bounds value:self.slider.value];
        DLogRect(frame);
        if (frame.origin.x < loc.x)
        {
            if (self.slider.value < self.slider.maximumValue)
            {
                [self.slider setValue:self.slider.value+1];
                [self valueChanged:self.slider];
            }
        }
        else if (frame.origin.x > loc.x)
        {
            if (self.slider.value > self.slider.minimumValue)
            {
                [self.slider setValue:self.slider.value-1];
                [self valueChanged:self.slider];
            }
        }
        
    }
}


- (void)updateSliderValue
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    self.slider.value = [[NSUserDefaults standardUserDefaults] integerForKey:USERDEFAULTS_LEET_STRENGTH];
    
    [self updateStrengthImage];
    [self transformInput];
}


-(void)valueChanged:(id)sender {
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    // This determines which "step" the slider should be on. Here we're taking
    //   the current position of the slider and dividing by the `self.stepValue`
    //   to determine approximately which step we are on. Then we round to get to
    //   find which step we are closest to.
    int newStep = ceil(self.slider.value);
    
    // Convert "steps" back to the context of the sliders values.
    self.slider.value = newStep;
    

    [[PSUserDefaults sharedPSUserDefaults] setLevel:self.slider.value];
    
    [self updateStrengthImage];
    [self transformInput];
}


- (void) updateStrengthImage
{
    DLogFuncName();
    //    if (self.slider.value == 8)
    //    {
    //        self.strengthImage.alpha = 1.0;
    //    }
    //    else
    //    {
    //        self.strengthImage.alpha = ((100 / 50) * self.slider.value) / 10;
    //        self.strengthImage.alpha = 1 - (self.slider.value / self.slider.maximumValue);
    self.strengthImage.alpha = (100 / (self.slider.maximumValue / self.slider.value))/100;
    //    }
}



#pragma mark - Button Actions
- (void)switchButtonTouched:(id)sender
{
    DLogFuncName();
    [[PSUserDefaults sharedPSUserDefaults] incrementSwitchButtonTouches];
    
    [self setConvertToLeet:!_convertToLeet];
    
    CGRect inputFrame = self.input.frame;
    
    CGRect outputFrame = self.output.frame;
    
    BOOL inputWasActive = (self.editingTextView != nil && self.editingTextView == self.input);
    BOOL outputWasActive = (self.editingTextView != nil && self.editingTextView == self.output);
    
    DLog(@"inputWasActive = %d, outputWasActive = %d",inputWasActive,outputWasActive);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.input.frame = outputFrame;
                         self.output.frame = inputFrame;
                         
                         CGAffineTransform xform = CGAffineTransformMakeRotation(M_PI*self.rotationCounter*(-1));
                         self.switchButton.transform = xform;
                         [self.switchButton setNeedsDisplay];
                         self.rotationCounter++;
                     }
                     completion:^(BOOL finished){
                         if (finished)
                         {
                             self.output.editable = !self.convertToLeet;
                             self.input.editable = self.convertToLeet;
                             
                             [self.output setCanBecomeFirstResponder:!self.convertToLeet];
                             [self.input setCanBecomeFirstResponder:self.convertToLeet];
                             
                             if (inputWasActive)
                             {
                                 [self.output becomeFirstResponder];
                             }
                             
                             if (outputWasActive)
                             {
                                 [self.input becomeFirstResponder];
                             }
                             
//                             CGAffineTransform xform = CGAffineTransformMakeRotation(M_PI*2);
//                             self.switchButton.transform = xform;
//                             [self.switchButton setNeedsDisplay];
                             
                             [self transformInput];
                         }
                     }];
    
}

// This is the "valueChanged" method for the UISlider. Hook this up in
//   Interface Builder.
- (void)clearButtonTouched:(id)sender {
    DLogFuncName();
    self.input.text = @"";
    self.output.text = @"";
    
    [[PSUserDefaults sharedPSUserDefaults] incrementClearButtonTouches];
}


- (void)importButtonTouched:(id)sender {
    DLogFuncName();
    [[UIPasteboard generalPasteboard] containsPasteboardTypes:UIPasteboardTypeListString];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string != nil)
    {
        [self updateInputFromPasteBoardString:pasteboard.string];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Nothing in clipboard alert description",nil)];
    }
    
    [[PSUserDefaults sharedPSUserDefaults] incrementImportButtonTouches];
}


- (void)exportButtonTouched:(id)sender {
    DLogFuncName();
    [self export];
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Added to clipboard alert description",nil)];
    [[PSUserDefaults sharedPSUserDefaults] incrementExportButtonTouches];
}


- (void)mailButtonTouched:(id)sender {
    DLogFuncName();
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));

    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail])
        {
            self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
            self.mailComposeViewController.mailComposeDelegate = self;
            [self.mailComposeViewController setMessageBody:self.bottomTextField.text isHTML:NO];
            //        self.mailcomposerViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            

//            [self.mailComposeViewController addAttachmentData:[self.bottomTextField.text dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"l33t" fileName:@"Open With l33t-App"];
            [self presentViewController:self.mailComposeViewController animated:YES completion:nil];
            
            
            
            // Bugfix damit AbbrechenButton tastatur dismissen kann ...
            self.mailComposeViewController.view.superview.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin;
            if (IS_IPAD)
            {
                self.mailComposeViewController.view.superview.frame = CGRectMake(
                                                                                  self.mailComposeViewController.view.superview.frame.origin.x,
                                                                                  self.mailComposeViewController.view.superview.frame.origin.y,
                                                                                  540.0f,
                                                                                  480.0f);
                
                //    UIViewController *splitViewController = [[OBGAppDelegate sharedInstance] splitViewController];
                CGRect bounds = [self.view bounds];
                CGPoint centerPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
                
                self.mailComposeViewController.view.superview.center = centerPoint;
            }
        }
        else
        {
//            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device not configured to send mail",nil) duration:APP_ERROR_DURATION_TIMERINTERVAL];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device not configured to send mail",nil)];
        }
    }
    else
    {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device not configured to send mail",nil) duration:APP_ERROR_DURATION_TIMERINTERVAL];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device not configured to send mail",nil)];
    }

    [[PSUserDefaults sharedPSUserDefaults] incrementMailButtonTouches];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    DLogFuncName();
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];

    switch (result) {
        case MFMailComposeResultCancelled:
//            alert.message = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
//            alert.message = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
//            alert.message = @"Result: Mail sent";
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Mail sent",nil)];
            break;
        case MFMailComposeResultFailed:
//            alert.message = @"Result: Mail sending failed";
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Mail sending failed",nil)];
            break;
        default:
//            alert.message = @"Result: Mail not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    [alert show];
}


-(void)chatButtonTouched:(id)sender
{
//    ATConnect *connection = [ATConnect sharedConnection];
//    connection.shouldTakeScreenshot = YES;
//    [connection presentFeedbackControllerFromViewController:self];
    
    return;
    DLogFuncName();
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass != nil) {
        if ([MFMessageComposeViewController canSendText])
        {
            self.messageComposeViewController = [[MFMessageComposeViewController alloc] init];
            self.messageComposeViewController.messageComposeDelegate = self;
            [self.messageComposeViewController setBody: self.bottomTextField.text];        
            [self presentViewController:self.messageComposeViewController animated:YES completion:nil];
            
            // Bugfix damit AbbrechenButton tastatur dismissen kann ...
            self.messageComposeViewController.view.superview.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin;
            if (IS_IPAD)
            {
                self.messageComposeViewController.view.superview.frame = CGRectMake(
                                                                                 self.messageComposeViewController.view.superview.frame.origin.x,
                                                                                 self.messageComposeViewController.view.superview.frame.origin.y,
                                                                                 540.0f,
                                                                                 480.0f);
                
                //    UIViewController *splitViewController = [[OBGAppDelegate sharedInstance] splitViewController];
                CGRect bounds = [self.view bounds];
                CGPoint centerPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
                
                self.messageComposeViewController.view.superview.center = centerPoint;
            }
        }
        else
        {
//            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device not configured to send SMS",nil) duration:APP_ERROR_DURATION_TIMERINTERVAL];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device not configured to send SMS",nil)];
        }
    }
    else
    {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device not configured to send SMS",nil) duration:APP_ERROR_DURATION_TIMERINTERVAL];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device not configured to send SMS",nil)];
    }
    
    [[PSUserDefaults sharedPSUserDefaults] incrementChatButtonTouches];
}


// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    DLogFuncName();
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];

	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
//			alert.message = @"Result: SMS sending canceled";
			break;
		case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Message sent",nil)];
//			alert.message = @"Result: SMS sent";
			break;
		case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Message sending failed",nil)];
//			alert.message = @"Result: SMS sending failed";
			break;
		default:
//			alert.message = @"Result: SMS not sent";
			break;
	}
//	[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [alert show];
}


#pragma mark - UITextViewDelegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    DLogFuncName();
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    [textView becomeFirstResponder];
    
    self.editingTextView = (PSTextView*)textView;
    
    [self shrinkTextViewsWithAnimation:YES];
}


- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    DLogFuncName();
    return YES;
}


- (void) textViewDidEndEditing:(UITextView *)textView
{
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    [textView resignFirstResponder];
    
    self.editingTextView = nil;
    
    [self expandTextViewsWithAnimation:YES];
    [self exportOutput];
    [[iRate sharedInstance] logEvent:YES];

}


- (void)textViewDidChange:(UITextView *)textView
{
    DLogFuncName();
    //    NSLog(@"%@",textView.text);
}


- (void)textViewDidChangeSelection:(UITextView *)textView
{
    DLogFuncName();
    //    NSLog(@"%@",textView.text);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    DLogFuncName();
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCREENSAVER_RESET_TIMER object:nil];
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    BOOL change = NO;
    if ([[text lowercaseString] isEqualToString:@"??"])
    {
        text = @"ae";
        change = YES;
    }
    
    
    if ([[text lowercaseString] isEqualToString:@"??"])
    {
        text = @"oe";
        change = YES;
    }
    
    
    if ([[text lowercaseString] isEqualToString:@"??"])
    {
        text = @"ue";
        change = YES;
    }
    
    if ([[text lowercaseString] isEqualToString:@"??"])
    {
        text = @"ss";
        change = YES;
    }
    
    if (change)
    {
        NSString * old = self.input.text;
        NSRange newRange = NSMakeRange(range.location, range.length);
        self.input.text = [old stringByReplacingCharactersInRange:range withString:text];
        return NO;
    }
    

    
    DLog(@"Input = %@",text);
    NSLog(@"Change = %d",change);
    [self transformInput:text withRange:range];
    
    if (change)
    {
        return NO;
    }
//    self.input.text = [self.input.text lowercaseString];
//    textView.text = [textView.text lowercaseString];
    self.input.text = [[self.input.text stringByReplacingCharactersInRange:range withString:text] lowercaseString];
    NSLog(@"Input Text = |%@|",self.input.text);
    
    return YES;
}

#pragma mark - UITextView Optic
- (void)shrinkTextViewsWithAnimation:(BOOL)animation
{
    DLogFuncName();
    if (animation)
    {
        [UIView animateWithDuration:0.5
                              delay:0.5
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self shrinkTextViews];
                             
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    else
    {
        [self shrinkTextViews];
    }
}


- (void)shrinkTextViews{
    DLogFuncName();
    
    int height = 0;
    if (IS_IPAD)
    {
        if (IS_LANDSCAPE)
        {
            height = INPUT_HEIGHT_IPAD_MIN_L;
        }
        else
        {
            height = INPUT_HEIGHT_IPAD_MIN_P;
        }
    }
    else if (IS_IPHONE_5)
    {
        height = INPUT_HEIGHT_IPHONE5_MIN;
    }
    else
    {
        height = INPUT_HEIGHT_IPHONE_MIN;
    }
    
    // Input-View
    CGRect oldInputRect = self.topTextField.frame;
    CGRect newInputRect = oldInputRect;
    newInputRect.size.height = height;
    self.topTextField.frame = newInputRect;
    
    // Import-Button
    CGRect oldImportButtonFrame = self.importButton.frame;
    oldImportButtonFrame.origin.y = newInputRect.origin.y + newInputRect.size.height - oldImportButtonFrame.size.height;
    oldImportButtonFrame.origin.y += 8;
    self.importButton.frame = oldImportButtonFrame;
    
    // Output-View
    CGRect oldOutputRect = self.bottomTextField.frame;
    CGRect newOutputRect = oldOutputRect;
    newOutputRect.size.height = height;
    newOutputRect.origin.y = (oldOutputRect.origin.y - (oldInputRect.origin.y + oldInputRect.size.height)) + newInputRect.origin.y + newInputRect.size.height;
    self.bottomTextField.frame = newOutputRect;
    
    // Switch-Button
    CGRect oldSwitchButtonFrame = self.switchButton.frame;
    oldSwitchButtonFrame.origin.y = ceil((self.bottomTextField.frame.origin.y - (self.topTextField.frame.origin.y + self.topTextField.frame.size.height))/2) + self.topTextField.frame.origin.y + self.topTextField.frame.size.height - ceil(oldSwitchButtonFrame.size.height/2);
    self.switchButton.frame = oldSwitchButtonFrame;
    
    // Export-Button
    CGRect oldExportButtonFrame = self.exportButton.frame;
    oldExportButtonFrame.origin.y = newOutputRect.origin.y + newOutputRect.size.height - oldExportButtonFrame.size.height;
    oldExportButtonFrame.origin.y += 8;
    self.exportButton.frame = oldExportButtonFrame;
    
    CGRect tmpButtonFrame = oldExportButtonFrame;
//    tmpButtonFrame.origin.y = oldExportButtonFrame.origin.y - self.exportButton.frame.size.height - 10;
    tmpButtonFrame.origin.y = self.bottomTextField.frame.origin.y  + (ceil(self.bottomTextField.frame.size.height / 2)) - ceil(self.exportButton.frame.size.height / 2);
    self.mailButton.frame = tmpButtonFrame;
    
    tmpButtonFrame.origin.y = self.bottomTextField.frame.origin.y - 8; // - self.mailButton.frame.size.height - 10;
    self.chatButton.frame = tmpButtonFrame;
}


- (void) expandTextViewsWithAnimation:(BOOL)animation;
{
    DLogFuncName();
    if (animation)
    {
        [UIView animateWithDuration:0.5
                              delay:0.5
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self expandTextViews];
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    else
    {
        [self expandTextViews];
    }
}


- (void) expandTextViews
{
    DLogFuncName();
    int height = 0;
    if (IS_IPAD)
    {
        if (IS_LANDSCAPE)
        {
            height = INPUT_HEIGHT_IPAD_MAX_L;
        }
        else
        {
            height = INPUT_HEIGHT_IPAD_MAX_P;
        }
    }
    else if (IS_IPHONE_5)
    {
        height = INPUT_HEIGHT_IPHONE5_MAX;
    }
    else
    {
        height = INPUT_HEIGHT_IPHONE_MAX;
    }
    
    // Top-View
    CGRect oldInputRect = self.topTextField.frame;
    CGRect newInputRect = oldInputRect;
    newInputRect.size.height = height;
    self.topTextField.frame = newInputRect;
    
    // Import-Button
    CGRect oldImportButtonFrame = self.importButton.frame;
    oldImportButtonFrame.origin.y = self.topTextField.frame.origin.y + self.topTextField.frame.size.height - oldImportButtonFrame.size.height;
    oldImportButtonFrame.origin.y += 8;
    self.importButton.frame = oldImportButtonFrame;
    
    // Output-View
    CGRect oldOutputRect = self.bottomTextField.frame;
    CGRect newOutputRect = oldOutputRect;
    newOutputRect.size.height = height;
    newOutputRect.origin.y = oldOutputRect.origin.y - (oldInputRect.origin.y + oldInputRect.size.height) + newInputRect.origin.y + newInputRect.size.height;
    self.bottomTextField.frame = newOutputRect;
    
    // Switch-Button
    CGRect oldSwitchButtonFrame = self.switchButton.frame;
    oldSwitchButtonFrame.origin.y = ceil((self.bottomTextField.frame.origin.y - (self.topTextField.frame.origin.y + self.topTextField.frame.size.height))/2) + self.topTextField.frame.origin.y + self.topTextField.frame.size.height - ceil(oldSwitchButtonFrame.size.height/2);
    self.switchButton.frame = oldSwitchButtonFrame;
    
    // Export-Button
    CGRect oldExportButtonFrame = self.exportButton.frame;
    oldExportButtonFrame.origin.y = newOutputRect.origin.y + newOutputRect.size.height - oldExportButtonFrame.size.height;
    oldExportButtonFrame.origin.y += 8;
    self.exportButton.frame = oldExportButtonFrame;
    
    CGRect tmpButtonFrame = oldExportButtonFrame;
//    tmpButtonFrame.origin.y = oldExportButtonFrame.origin.y - self.exportButton.frame.size.height - 10;
    tmpButtonFrame.origin.y = self.bottomTextField.frame.origin.y  + (ceil(self.bottomTextField.frame.size.height / 2)) - ceil(self.exportButton.frame.size.height / 2);
    self.mailButton.frame = tmpButtonFrame;
    
    tmpButtonFrame.origin.y = self.bottomTextField.frame.origin.y - 8; // - self.mailButton.frame.size.height - 10;
    self.chatButton.frame = tmpButtonFrame;
}


#pragma mark - l33t
// Live update
- (void) transformInput:(NSString*) text withRange:(NSRange) range
{
    DLogFuncName();
    DLog(@"Input = |%@| Range.length = %d Range.location = %d",text, range.length, range.location);
    NSString * output;
    NSMutableString * string;
    NSMutableString * input;
//    if (_convertToLeet)
//    {
        string = [NSMutableString stringWithString:self.bottomTextField.text];
        input = [NSMutableString stringWithString:self.topTextField.text];
//    }
//    else
//    {
//        string = [NSMutableString stringWithString:self.input.text];
//        input = [NSMutableString stringWithString:self.output.text];
//    }
    
    [input replaceCharactersInRange:range withString:text];
    
    
    if (_convertToLeet)
    {
        output = leetConvert([[PSUserDefaults sharedPSUserDefaults] level], input);
    }
    else
    {
        output = convertLeet([[PSUserDefaults sharedPSUserDefaults] level], input);
    }
    
    [self setOutputText:output];
    [self checkEasterEggs:input];
}


- (void) transformInput
{
    DLogFuncName();
    NSString * output = @"";
    if (_convertToLeet)
    {
        output = leetConvert([[PSUserDefaults sharedPSUserDefaults] level], self.topTextField.text);
    }
    else
    {
        output = convertLeet([[PSUserDefaults sharedPSUserDefaults] level], self.topTextField.text);
    }
    
    [self setOutputText:output];
    [self exportOutput];
}


- (void) checkEasterEggs:(NSString*) input
{
    // Dispose of the sound
    // Play the sound
    
    BOOL isVany = NO;
    
    if ([[input lowercaseString] isEqualToString:@"vanessa zinke"])
    {
        isVany = YES;
    }
    
    if ([[input lowercaseString] isEqualToString:@"i love vanessa zinke"])
    {
        isVany = YES;
    }
    
    if ([[input lowercaseString] isEqualToString:@"ich liebe vanessa zinke"])
    {
        isVany = YES;
    }
    
    if ([[input lowercaseString] isEqualToString:@"ps+vz"])
    {
        isVany = YES;
    }
    
    if (isVany)
    {
        AudioServicesPlaySystemSound(_soundKiss);
    }
    
}


- (void) setOutputText:(NSString*)text
{
    DLogFuncName();
    
    self.bottomTextField.text = text;
}


#pragma mark - Export
- (void) exportOutput
{
    DLogFuncName();
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_CLIPOARD_OUTPUT])
    {
        [self export];
    }
}


- (void) export
{
    DLogFuncName();
    if (self.convertToLeet)
    {
        [[UIPasteboard generalPasteboard] setString:self.output.text];
    }
    else
    {
        [[UIPasteboard generalPasteboard] setString:self.input.text];
    }
    //        [[[UIAlertView alloc] initWithTitle:@"Added" message:@"Output was added to clipboard" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         if (self.convertToLeet)
                         {
                             self.bottomTextField.backgroundColor = [UIColor whiteColor];
                         }
                         else
                         {
                             self.bottomTextField.backgroundColor = [UIColor blackColor];
                         }
                     }
                     completion:^(BOOL finished){
                         if (self.convertToLeet)
                         {
                             self.bottomTextField.backgroundColor =  APP_BACKGROUND_COLOR;
                         }
                         else
                         {
                             self.bottomTextField.backgroundColor = [UIColor whiteColor];
                         }
                     }];
}
    
@end
