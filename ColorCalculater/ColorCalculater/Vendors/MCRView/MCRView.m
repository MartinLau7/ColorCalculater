//
//  RMSkinnedView.m
//  tutuJailBreakHelper
//
//  Created by Martin on 15/4/29.
//  Copyright (c) 2015年 Tuxun Inc. All rights reserved.
//

#import "MCRView.h"

@implementation MCRView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.backgroundColor = [NSColor colorWithDeviceWhite:60.0/255.0 alpha:1.0].CGColor;
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect{
    [self setFocusRingType:NSFocusRingTypeNone];
    
    // Set the corner curve radius
    [NSGraphicsContext saveGraphicsState];
    CGFloat cornerRadius = 10;
    
    // Draw bottom right round corner
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds))];
    
    // Draw bottom border and a bottom-right rounded corner
    NSPoint bottomRightCorner = NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds));
    [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds)-cornerRadius)];
    [path curveToPoint:NSMakePoint(NSMaxX(self.bounds)-cornerRadius, NSMaxY(self.bounds)) controlPoint1:bottomRightCorner controlPoint2:bottomRightCorner];
    
    // Draw right border, top border and left border
    [path lineToPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds))];
    [path lineToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds))];
    [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds))];
    
//    [[NSColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1] set];
    [[NSColor whiteColor]set];
    [path fill];
    [NSGraphicsContext restoreGraphicsState];
}

@end