//
//  PSScreenSaverManager.h
//  leetspeak
//
//  Created by Philip Schneider on 10.11.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSScreenSaverViewController;
@interface PSScreenSaverManager : NSObject

+ (PSScreenSaverManager*) sharedInstance;

- (BOOL) showsScreenSaver;

- (void)startScreenSaverTimer;
- (void)resetScreenSaverTimer;

- (void) hideScreenSaver;

@end
