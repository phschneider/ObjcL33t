//
// Created by pschneider on 10.11.13.
//
// Copyright (c) 2013 Haus & Gross communications. All rights reserved.
//


#import <Foundation/Foundation.h>


@class PSWizzardViewController;
@interface PSWizzardManager : NSObject

+ (PSWizzardManager*) sharedInstance;

- (BOOL) showsWizzard;

- (void) showWizzard;
- (void) hideWizzard;

@end