//
//  AboutWindowController.m
//  ColorCalculater
//
//  Created by Martin on 2015/8/27.
//  Copyright (c) 2015年 Tuxun Inc. All rights reserved.
//

#import "AboutWindowController.h"

@interface WTAboutView : NSView

@end

@implementation WTAboutView


- (void)drawRect:(NSRect)dirtyRect{
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.156863 green:0.756863 blue:0.364706 alpha:1.0]
                                                         endingColor:[NSColor colorWithCalibratedRed:0.0118 green:0.6196 blue:0.6392 alpha:1]];
    [gradient drawInRect:dirtyRect angle:270.0];
}
@end

@interface AboutWindowController ()

@end

@implementation AboutWindowController

- (void)loadWindow {
    [super loadWindow];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self.window setBackgroundColor:[NSColor colorWithCalibratedRed:0.156863 green:0.756863 blue:0.364706 alpha:1.0]];
}

@end
