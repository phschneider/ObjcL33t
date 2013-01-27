//
//  PSAlphaBetViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 03.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#define kVALUE_TAG          200
#define kLABEL_TAG          100

#define kNUMBER_OF_ROWS     9
#define kNUMBER_OF_OBJECTS  26

#define kINDEX_LABEL_WIDTH  46
#define kVALUE_LABEL_WIDTH  30

#define kINDEX_LABEL_WIDTH_IPAD  100
#define kVALUE_LABEL_WIDTH_IPAD  30

#define kFONT_SIZE          20
#define kVALUE_FONT         [UIFont boldSystemFontOfSize:kFONT_SIZE];
#define kFONT               [UIFont fontWithName:@"Bookman Old Style Bold" size:kFONT_SIZE];
#define kTEXT_COLOR         [UIColor whiteColor];
#define kSEPERATOR_COLOR    [UIColor colorWithWhite: 1 alpha: 1];

#import "leet.h"
#import "PSAlphaBetCell.h"
#import "PSAlphaBetViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PSAlphaBetViewController ()

@end

@implementation PSAlphaBetViewController

@synthesize strengthImage               = _strengthImage;

static NSString* alphabet[kNUMBER_OF_OBJECTS] =
    {@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l",
		@"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x",
		@"y", @"z"};


- (id)init
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    self = [super init];
    if (self) {
        self.trackedViewName = @"Alphabet Screen";
        self.title = NSLocalizedString(@"A-Z TabBar Title", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"white-40-dialpad"];

//        self.view.backgroundColor = APP_BACKGROUND_COLOR;
        
        int width, height, paddingX, paddingY;
        if (IS_IPAD)
        {
            width = 601;
            paddingX = ceil((768-601)/2);
            paddingY = paddingX;
            
//            width = 768-(2*padding);

            height = 500;
        }
        else if (IS_IPHONE_5)
        {
            paddingX = paddingY = 20;
//            width = 320-(2*padding);
            width = 277;
            height = 400;
        }
        else
        {
            paddingX = paddingY = 20;//            width = 320-(2*padding);
            width = 277;
            height = width;
        }

        CGRect tableViewFrame = CGRectMake(paddingX,paddingY,width,height);
        self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.userInteractionEnabled = NO;
        [self.view addSubview:self.tableView];

        
        CGRect sliderFrame = CGRectMake(paddingX, self.view.frame.size.height - 24 - paddingY, width, 24);
        
        self.slider = [[UISlider alloc] initWithFrame:sliderFrame];
        [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 8;
        self.slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        self.tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.slider addGestureRecognizer:self.tapGestureRecognizer];
        
        [self.view addSubview:self.slider];
        
        
//        CGPoint buttonCenter = self.slider.center;
//        CGRect buttonFrame;
//        buttonCenter.x = ceil((self.view.frame.size.width - (self.slider.frame.origin.x + self.slider.frame.size.width))/2)+width+paddingX;
//        self.strengthImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white-89-dumbells"]];
//        buttonFrame = self.strengthImage.frame;
//        self.strengthImage.frame = buttonFrame;
//        self.strengthImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        
//        self.strengthImage.center = buttonCenter;
//        [self.view addSubview:self.strengthImage];
        
        DLogFrame(self.slider);
        DLogFrame(self.view);

        self.view.backgroundColor = APP_BACKGROUND_COLOR;
        
        tableQueue = dispatch_queue_create("net.phschneider.leet.tablequeue", NULL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSliderValue) name:USERDEFAULTS_LEET_STRENGTH_CHANGES object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    [super viewDidLoad];
        
    self.tableView.rowHeight = floor(self.tableView.frame.size.height / kNUMBER_OF_ROWS)-1;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(1,0, 0, 0);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
}

- (void)viewDidAppear:(BOOL)animated {
    DLogFuncName();
    [super viewDidAppear:animated];
    [APPDELEGATE resetScreenSaverTimer];
    [self updateSliderValue];
}


- (void)viewDidUnload {
    DLogFuncName();
    [self setTableView:nil];
    [self setSlider:nil];
    [super viewDidUnload];
}


#pragma mark - Rotation
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


- (void) viewWillLayoutSubviews
{
    DLogFuncName();
    if (IS_IPAD)
    {
        int width, height, paddingX, paddingY;
        if (  UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            width = 601;
            paddingX = ceil((1024-601)/2);
            paddingY = ceil((768-601)/2);
            height = 500;

        }
        else
        {
            width = 601;
            paddingX = ceil((768-601)/2);
            paddingY = ceil((768-601)/2);
            height = 500;
        }
        
        CGRect tableViewFrame = CGRectMake(paddingX,paddingY,width,height);
        self.tableView.frame = tableViewFrame;
        CGRect sliderFrame = CGRectMake(paddingX, self.view.frame.size.height - 24 - paddingY, width, 24);
        self.slider.frame = sliderFrame;
    }
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
    [APPDELEGATE resetScreenSaverTimer];
    self.slider.value = [[NSUserDefaults standardUserDefaults] integerForKey:USERDEFAULTS_LEET_STRENGTH];
    [self.tableView reloadData];
}



-(void)valueChanged:(id)sender {
    DLogFuncName();
    [APPDELEGATE resetScreenSaverTimer];
    
    // This determines which "step" the slider should be on. Here we're taking
    //   the current position of the slider and dividing by the `self.stepValue`
    //   to determine approximately which step we are on. Then we round to get to
    //   find which step we are closest to.
    int newStep = ceil(self.slider.value);
    
    // Convert "steps" back to the context of the sliders values.
    self.slider.value = newStep;
    
    [[NSUserDefaults standardUserDefaults] setInteger:newStep forKey:USERDEFAULTS_LEET_STRENGTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USERDEFAULTS_LEET_STRENGTH_CHANGES object:nil];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    DLogFuncName();
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLogFuncName();
    return kNUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLogFuncName();
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    int c = 0;
    int level = self.slider.value;
    UILabel *label;
    NSString * string;
    
    int width = (IS_IPHONE) ? kINDEX_LABEL_WIDTH : kINDEX_LABEL_WIDTH_IPAD;
    
    
    if (cell == nil) {
        ///////////////////////////////////////first
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
        [cell.contentView addSubview: [self sep:0]];
        
        label = [self keyLab];
        label.frame = CGRectMake(c*width, 0, width,tableView.rowHeight);
        label.tag = c+1;

        c++;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview: [self sep: width*c]];
    
        label = [self valueLab];
        label.frame = CGRectMake(width*c, 0, width,tableView.rowHeight);
        label.tag = c+1;
        
        c++;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview: [self sep: width*c]];

    
        ///////////////////////////////////////second
        label = [self keyLab];
        label.frame = CGRectMake(width*c, 0, width,tableView.rowHeight);
        label.tag = c+1;
        
        c++;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview: [self sep: width*c]];
    
    
        label = [self valueLab];
        label.frame = CGRectMake(width*c, 0, width,tableView.rowHeight);
        label.tag = c+1;

        c++;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview: [self sep: width*c]];

    
    
        /////////////////////////////////////// third
        label = [self keyLab];
        label.frame = CGRectMake(width*c, 0, width,tableView.rowHeight);
        label.tag = c+1;

        c++;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview: [self sep: width*c]];
    
        label = [self valueLab];
        label.frame = CGRectMake(width*c, 0, width,tableView.rowHeight);
        label.tag = c+1;
        
        c++;
        [cell.contentView addSubview:label];
        [cell.contentView addSubview: [self sep: width*c]];

    }
    
    if (indexPath.row < kNUMBER_OF_OBJECTS)
    {
        label = (UILabel*)[cell.contentView viewWithTag:1];
        string = alphabet[indexPath.row];
        label.text = string;
        label = nil;
        
        label = (UILabel*)[cell.contentView viewWithTag:2];
        label.opaque = YES;
        label.alpha = 0;

        dispatch_async(tableQueue, ^{
            
            NSString * leet = leetConvert(level, string);
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = leet;
            });
        });
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             label.alpha = 1.0;
                          
                             UIColor *color = [UIColor whiteColor];
                             label.layer.shadowColor = [color CGColor];
                             label.layer.shadowRadius = 4.0f;
                             label.layer.shadowOpacity = .9;
                             label.layer.shadowOffset = CGSizeZero;
                             label.layer.masksToBounds = NO;

                         }
                         completion:^(BOOL finished){
                             label.alpha = 1;
//                             UIColor *color = [UIColor whiteColor];
//                             label.layer.shadowColor = [color CGColor];
//                             label.layer.shadowRadius = .0f;
//                             label.layer.shadowOpacity = .0;
//                             label.layer.shadowOffset = CGSizeZero;
//                             label.layer.masksToBounds = NO;
                             
                         }];
    }

    if (indexPath.row + kNUMBER_OF_ROWS < kNUMBER_OF_OBJECTS)
    {
        label = (UILabel*)[cell.contentView viewWithTag:3];
        string = alphabet[indexPath.row+kNUMBER_OF_ROWS];
        label.text = string;
        label = nil;
        
        label = (UILabel*)[cell.contentView viewWithTag:4];
        label.opaque = YES;
        label.alpha = 0;
//        UIColor *color = [UIColor whiteColor];
//        label.layer.shadowColor = [color CGColor];
//        label.layer.shadowRadius = 4.0f;
//        label.layer.shadowOpacity = .9;
//        label.layer.shadowOffset = CGSizeZero;
//        label.layer.masksToBounds = NO;

        dispatch_async(tableQueue, ^{
            
            NSString * leet = leetConvert(level, string);
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = leet;
            });
        });
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                            
                             label.alpha = 1.0;

                             UIColor *color = [UIColor whiteColor];
                             label.layer.shadowColor = [color CGColor];
                             label.layer.shadowRadius = 4.0f;
                             label.layer.shadowOpacity = .9;
                             label.layer.shadowOffset = CGSizeZero;
                             label.layer.masksToBounds = NO;

                         }
                         completion:^(BOOL finished){
                             label.alpha = 1;
//                             UIColor *color = [UIColor whiteColor];
//                             label.layer.shadowColor = [color CGColor];
//                             label.layer.shadowRadius = .0f;
//                             label.layer.shadowOpacity = .0;
//                             label.layer.shadowOffset = CGSizeZero;
//                             label.layer.masksToBounds = NO;
                             
                         }];
    }
    
    
    if (indexPath.row + kNUMBER_OF_ROWS + kNUMBER_OF_ROWS < kNUMBER_OF_OBJECTS)
    {
        label = (UILabel*)[cell.contentView viewWithTag:5];
        string = alphabet[indexPath.row+kNUMBER_OF_ROWS+kNUMBER_OF_ROWS];
        label.text = string;
        label = nil;
        
        label = (UILabel*)[cell.contentView viewWithTag:6];
        label.opaque = YES;
        label.alpha = 0;
  
        dispatch_async(tableQueue, ^{
            
            NSString * leet = leetConvert(level, string);
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = leet;
            });
        });
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             label.alpha = 1.0;
                             


                             
                             
                             UIColor *color = [UIColor whiteColor];
                             label.layer.shadowColor = [color CGColor];
                             label.layer.shadowRadius = 4.0f;
                             label.layer.shadowOpacity = .9;
                             label.layer.shadowOffset = CGSizeZero;
                             label.layer.masksToBounds = NO;
                         }
                         completion:^(BOOL finished){
                             label.alpha = 1;
                                                          
                         }];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"WillDisplay %@",indexPath);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DLogFuncName();
    if ([self numberOfSectionsInTableView:tableView] == (section+1)){
        return [UIView new];
    }
    return nil;
}


#pragma mark - Cell
- (UILabel*) lab
{
    DLogFuncName();
    UILabel * label = [[UILabel alloc] init];
//    label.tag = kLABEL_TAG;
    label.font = kFONT;
    label.textAlignment = UITextAlignmentCenter;
//    label.textColor = kTEXT_COLOR;
    label.backgroundColor = [UIColor clearColor];
//    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    return label;
}

- (UILabel*) keyLab
{
    DLogFuncName();
    UILabel * lab = [self lab];
    lab.textColor = [UIColor colorWithWhite: 1 alpha: 0.5];
    lab.font = kFONT;
    return lab;
}


- (UILabel*) valueLab
{
    DLogFuncName();
    UILabel * lab = [self lab];
    lab.textColor = [UIColor whiteColor];
    lab.font = kVALUE_FONT;
    return lab;
}


- (UIView *) sep: (int) x
{
    DLogFuncName();
	return [self sep: x tag: -1];
}


- (UIView *) sep: (int) x tag: (int) tag
{
    DLogFuncName();
	UIView *sep = [[UIView alloc] initWithFrame: CGRectMake(x, 0, 1, self.tableView.rowHeight - 1)];
	sep.backgroundColor = kSEPERATOR_COLOR;
	if (tag != -1) sep.tag = tag;
	return sep;
}

@end
