//
//  PSWizzardModel.h
//  leetspeak
//
//  Created by Philip Schneider on 29.04.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSWizzardModel : NSObject

@property (nonatomic, strong) NSString * titleString;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * subTitleString;

- (id) initWithTitle:(NSString*)title subTitle:(NSString*)subtitle imageName:(NSString*)imageName;


@end
