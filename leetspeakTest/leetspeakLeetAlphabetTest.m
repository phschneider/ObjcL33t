//
//  leetspeak - leetspeakLeetAlphabetTest.m
//  Copyright 2013 Philip Schneider (phschneider.net). All rights reserved.
//
//  Created by: Philip Schneider
//

    // Class under test
#import "PSLeetAlphabet.h"
#import "PSUserDefaults.h"
    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

// Uncomment the next two lines to use OCMockito for mock objects:
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>


@interface leetspeakLeetAlphabetTest : SenTestCase


@end




@implementation leetspeakLeetAlphabetTest
{
    // test fixture ivars go here
    PSLeetAlphabet *  sut;
}


- (void) setUp
{
//    sut = mock([PSLeetAlphabet class]);
    sut = [[PSLeetAlphabet alloc] init];
}


- (void) tearDown
{
    sut = nil;
}


- (void)testLevelOneCharToLeet
{
    [sut convertCharToLeet:@"H" level:0];
    [verify(sut) convertCharToLeet:@"H" level:0];
}


- (void)testLevelOneTextToLeet
{
    // Can we convert
    [sut convertTextToLeet:@"Hi" level:0];
    [verify(sut) convertTextToLeet:@"Hi" level:0];
}


- (void)testLevelOneLeetToText
{
    [sut convertLeetToText:@"H!" level:0];
    [verify(sut) convertLeetToText:@"H!" level:0];
}


- (void)testLevelOneLeetToTextConvertHi
{
    assertThat([sut convertLeetToText:@"H!" level:0], equalTo(@"hi"));
}


@end
