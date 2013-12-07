//
//  PSLeetAlphabet.h
//  leetspeak
//
//  Created by Philip Schneider on 25.02.13.
//  Copyright (c) 2013 Philip Schneider (phschneider.net). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSLeetAlphabet : NSObject

@property (nonatomic, strong) NSArray * alphabet;
@property (nonatomic, strong) NSDictionary * leetbet;

- (NSString*)convertCharToLeet:(NSString*)character;
- (NSString*)convertCharToLeet:(NSString*)character level:(int)level;


- (NSString*)convertTextToLeet:(NSString*)text;
- (NSString*)convertTextToLeet:(NSString*)text level:(int)level;



- (NSString*)convertLeetToText:(NSString*)text;
- (NSString*)convertLeetToText:(NSString*)text level:(int)level;


@end
