//
//  PSWizzardView.m
//  leetspeak
//
//  Created by Philip Schneider on 29.04.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSWizzardView.h"
#import "PSWizzardModel.h"

@implementation PSWizzardView


- (id)initWithFrame:(CGRect)frame
{
    DLogFuncName();
    self = [super initWithFrame:frame];
    if (self) {
        DLogRect(frame);
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        int padding = 20;
//        self.backgroundColor = [UIColor yellowColor];
        
        // Initialization code
        CGRect labelRect = CGRectMake(padding,ceil(frame.size.height /2)+80,frame.size.width-(2*padding), 40);
        self.titleLabel = [[UILabel alloc] initWithFrame:labelRect];
//        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
//        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:32];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];

        labelRect = CGRectMake(padding,ceil(frame.size.height /2)+120,frame.size.width-(2*padding), 100);
        self.subTitleLabel = [[UILabel alloc] initWithFrame:labelRect];
//        self.subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
//        self.subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.subTitleLabel.font = [UIFont systemFontOfSize:16];
        self.subTitleLabel.textAlignment = UITextAlignmentCenter;
        self.subTitleLabel.numberOfLines = 3;
        self.subTitleLabel.textColor = [UIColor whiteColor];
        self.subTitleLabel.backgroundColor = [UIColor clearColor];
        self.subTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:self.subTitleLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
//        self.subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.imageView];
    }
    return self;
}


- (id) initWithFrame:(CGRect)frame model:(PSWizzardModel*)model
{
    DLogFuncName();
    self = [self initWithFrame:frame];
    if (self)
    {
        if (model)
        {
            _model = model;
            DLogFrame(self.titleLabel);
            
            self.titleLabel.text = model.titleString;
            self.subTitleLabel.text = model.subTitleString;
                
            CGSize subtitleSize = [model.subTitleString sizeWithFont:self.subTitleLabel.font constrainedToSize:self.subTitleLabel.frame.size];
            DLogSize(subtitleSize);
            CGRect subtitleRect = self.subTitleLabel.frame;
            subtitleRect.size.height = subtitleSize.height;
            DLogFrame(self.subTitleLabel);
            self.subTitleLabel.frame = subtitleRect;
            

            DLogFrame(self.subTitleLabel);
            
            UIImage * image = [UIImage imageNamed: model.imageName];;
            CGSize imageSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0,self.bounds.origin.y,imageSize.width,imageSize.height);
            self.imageView.center = CGPointMake(ceil(self.bounds.size.width/2), ceil(self.bounds.size.height/2));
            CGRect imageFrame = self.imageView.frame;
            imageFrame.origin.y = self.titleLabel.frame.origin.y - imageFrame.size.height - 20;
            self.imageView.frame = imageFrame;
            
            DLogFrame(self.imageView);
            self.clipsToBounds = YES;

            self.imageFrame = self.imageView.frame;
        }
    }
    return self;
}


- (void) showBadge
{
    DLogFuncName();
    self.badge = [[UIView alloc] initWithFrame:CGRectZero];
    self.badge.backgroundColor = [UIColor clearColor];
    self.badge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
//    self.badge.autoresizesSubviews = YES;
    
    if (IS_IPHONE)
    {
        int width = 300;
        int height = 50;
        int offset_1 = 160;
        int offset = 60;
        
        self.badgeView = [[UIView alloc] initWithFrame:CGRectMake(160,60,width,height)];
        self.badgeView.backgroundColor = [UIColor redColor];
        
        self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset,0,width-180-(offset),height)];
        self.badgeLabel.font = [UIFont boldSystemFontOfSize:20];
        self.badgeLabel.textColor =  [UIColor whiteColor];
        self.badgeLabel.text = NSLocalizedString(@"Badge Title New",nil);
        self.badgeLabel.backgroundColor = [UIColor clearColor];
        self.badgeLabel.textAlignment = UITextAlignmentCenter;

        
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        if (IS_IPAD)
        {
            gradient.frame = CGRectMake(0,0,1024,1024);
        }
        else
        {
            gradient.frame = self.badgeView.bounds;
        }

        UIColor * color1 = [UIColor colorWithWhite: 0.0 alpha:0.0];
        UIColor * color2 = [UIColor colorWithWhite: 0.0 alpha:0.2];
        
        NSMutableArray * gradientColors = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i++)
        {
            [gradientColors addObject:(id)[color1 CGColor]];
            [gradientColors addObject:(id)[color2 CGColor]];
        }
        
        gradient.colors = gradientColors;
        gradient.startPoint = CGPointMake(0.0, 0.0); // default; bottom of the view
        gradient.endPoint = CGPointMake(1.0, 0.0);   // default; top of the view
        [self.badgeView.layer insertSublayer:gradient atIndex:0];
        
        
        [self.badgeView addSubview:self.badgeLabel];

        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, 45 * M_PI / 180);
        self.badgeView.transform = rotationTransform;
        
        self.badgeView.layer.shadowOffset = CGSizeMake(0,0);
        self.badgeView.layer.shadowOpacity = 0.5;
        self.badgeView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        self.badgeView.layer.shadowRadius = 2;
        
        [self.badge addSubview:self.badgeView];
    }
    else
    {
        int width = 400;
        int height = 50;
        int offset_1 = 160;
        int offset = 60;
        
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            self.badgeView = [[UIView alloc] initWithFrame:CGRectMake(500,90,width,height)];
            self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset,0,width-120-(offset),height)];
        }
        else
        {
//            self.badgeView = [[UIView alloc] initWithFrame:CGRectMake(780,70,width,height)];
//            self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset,0,width-120-(offset),height)];
//
            self.badgeView = [[UIView alloc] initWithFrame:CGRectMake(500,90,width,height)];
            self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset,0,width-120-(offset),height)];
        }
        self.badgeView.backgroundColor = [UIColor redColor];
        
        self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset,0,width-120-(offset),height)];
        self.badgeLabel.font = [UIFont boldSystemFontOfSize:20];
        self.badgeLabel.textColor =  [UIColor whiteColor];
        self.badgeLabel.text = NSLocalizedString(@"Badge Title New",nil);
        self.badgeLabel.backgroundColor = [UIColor clearColor];
        self.badgeLabel.textAlignment = UITextAlignmentCenter;
        
                
        CAGradientLayer *gradient = [CAGradientLayer layer];
        if (IS_IPAD)
        {
            gradient.frame = self.badgeView.bounds;
        }
        else
        {
            gradient.frame = self.badgeView.bounds;
        }
        
        UIColor * color1 = [UIColor colorWithWhite: 0.0 alpha:0.0];
        UIColor * color2 = [UIColor colorWithWhite: 0.0 alpha:0.2];
        
        NSMutableArray * gradientColors = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i++)
        {
            [gradientColors addObject:(id)[color1 CGColor]];
            [gradientColors addObject:(id)[color2 CGColor]];
        }
        
        gradient.colors = gradientColors;
        gradient.startPoint = CGPointMake(0.0, 0.0); // default; bottom of the view
        gradient.endPoint = CGPointMake(1.0, 0.0);   // default; top of the view
        [self.badgeView.layer insertSublayer:gradient atIndex:0];
        
        
        [self.badgeView addSubview:self.badgeLabel];
        
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, 45 * M_PI / 180);
        self.badgeView.transform = rotationTransform;
        
        self.badgeView.layer.shadowOffset = CGSizeMake(0,0);
        self.badgeView.layer.shadowOpacity = 0.5;
        self.badgeView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        self.badgeView.layer.shadowRadius = 2;
        self.badgeView.layer.masksToBounds = NO;

        [self.badge addSubview:self.badgeView];
    }
    
    [self addSubview:self.badge];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) layoutSubviews
{
    DLogFuncName();
    self.imageView.center = CGPointMake(ceil(self.bounds.size.width/2), ceil(self.bounds.size.height/2));
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.y = self.titleLabel.frame.origin.y - imageFrame.size.height - 20;
    self.imageView.frame = imageFrame;
    
    CGPoint center = self.subTitleLabel.center;
    center.x = self.imageView.center.x;
    self.subTitleLabel.center = center;
    
    center = self.titleLabel.center;
    center.x = self.imageView.center.x;
    self.titleLabel.center = center;
    
    self.imageFrame = self.imageView.frame;
}

@end
