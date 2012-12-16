//
//  PSAlphaBetCell.m
//  leetspeak
//
//  Created by Philip Schneider on 03.11.12.
//  Copyright (c) 2012 Philip Schneider (phschneider.net). All rights reserved.
//

#import "PSAlphaBetCell.h"

@implementation PSAlphaBetCell

#pragma mark - Column Support
//- (void)addColumn:(CGFloat)position {
//    [columns addObject:[NSNumber numberWithFloat:position]];
//}
//
//
//- (void)drawRect:(CGRect)rect {
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // Use the same color and width as the default cell separator for now
//    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0);
//    CGContextSetLineWidth(ctx, 0.25);
//    
//    for (int i = 0; i < [columns count]; i++) {
//        CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
//        CGContextMoveToPoint(ctx, f, 0);
//        CGContextAddLineToPoint(ctx, f, self.bounds.size.height);
//    }
//    
//    CGContextStrokePath(ctx);
//    
//    [super drawRect:rect];
//}

@end
