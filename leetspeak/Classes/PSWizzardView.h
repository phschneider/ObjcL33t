//
//  PSWizzardView.h
//  leetspeak
//
//  Created by Philip Schneider on 29.04.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSWizzardModel;
@interface PSWizzardView : UIView

@property (nonatomic, strong) PSWizzardModel * model;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subTitleLabel;
@property (nonatomic, strong) UIImageView * imageView;

- (id) initWithFrame:(CGRect)frame model:(PSWizzardModel*)model;

@end
