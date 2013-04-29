//
//  PSWizzardViewController.h
//  leetspeak
//
//  Created by Philip Schneider on 20.01.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSWizzardModel;
@class StyledPageControl;
@interface PSWizzardViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray * wizzardArray;
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) StyledPageControl * pageControl;
@property (nonatomic, strong) UIButton * nextButton;
@property (nonatomic, strong) UIToolbar * toolbar;


@property (nonatomic) BOOL canVibrate;
@end
