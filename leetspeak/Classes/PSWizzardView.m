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
        int padding = 20;
        self.backgroundColor = [UIColor clearColor];
        
        // Initialization code
        CGRect labelRect = CGRectMake(padding,ceil(frame.size.height /2)+80,frame.size.width-(2*padding), 40);
        self.titleLabel = [[UILabel alloc] initWithFrame:labelRect];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:32];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];

        labelRect = CGRectMake(padding,ceil(frame.size.height /2)+120,frame.size.width-(2*padding), 100);
        self.subTitleLabel = [[UILabel alloc] initWithFrame:labelRect];
        self.subTitleLabel.font = [UIFont systemFontOfSize:16];
        self.subTitleLabel.textAlignment = UITextAlignmentCenter;
        self.subTitleLabel.numberOfLines = 3;
        self.subTitleLabel.textColor = [UIColor whiteColor];
        self.subTitleLabel.backgroundColor = [UIColor clearColor];
        self.subTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:self.subTitleLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
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
        }
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

@end
