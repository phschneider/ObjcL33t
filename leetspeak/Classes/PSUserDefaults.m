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


- (BOOL) isFirstStart
{
    DLogFuncName();
    NSString *currentVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSArray *prevStartupVersions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"prevStartupVersions"];
    if (prevStartupVersions == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:currentVersion] forKey:@"prevStartupVersions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return (prevStartupVersions == nil);
}


- (BOOL) isFirstVersionStart
{
    DLogFuncName();
    
    BOOL isFirstVersionStart = NO;
    // Get current version ("Bundle Version") from the default Info.plist file
    NSString *currentVersion = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSArray *prevStartupVersions = [[NSUserDefaults standardUserDefaults] arrayForKey:@"prevStartupVersions"];
    if (prevStartupVersions == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:currentVersion] forKey:@"prevStartupVersions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isFirstVersionStart = YES;
    }
    else
    {
        if (![prevStartupVersions containsObject:currentVersion])
        {
            NSMutableArray *updatedPrevStartVersions = [NSMutableArray arrayWithArray:prevStartupVersions];
            [updatedPrevStartVersions addObject:currentVersion];
            [[NSUserDefaults standardUserDefaults] setObject:updatedPrevStartVersions forKey:@"prevStartupVersions"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            isFirstVersionStart = YES;
        }
    }

    // Save changes to disk
    return isFirstVersionStart;
}

#pragma mark - Logging / Analytics

- (void)incrementClearButtonTouches
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"CLEARBUTTONTOUCHED"];    
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"CLEARBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
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
    [tracker sendEventWithCategory:@"uiAction"
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
    [tracker sendEventWithCategory:@"uiAction"
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
    [tracker sendEventWithCategory:@"uiAction"
                         withAction:@"buttonPress"
                          withLabel:@"switch"
                          withValue:[NSNumber numberWithInt:touches]];
}


- (void)incrementChatButtonTouches
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"CHATBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"CHATBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"chat"
                         withValue:[NSNumber numberWithInt:touches]];
}


- (void)incrementMailButtonTouches
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"MAILBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"MAILBUTTONTOUCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"mail"
                         withValue:[NSNumber numberWithInt:touches]];
}


#pragma mark - AppDelegate
- (void)wizzaredStarted
{
    [[NSUserDefaults standardUserDefaults] setDouble:NSTimeIntervalSince1970 forKey:@"WIZZARDSTARTTIME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#warning todo
- (void)wizzardFinished
{

    [[NSUserDefaults standardUserDefaults] setDouble:NSTimeIntervalSince1970 forKey:@"WIZZARDENDTIME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSTimeInterval end = [[NSUserDefaults standardUserDefaults] doubleForKey:@"WIZZARDENDTIME"];
    NSTimeInterval start = [[NSUserDefaults standardUserDefaults] doubleForKey:@"WIZZARDSTARTTIME"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendTimingWithCategory:@"uiAction"
                          withValue:end-start
                           withName:@"wizzardBrowsingTime"
                          withLabel:@"wizzard"];
}

#warning todo
- (void)incrementAppDidReceiveLocalNotification;
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"APPDIDRECEIVELOCALNOTIFICATION"];
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"APPDIDRECEIVELOCALNOTIFICATION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                         withAction:@"buttonPress"
                          withLabel:@"switch"
                          withValue:[NSNumber numberWithInt:touches]];
}

#warning todo
- (void)incrementAppDidFinishLaunchingCount
{
    DLogFuncName();
    int touches = [[NSUserDefaults standardUserDefaults] integerForKey:@"APPDIDFINISHLAUNCHING"];
    [[NSUserDefaults standardUserDefaults] setInteger:++touches forKey:@"APPDIDFINISHLAUNCHING"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                         withAction:@"buttonPress"
                          withLabel:@"switch"
                          withValue:[NSNumber numberWithInt:touches]];
}


#pragma mark - Level
- (void) setLevel:(int)level
{
    DLogFuncName();
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:USERDEFAULTS_LEET_STRENGTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USERDEFAULTS_LEET_STRENGTH_CHANGES object:nil];
}


- (int) level
{
    DLogFuncName();
    return [[NSUserDefaults standardUserDefaults] integerForKey:USERDEFAULTS_LEET_STRENGTH];
}
@end
