//
//  PSWizzardViewController.m
//  leetspeak
//
//  Created by Philip Schneider on 20.01.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import "StyledPageControl.h"

#import "PSWizzardViewController.h"
#import "PSWizzardModel.h"
#import "PSWizzardView.h"


@interface PSWizzardViewController ()

@end

@implementation PSWizzardViewController


- (id) init{

    self = [super init];
    if (self)
    {
        CGRect mainScreenRect = [[UIScreen mainScreen] applicationFrame];
        
        DLogRect(mainScreenRect);
        
        int pageControlHeight = 80;
        
//        self.view.backgroundColor = [UIColor purpleColor];
        self.view.alpha = 1.0;
//        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.opaque = YES;
        
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20,self.view.frame.size.width-40, 60)];
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:40];
//        self.titleLabel.textAlignment = UITextAlignmentCenter;
//        self.titleLabel.text = @"Einführung";
//        self.titleLabel.textColor = [UIColor whiteColor];
//        self.titleLabel.backgroundColor = [UIColor clearColor];
//        self.titleLabel.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
//        self.titleLabel.layer.shadowOffset = CGSizeMake(5,5);
//        self.titleLabel.layer.masksToBounds = NO;
//        self.titleLabel.layer.opacity = YES;
//        self.titleLabel.layer.shouldRasterize = YES;
//        self.titleLabel.layer.shadowOpacity = 1.0;
//        [self.view addSubview:self.titleLabel];
        
        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.view.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
//        [self.view.layer insertSublayer:gradient atIndex:0];
//        

        CAGradientLayer *gradient = [CAGradientLayer layer];
        if (IS_IPAD)
        {
            gradient.frame = CGRectMake(0,0,1024,1024);
        }
        else
        {
            gradient.frame = self.view.bounds;
        }
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite: 0.0 alpha:0.5] CGColor],
                           (id)[[UIColor colorWithWhite: 0.0 alpha:1.0] CGColor], nil];
        gradient.startPoint = CGPointMake(0.5, 0.0); // default; bottom of the view
        gradient.endPoint = CGPointMake(0.5, 1.0);   // default; top of the view
        [self.view.layer insertSublayer:gradient atIndex:0];
        
        
        self.wizzardArray = @[ [[PSWizzardModel alloc] initWithTitle:NSLocalizedString(@"Clear", @"") subTitle:NSLocalizedString(@"Clear Button AccessibiltyHint", @"") imageName:@"white-298-circlex"],
                               [[PSWizzardModel alloc] initWithTitle:NSLocalizedString(@"Import", @"") subTitle:NSLocalizedString(@"Import Button AccessibiltyHint", @"") imageName:@"white-265-download"],
                               [[PSWizzardModel alloc] initWithTitle:NSLocalizedString(@"Switch", @"") subTitle:NSLocalizedString(@"Switch Button AccessibiltyHint", @"") imageName:@"white-288-retweet"],
                               [[PSWizzardModel alloc] initWithTitle:NSLocalizedString(@"Export", @"") subTitle:NSLocalizedString(@"Export Button AccessibiltyHint", @"") imageName:@"white-266-upload"],
                               [[PSWizzardModel alloc] initWithTitle:NSLocalizedString(@"Mail", @"") subTitle:NSLocalizedString(@"Mail Button AccessibiltyHint", @"") imageName:@"white-18-envelope"],
                               [[PSWizzardModel alloc] initWithTitle:NSLocalizedString(@"Chat", @"") subTitle:NSLocalizedString(@"Chat Button AccessibiltyHint", @"") imageName:@"white-08-chat"],
                               [[PSWizzardModel alloc] initWithTitle:NSLocalizedString(@"Strength", @"") subTitle:NSLocalizedString(@"Slider Button AccessibiltyHint", @"") imageName:@"white-89-dumbells"]
                               ];
        

        
        
        mainScreenRect = [[UIScreen mainScreen] applicationFrame];
//        self.view.frame=mainScreenRect;
        DLogRect(mainScreenRect);
        mainScreenRect.origin.y = mainScreenRect.size.height - pageControlHeight;
        mainScreenRect.size.height = pageControlHeight;
        mainScreenRect.origin.x = 50;
        mainScreenRect.size.width -= 100;
        DLogRect(mainScreenRect);
        
        self.pageControl = [[StyledPageControl alloc] initWithFrame:mainScreenRect];
        self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
//        self.pageControl.backgroundColor = [UIColor blueColor];
        self.pageControl.pageControlStyle = PageControlStyleDefault;
        self.pageControl.diameter = 14;
        self.pageControl.numberOfPages = [self.wizzardArray count];
        self.pageControl.currentPage = 0;
        self.pageControl.backgroundColor = [UIColor clearColor];
//        self.pageControl.userInteractionEnabled = NO;
        self.pageControl.coreSelectedColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
        [self.view addSubview:self.pageControl];
        
        mainScreenRect = self.view.bounds;
//        mainScreenRect = [[UIScreen mainScreen] applicationFrame];
        mainScreenRect.origin.y = 0;
//        mainScreenRect.size.height -= 50;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:mainScreenRect];
//        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.opaque = YES;
//        self.scrollView.backgroundColor = [UIColor redColor];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:self.scrollView];

        DLogFrame(self.scrollView);

//        mainScreenRect = [[UIScreen mainScreen] applicationFrame];
//        DLogRect(mainScreenRect);
//        mainScreenRect.origin.y = mainScreenRect.size.height - 44;
//        DLogRect(mainScreenRect);
//        
//        self.toolbar = [[UIToolbar alloc] initWithFrame:mainScreenRect];
//        self.toolbar.barStyle = UIBarStyleBlack;
//        self.toolbar.tintColor = [UIColor darkGrayColor];
//        
//        UIBarButtonItem * nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStyleDone target:self action:@selector(next:)];
//        UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIBarButtonItem * prevButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(prev:)];
//        prevButton.enabled = NO;
//        
//        [self.toolbar setItems:@[prevButton, flexibleSpace, nextButtonItem]];
//        
//        [self.toolbar sizeToFit];
//        [self.view addSubview:self.toolbar];
//        
//        [self checkButtons];
        
        
//        self.nextButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [self.nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
//        self.nextButton.frame = mainScreenRect;
//        self.nextButton.titleLabel.text = @"weiter";
//        self.nextButton.backgroundColor = [UIColor blueColor];
//        self.nextButton.center = CGPointMake(self.scrollView.frame.size.width - ceil((self.scrollView.frame.size.width - self.pageControl.frame.size.width)/2)  , self.pageControl.center.y);
           
        
        if (self.toolbar)
        {
            mainScreenRect = [[UIScreen mainScreen] applicationFrame];
            DLogRect(mainScreenRect);
            mainScreenRect.origin.y = mainScreenRect.size.height - pageControlHeight - 44;
            mainScreenRect.size.height = pageControlHeight;
            DLogRect(mainScreenRect);
            self.pageControl.frame = mainScreenRect;
        }
        
        float width = 0;
        int i=0;
        for (PSWizzardModel * model in self.wizzardArray)
        {
            i++;
            PSWizzardView * wizzardView = [[PSWizzardView alloc] initWithFrame:CGRectMake(width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) model:model];
            wizzardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            width += wizzardView.frame.size.width;
            [self.scrollView addSubview:wizzardView];
            
//            [self.scrollView setContentSize:(CGSizeMake(width, self.scrollView.frame.size.height))];
//            [self.scrollView scrollRectToVisible:[self rectForPage:i] animated:NO];
        }
        
        // Last Empty Page
        PSWizzardView * wizzardView = [[PSWizzardView alloc] initWithFrame:CGRectMake(width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) model:nil];
        wizzardView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        width += wizzardView.frame.size.width;
        [self.scrollView addSubview:wizzardView];
//        
        [self.scrollView setContentSize:(CGSizeMake(width, self.scrollView.frame.size.height))];
//        [self.scrollView scrollRectToVisible:[self rectForPage:i+1] animated:NO];
        
//        self.scrollView.contentOffset = CGPointMake(width-wizzardView.frame.size.width-wizzardView.frame.size.width,self.scrollView.frame.size.height);

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [self setInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    DLogFuncName();
//    [self performSelector:@selector(bounceScrollView) withObject:nil afterDelay:1.5];
}

- (void) bounceScrollView
{
    DLogFuncName();
//    [self vibrateAlert:.5];

//    [UIView beginAnimations:nil context:nil];
//    CGRect newFrame = viewToAnimate.frame;
//    newFrame.origin.x = snapBackXcoordinate;
//    viewToAnimate.frame = newFrame;
//    [UIView commitAnimations];
    
}


- (void)vibrateAlert:(float)seconds{
    DLogFuncName();
	self.canVibrate = TRUE;
    
	[self moveLeft];
	
	[self performSelector:@selector (stopVibration) withObject:nil afterDelay:seconds];
}


- (void)moveRight{
	DLogFuncName();
	if (self.canVibrate){
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.05];
		
		self.scrollView.transform = CGAffineTransformMakeTranslation(-100.0, 0.0);
		
		[UIView commitAnimations];
		
//		[self performSelector:@selector (moveLeft) withObject:nil afterDelay:0.05];
		
	}
	
}
- (void)moveLeft{
	DLogFuncName();
	if (self.canVibrate){
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.05];
        
        self.scrollView.transform = CGAffineTransformMakeTranslation(100.0, 0.0);
        
        [UIView commitAnimations];
        
        [self performSelector:@selector (moveRight) withObject:nil afterDelay:0.05];
		
	}
}

- (void)stopVibration{
	DLogFuncName();
	self.canVibrate = FALSE;
	
	self.scrollView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
    DLogFuncName();
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    DLog(@"page = %d",page);
    self.pageControl.currentPage = page;
    if (page +1 > [self.wizzardArray count])
    {
        [APPDELEGATE hideWizzard];
    }
    else
    {
        [self checkButtons];
    }
}

- (void) checkButtons
{
    DLogFuncName();
    NSArray * items = self.toolbar.items;
    if ([items count] > 0)
    {
        UIBarButtonItem * back = [items objectAtIndex:0];
        back.enabled = (self.pageControl.currentPage > 0);
        
        UIBarButtonItem * flexibleSpace = [items objectAtIndex:1];
        
        UIBarButtonItem * next = [items objectAtIndex:2];
        next.enabled = (self.pageControl.currentPage  < [self.wizzardArray count]);
        
        [self.toolbar setItems:@[back,flexibleSpace, next]];
    }
}


- (CGRect) rectForPage:(int)pageNumber
{
    DLogFuncName();
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGRect rect = CGRectMake(pageNumber * pageWidth, 0, pageWidth, self.scrollView.frame.size.height);
    return rect;
//    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

}


- (void) next:(id)sender
{
    DLogFuncName();
    if (self.pageControl.currentPage <= [self.wizzardArray count] +1 )
    {
        [self.scrollView scrollRectToVisible:[self rectForPage:self.pageControl.currentPage+1] animated:YES];
    }
}


- (void) prev:(id)sender
{
    DLogFuncName();
    if (self.pageControl.currentPage > 0)
    {
        [self.scrollView scrollRectToVisible:[self rectForPage:self.pageControl.currentPage-1] animated:YES];
    }
}

- (void) pageControlValueChanged:(id)sender
{
    DLogFuncName();
//    if (self.pageControl.currentPage > 0)
//    {
        [self.scrollView scrollRectToVisible:[self rectForPage:self.pageControl.currentPage] animated:YES];
//    }
}


#pragma mark - Rotation (iPad)
- (void) orientationDidChange:(NSNotification*) notification
{
    DLogFuncName();
    [self setInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [self setInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//}


- (void) setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DLogSize(self.scrollView.contentSize);
    DLogFrame(self.view);
    DLogFrame(self.scrollView);
    
    if (IS_IPAD)
    {
        CGRect mainScreenRect = [[UIScreen mainScreen] applicationFrame];
        float width = mainScreenRect.size.width; //self.view.bounds.size.width;
        float height = mainScreenRect.size.height;  //self.view.bounds.size.height;
        float x = 0;
        float y = 0;
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
        {
                width = 1024;
                height = 768;
        }
        else
        {
                width = 768;
                height = 1024;
        }
        
        self.scrollView.frame = CGRectMake(x,y, width,height);
        self.view.frame = CGRectMake(x,y, width,height);
        [self.scrollView setContentSize:(CGSizeMake(width*(self.pageControl.numberOfPages+1), height))];
        
        int i = 0;
        for (PSWizzardView * wizzardView in self.scrollView.subviews)
        {
            wizzardView.frame = CGRectMake(i*width,0, width, height);
            i++;
        }
        
        [self.scrollView scrollRectToVisible:[self rectForPage:self.pageControl.currentPage] animated:YES];
        
//        CAGradientLayer *gradient = [[self.view.layer sublayers] objectAtIndex:0];
//        gradient.frame = self.view.bounds;
//        gradient.colors = [NSArray arrayWithObjects:
//                           (id)[[UIColor colorWithWhite: 0.0 alpha:0.5] CGColor],
//                           (id)[[UIColor colorWithWhite: 0.0 alpha:1.0] CGColor], nil];
//        gradient.startPoint = CGPointMake(0.5, 0.0); // default; bottom of the view
//        gradient.endPoint = CGPointMake(0.5, 1.0);   // default; top of the view
        
    }
}

// iOS 6
- (BOOL) shouldAutorotate
{
    DLogFuncName();
    return (!IS_IPHONE);
}


//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    DLogFuncName();
//    [self setInterfaceOrientation:toInterfaceOrientation];
//}


// iOS2 - iOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    DLogFuncName();
    return (!IS_IPHONE);
}


// iOS 3 >
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    DLogFuncName();
//    if (IS_IPAD)
//    {
//        [self setInterfaceOrientation:toInterfaceOrientation];
//    }
//}

// wird auch aufgerufen wenn shrink und expand gemacht wurde ... :(
- (void) viewWillLayoutSubviews
{
    DLogFuncName();

    [self setInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

}


@end
