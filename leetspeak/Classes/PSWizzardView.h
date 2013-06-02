//
//  PSWizzardView.h
//  leetspeak
//
//  Created by Philip Schneider on 29.04.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class PSWizzardModel;
@interface PSWizzardView : UIView

@property (nonatomic, strong) PSWizzardModel * model;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subTitleLabel;
@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic) CGRect imageFrame;

@property (nonatomic, strong) UIView * badge;
@property (nonatomic, strong) UIView * badgeView;
@property (nonatomic, strong) UILabel * badgeLabel;

- (id) initWithFrame:(CGRect)frame model:(PSWizzardModel*)model;

- (void) showBadge;

@end
