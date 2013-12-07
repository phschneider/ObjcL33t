//
//  PSLeetAlphabet.m
//  leetspeak
//
//  Created by Philip Schneider on 25.02.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import "defaults.h"
#import "leet.h"

#import "PSUserDefaults.h"
#import "PSLeetAlphabet.h"

@implementation PSLeetAlphabet

- (id)init
{
    DLogFuncName();
    self = [super init];
    if (self)
    {
        _alphabet =         [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z",nil];

        _leetbet = [NSDictionary dictionaryWithObjects:
                        [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects: @"4", @"b", @"c", @"d", @"3", @"f", @"g", @"h", @"i", @"j", @"k", @"1",@"m", @"n", @"0", @"p", @"9", @"r", @"s", @"7", @"u", @"v", @"w", @"x",@"y", @"z",nil],
                            [NSArray arrayWithObjects: @"4", @"b", @"c", @"d", @"3", @"f", @"g", @"h", @"1", @"j", @"k", @"1",@"m", @"n", @"0", @"p", @"9", @"r", @"5", @"7", @"u", @"v", @"w", @"x",@"y", @"2",nil],
                            [NSArray arrayWithObjects: @"4", @"8", @"c", @"d", @"3", @"f", @"6", @"h", @"'", @"j", @"k", @"1",@"m", @"n", @"0", @"p", @"9", @"r", @"5", @"7", @"u", @"v", @"w", @"x",@"'/", @"2",nil],
                            [NSArray arrayWithObjects: @"@", @"8", @"c", @"d", @"3", @"f", @"6", @"h", @"'", @"j", @"k", @"1",@"m", @"n", @"0", @"p", @"9", @"r", @"5", @"7", @"u", @"v", @"w", @"x",@"'/", @"2",nil],
                            [NSArray arrayWithObjects: @"@", @"|3", @"c", @"d", @"3", @"f", @"6", @"#", @"!", @"7", @"|<", @"1",@"m", @"n", @"0", @"|>", @"9", @"|2", @"$", @"7", @"u", @"\\/", @"w",@"x", @"'/", @"2",nil],
                            [NSArray arrayWithObjects: @"@", @"|3", @"c", @"|)", @"&", @"|=", @"6", @"#", @"!", @",|", @"|<",@"1", @"m", @"n", @"0", @"|>", @"9", @"|2", @"$", @"7", @"u", @"\\/",@"w", @"x", @"'/", @"2",nil],
                            [NSArray arrayWithObjects: @"@", @"|3", @"[", @"|)", @"&", @"|=", @"6", @"#", @"!", @",|", @"|<",@"1", @"^^", @"^/", @"0", @"|*", @"9", @"|2", @"5", @"7", @"(_)", @"\\/",@"\\/\\/", @"><", @"'/", @"2",nil],
                            [NSArray arrayWithObjects: @"@", @"8", @"(", @"|)", @"&", @"|=", @"6", @"|-|", @"!", @"_|", @"|(",@"1", @"|\\/|", @"|\\|", @"()", @"|>", @"(,)", @"|2", @"$", @"|", @"|_|",@"\\/", @"\\^/", @")(", @"'/", @"\"/_",nil],
                            [NSArray arrayWithObjects: @"@", @"8", @"(", @"|)", @"&", @"|=", @"6", @"|-|", @"!", @"_|", @"|{",@"|_", @"/\\/\\", @"|\\|", @"()", @"|>", @"(,)", @"|2", @"$", @"|",@"|_|", @"\\/", @"\\^/", @")(", @"'/", @"\"/_",nil],
                         nil
                        ]
                        forKeys:[NSArray arrayWithObjects:@"0",@"1", @"2", @"3", @"4", @"5", @"6", @"7",@"8",nil]];
    }
    return self;
}

#pragma mark - Characters
// Einzelner Buchstabe
- (NSString*)convertCharToLeet:(NSString*)character
{
    DLogFuncName();
    return [self convertCharToLeet:character level:[[PSUserDefaults sharedPSUserDefaults] level]];
}


#warning todo
- (NSString*)convertCharToLeet:(NSString*)character level:(int)level
{
    DLogFuncName();
    return leetConvert(level, character);
}


#pragma mark - Text
- (NSString*)convertTextToLeet:(NSString*)text
{
    DLogFuncName();
    
    return [self convertTextToLeet:text level:[[PSUserDefaults sharedPSUserDefaults] level]];
}


// Ganze Zeichenkette
- (NSString*)convertTextToLeet:(NSString*)text level:(int)level
{
    DLogFuncName();
    
    return leetConvert(level, text);
}


- (NSString*)convertLeetToText:(NSString*)text
{
    DLogFuncName();
    return [self convertLeetToText:text level:[[PSUserDefaults sharedPSUserDefaults]level]];
}


- (NSString*)convertLeetToText:(NSString*)text level:(int)level
{
    return @"hi";
}


@end
