//
//  MTTextField.m
//  ColorCalculater
//
//  Created by Martin on 15/8/5.
//  Copyright (c) 2015年 Tuxun Inc. All rights reserved.
//

#import "MTTextField.h"

@implementation MTTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void) updateTrackingAreas
{
    [super updateTrackingAreas];
    
    NSRect frame =  self.frame;
    [self setFrame:frame];
    
    
    if ([self mouseInView]) {
        [self mouseEntered:nil];
    }else {
        [self mouseExited:nil];
    }
    
    if(trackingArea)
    {
        [self removeTrackingArea:trackingArea];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingActiveAlways | NSTrackingAssumeInside;
    
    trackingArea = [[NSTrackingArea alloc]initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

//判断鼠标是否在当前视图内
- (BOOL)mouseInView
{
    if (!self.window) {
        return NO;
    }
    if (self.isHidden) {
        return NO;
    }
    
    NSPoint point = [NSEvent mouseLocation];
    point = [self.window convertRectFromScreen:NSMakeRect(point.x, point.y, 0, 0)].origin;
    point = [self convertPoint:point fromView:nil];
    return NSPointInRect(point, self.visibleRect);
}

- (void)mouseEntered:(NSEvent *)theEvent{
    
}

- (void)mouseExited:(NSEvent *)theEvent{
    
}

- (void)keyUp:(NSEvent *)theEvent{
//
    if(theEvent.keyCode == 36 || theEvent.keyCode == 76)
    {
        [[self currentEditor] setSelectedRange:NSMakeRange([[self stringValue] length], [[self stringValue] length])];
        
        if(_tDelegate && [_tDelegate respondsToSelector:@selector(mouseDown:withSelf:)]){
            [_tDelegate mouseDown:theEvent withSelf:self];
        }
    }else{
        [super keyDown:theEvent];
    }
}

@end
