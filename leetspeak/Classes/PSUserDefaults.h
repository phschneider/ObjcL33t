//
//  PSUserDefaults.h
//  leetspeak
//
//  Created by Philip Schneider on 15.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSUserDefaults : NSObject

+ (PSUserDefaults*) sharedPSUserDefaults;

- (void)incrementClearButtonTouches;
- (void)incrementImportButtonTouches;
- (void)incrementExportButtonTouches;
- (void)incrementSwitchButtonTouches;

@end
