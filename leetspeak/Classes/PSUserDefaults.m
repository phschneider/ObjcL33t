//
//  PSUserDefaults.m
//  leetspeak
//
//  Created by Philip Schneider on 15.12.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSUserDefaults.h"

@implementation PSUserDefaults


static PSUserDefaults * instance = nil;

+ (PSUserDefaults*) sharedPSUserDefaults {
    DLogFuncName();
	@synchronized (self) {
		if (instance == nil){
			instance = [PSUserDefaults new];
		}
	}
	return instance;
}


- (id) init
{
    DLogFuncName();
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(defaultsChanged:)
                                                     name: NSUserDefaultsDidChangeNotification
                                                   object: nil];
    }
    return self;
}


- (void)defaultsChanged:(NSNotification*) note
{
    DLogFuncName();
}


- (void)incrementClearButtonTouches
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"CLEARBUTTONTOUCHED"];    
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"CLEARBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker trackEventWithCategory:@"uiAction"
                         withAction:@"buttonPress"
                          withLabel:@"clear"
                          withValue:[NSNumber numberWithInt:touches]];
}


- (void)incrementImportButtonTouches
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"IMPORTBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"IMPORTBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker trackEventWithCategory:@"uiAction"
                         withAction:@"buttonPress"
                          withLabel:@"import"
                          withValue:[NSNumber numberWithInt:touches]];
}



- (void)incrementExportButtonTouches
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"EXPORTBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"EXPORTBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker trackEventWithCategory:@"uiAction"
                         withAction:@"buttonPress"
                          withLabel:@"export"
                          withValue:[NSNumber numberWithInt:touches]];
}


- (void)incrementSwitchButtonTouches
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"SWITCHBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"SWITCHBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker trackEventWithCategory:@"uiAction"
                         withAction:@"buttonPress"
                          withLabel:@"switch"
                          withValue:[NSNumber numberWithInt:touches]];
}
@end
