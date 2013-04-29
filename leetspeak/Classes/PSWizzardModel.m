//
//  PSWizzardModel.m
//  leetspeak
//
//  Created by Philip Schneider on 29.04.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSWizzardModel.h"

@implementation PSWizzardModel

- (id) initWithTitle:(NSString*)title subTitle:(NSString*)subtitle imageName:(NSString*)imageName
{
    DLogFuncName();
    self = [super init];
    if (self)
    {
        _titleString = title;
        _subTitleString = subtitle;
        _imageName = imageName;
    }
    return self;
}


@end
