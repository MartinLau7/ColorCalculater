//
//  AppDelegate.m
//  ColorCalculater
//
//  Created by Martin on 15/8/4.
//  Copyright (c) 2015年 Tuxun Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "MCRView.h"
#import "MainViewController.h"
#import "AboutWindowController.h"

#import <Quartz/Quartz.h>


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (strong) IBOutlet AboutWindowController *aboutWindow;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //设置主窗体Header
    // The class of the window has been set in INAppStoreWindow in Interface Builder
    self.mainWindow.trafficLightButtonsLeftMargin = 7.0;
    self.mainWindow.fullScreenButtonRightMargin = 7.0;
    self.mainWindow.titleBarHeight = 35.0f;
    
    [self.mainWindow setCenterFullScreenButton:NO];
    [self.mainWindow setCenterTrafficLightButtons:NO];
    [self.mainWindow setVerticalTrafficLightButtons:NO];
    [self.mainWindow setShowsBaselineSeparator:NO];
    [self.mainWindow setVerticallyCenterTitle:YES];
    
    //设定状态栏颜色
    self.mainWindow.titleBarDrawingBlock = ^(BOOL drawsAsMainWindow, CGRect drawingRect, CGRectEdge edge, CGPathRef clippingPath) {
        CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
        if (clippingPath) {
            CGContextAddPath(ctx, clippingPath);
            CGContextClip(ctx);
        }
        
        NSGradient *gradient = nil;
        if (drawsAsMainWindow) {
            gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithRed:33/255.0 green:196/255.0 blue:109/255.0 alpha:1] endingColor:[NSColor colorWithRed:33/255.0 green:196/255.0 blue:109/255.0 alpha:1]];
            [[NSColor darkGrayColor] setFill];
        } else {
            //set the default non-main window gradient colors
            //设置默认非主窗口渐变的颜色
            gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithRed:33/255.0 green:196/255.0 blue:109/255.0 alpha:1]													 endingColor:[NSColor colorWithRed:33/255.0 green:196/255.0 blue:109/255.0 alpha:1]];
            [[NSColor colorWithCalibratedWhite:0.6f alpha:1] setFill];
        }
        [gradient drawInRect:drawingRect angle:80];
        
        NSRectFill(NSMakeRect(NSMinX(drawingRect), NSMinY(drawingRect), 90, 0.24));
        
        static CIImage *noisePattern = nil;
        if(noisePattern == nil){
            CIFilter *randomGenerator = [CIFilter filterWithName:@"CIColorMonochrome"];
            [randomGenerator setValue:[[CIFilter filterWithName:@"CIRandomGenerator"] valueForKey:@"outputImage"]
                               forKey:@"inputImage"];
            [randomGenerator setDefaults];
            noisePattern = [randomGenerator valueForKey:@"outputImage"];
        }
        [noisePattern drawAtPoint:NSZeroPoint fromRect:drawingRect operation:NSCompositePlusLighter fraction:0.039999999105930328];
    };
    
    //设置主视窗视图
    NSRect frame = ((NSView *)self.mainWindow.contentView).bounds;
    
    MainViewController *viewController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [viewController.view setFrame:frame];
    [self.mainWindow.contentView addSubview:viewController.view];
    
    [self buildTitleBarSubView];
    
}

- (void) buildTitleBarSubView{
    
    NSView * leftView  = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, 90.0f, 35.0f)];
    [leftView.layer setCornerRadius:5.0f];
    leftView.layer.masksToBounds = YES;

    MCRView * rightView = [[MCRView alloc]initWithFrame:NSMakeRect(90, 0, 460, 35.0f)];
    
    [self.mainWindow.titleBarView addSubview:leftView];
    [self.mainWindow.titleBarView addSubview:rightView];
}

- (IBAction)showAbout:(id)sender{
    AboutWindowController *controller = [[AboutWindowController alloc]initWithWindowNibName:@"AboutWindowController" owner:self];
    _aboutWindow = controller;
    [controller showWindow:self];
}

//退出后结束进程
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return NO;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
