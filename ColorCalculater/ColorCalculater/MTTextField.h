//
//  MTTextField.h
//  ColorCalculater
//
//  Created by Martin on 15/8/5.
//  Copyright (c) 2015年 Tuxun Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MTTextFieldDelegate;

@interface MTTextField : NSTextField
{
    NSTrackingArea *trackingArea;
}

@property (nonatomic, weak) id<MTTextFieldDelegate> tDelegate;
@end

@protocol MTTextFieldDelegate <NSObject>

- (void)mouseDown:(NSEvent *)theEvent withSelf:(id)sender;

@end