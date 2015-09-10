//
//  MainViewController.m
//  ColorCalculater
//
//  Created by Martin on 15/8/4.
//  Copyright (c) 2015年 Tuxun Inc. All rights reserved.
//

#import "MainViewController.h"

#import "EDSideBar.h"
#import "MTTextField.h"
#import "MTUtils.h"

#define MacCode @"[NSColor colorWithCalibratedRed:%1.6f green:%1.6f blue:%1.6f alpha:%1.1f]"
#define MacSiwftCode @"NSColor(calibratedRed: %1.6f, green: %1.6f, blue: %1.6f, alpha: %1.1f))"

#define iOSCode @"[UIColor colorWithRed:%1.6f green:%1.6f blue:%1.6f alpha:%1.1f]"
#define iOSSiwftCode @"UIColor(red:%1.6f, green:%1.6f, blue:%1.6f, alpha:%1.1f)"



typedef enum MTCodeType{
    MTCodeType_Swift,
    MTCodeType_Obj_c
}MTCodeType;

typedef enum MTConvertType{
    MTConvertType_HexColor,
    MTConvertType_RGBColor,
    MTConvertType_ColorWell
}MTConvertType;


@interface MainViewController () <EDSideBarDelegate, MTTextFieldDelegate>

@property (nonatomic, strong) IBOutlet EDSideBar *LeftSideBarMenu;

//Control
@property (strong) IBOutlet MTTextField *hexColorTextField;
@property (strong) IBOutlet MTTextField *rgbColorTextField;
@property (weak) IBOutlet NSColorWell *colorSelecterWell;
@property (weak) IBOutlet NSTextField *codeTextField;
@property (weak) IBOutlet NSTextField *swiftCodeTextField;
@property (weak) IBOutlet NSView *colorView;

@property (weak) IBOutlet NSButton *canClearCheckBox;
@property (weak) IBOutlet NSButton *writeClipboardCheckBox;

@property (weak) IBOutlet NSMatrix *codeSeleter;
@end

@implementation MainViewController

- (NSImage*)buildSelectionImage
{
    // Create the selection image on the fly, instead of loading from a file resource.
    NSInteger imageWidth=12, imageHeight=22;
    NSImage* destImage = [[NSImage alloc] initWithSize:NSMakeSize(imageWidth,imageHeight)];
    [destImage lockFocus];
    
    // Constructing the path
    NSBezierPath *triangle = [NSBezierPath bezierPath];
    [triangle setLineWidth:1.0];
    [triangle moveToPoint:NSMakePoint(imageWidth+1, 0.0)];
    [triangle lineToPoint:NSMakePoint( 0, imageHeight/2.0)];
    [triangle lineToPoint:NSMakePoint( imageWidth+1, imageHeight)];
    [triangle closePath];
    
    [[NSColor whiteColor] setFill];
    [[NSColor whiteColor] setStroke];
    [triangle fill];
    [triangle stroke];
    [destImage unlockFocus];
    return destImage;
}

//初始化左侧菜单
-(void)awakeFromNib{
    
    [self.LeftSideBarMenu setBackgroundColor:[NSColor colorWithRed:33/255.0 green:196/255.0 blue:109/255.0 alpha:1]];
    //build Left Menu
    [self.LeftSideBarMenu setLayoutMode:ECSideBarLayoutTop];
    [self.LeftSideBarMenu setAnimateSelection:YES];
    [self.LeftSideBarMenu setSidebarDelegate:self];
    [self.LeftSideBarMenu setSelectionImage:[self buildSelectionImage]];
    
    [self.LeftSideBarMenu addButtonWithTitle:@"Mac" image:[NSImage imageNamed:@"Mac"]];
    [self.LeftSideBarMenu addButtonWithTitle:@"iOS" image:[NSImage imageNamed:@"iOS"]];
    [self.LeftSideBarMenu setNoiseAlpha:.04f];
    
    [self.LeftSideBarMenu selectButtonAtRow:0];
}

- (void)loadView {
    [super loadView];
    // Do view setup here.
    
    [self.colorView setWantsLayer:YES];
    [self.colorView.layer setBorderWidth:.1];
    [self.colorView.layer setBackgroundColor:_colorSelecterWell.color.CGColor];
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[NSColor whiteColor].CGColor];
    
    [_hexColorTextField setTDelegate:self];
    [_rgbColorTextField setTDelegate:self];
}

#pragma mark - 
#pragma mark - 私有函式
//撷取程式码类型
- (MTCodeType)getCodeType{
    if(_codeSeleter.selectedRow==0){
        return MTCodeType_Obj_c;
    }else{
        return MTCodeType_Swift;
    }
}

//转换 Code 后是否需要写入粘贴板
- (BOOL)needWriteClipboard{
    return _writeClipboardCheckBox.state == NSOnState;
}

/**
 Color Convert To String
 */
- (NSString *)colorToCode:(MTCodeType)codeType
            withRed:(CGFloat)red
          withGreen:(CGFloat)green
           withBlue:(CGFloat)blue
          withAlpha:(CGFloat)alpha{
    
    [self.colorView.layer setBackgroundColor:[NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha].CGColor];
    if(self.LeftSideBarMenu.selectedIndex == 0){
        
        if(codeType == MTCodeType_Obj_c){
            return [NSString stringWithFormat:MacCode, red, green, blue, alpha];
        }else{
            return [NSString stringWithFormat:MacSiwftCode, red, green, blue, alpha];
        }
        return [NSString stringWithFormat:MacCode, red, green, blue, alpha];
    }else{
        if(codeType == MTCodeType_Obj_c){
            return [NSString stringWithFormat:iOSCode, red, green, blue, alpha];
        }else{
            return [NSString stringWithFormat:iOSSiwftCode, red, green, blue, alpha];
        }
        return [NSString stringWithFormat:iOSCode, red, green, blue, alpha];
    }
}

/**
 Convert
 */
- (void)convertToCode:(MTConvertType)convertType{
    
    NSString *objCCode = @"";
    NSString *swiftCode = @"";
    
    
    switch (convertType) {
        case MTConvertType_HexColor:
        {
            @try {
                objCCode = [self hexColorToCode:self.hexColorTextField.stringValue toCode:MTCodeType_Obj_c];
                swiftCode = [self hexColorToCode:self.hexColorTextField.stringValue toCode:MTCodeType_Swift];
            }
            @catch (NSException *exception) {
                objCCode = @"色值错误";
                swiftCode = @"色值错误";
                [self.colorView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
            }
        }
            break;
        case MTConvertType_RGBColor:
        {
            @try {
                objCCode = [self rgbColorToCode:self.rgbColorTextField.stringValue toCode:MTCodeType_Obj_c];
                swiftCode = [self rgbColorToCode:self.rgbColorTextField.stringValue toCode:MTCodeType_Swift];
            }
            @catch (NSException *exception) {
                objCCode = @"色值错误";
                swiftCode = @"色值错误";
                [self.colorView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
            }
        }
            break;
        case MTConvertType_ColorWell:
        {
            @try {
                objCCode = [self colorWellToCode:[self.colorSelecterWell color] toCode:MTCodeType_Obj_c];
                swiftCode = [self colorWellToCode:[self.colorSelecterWell color] toCode:MTCodeType_Swift];
            }
            @catch (NSException *exception) {
                objCCode = @"色值错误";
                swiftCode = @"色值错误";
                [self.colorView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
            }
        }
            break;
    }
    
    if(self.needWriteClipboard){
        [self setPasteBoardString:[self getCodeType] == MTCodeType_Obj_c?objCCode:swiftCode];
    }
    
    [self.codeTextField setStringValue:objCCode];
    [self.swiftCodeTextField setStringValue:swiftCode];
    if([self.canClearCheckBox state]){
        [self.hexColorTextField setStringValue:@""];
        [self.rgbColorTextField setStringValue:@""];
        [self.colorSelecterWell setColor:[NSColor colorWithRed:33/255.0 green:196/255.0 blue:109/255.0 alpha:1]];
    }
}

- (NSString *)hexColorToCode:(NSString *)hexColor toCode:(MTCodeType)codeType{
    
    NSArray *array = [hexColor componentsSeparatedByString:@","];
    
    NSString *string = [array[0] stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    CGFloat alpha = 1.0f;
    if(array.count == 2)
        alpha = [array[1] doubleValue];
    
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureHexString length] != 6) {
        [self.colorView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
        return @"色值错误";
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *gString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *bString = [pureHexString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [self colorToCode:codeType withRed:((float) r / 255.0f) withGreen:((float) g / 255.0f) withBlue:((float) b / 255.0f) withAlpha:alpha];
}

- (NSString *)rgbColorToCode:(NSString *)rgbColor toCode:(MTCodeType)codeType{
    
    NSArray *array = [rgbColor componentsSeparatedByString:@","];
    
    CGFloat r = [array[0] doubleValue];
    CGFloat g = [array[1] doubleValue];
    CGFloat b = [array[2] doubleValue];
    CGFloat a = 1.0f;
    if(array.count==4)
        a = [array[3] doubleValue];
    
    return [self colorToCode:codeType withRed:((float) r / 255.0f) withGreen:((float) g / 255.0f) withBlue:((float) b / 255.0f) withAlpha:a];
}

- (NSString *)colorWellToCode:(NSColor *)color toCode:(MTCodeType)codeType{
    
    CGFloat r = [color redComponent];
    CGFloat g = [color greenComponent];
    CGFloat b = [color blueComponent];
    CGFloat a = [color alphaComponent];
    
    return [self colorToCode:codeType withRed:r withGreen:g withBlue:b withAlpha:a];
}

- (BOOL)setPasteBoardString:(NSString *)pasteBoardString{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    return [pasteboard setString:pasteBoardString forType:NSStringPboardType];
}

- (void)mouseDown:(NSEvent *)theEvent withSelf:(id)sender{
    if(sender == _hexColorTextField){
        [self convertToCode:MTConvertType_HexColor];
    }else{
        [self convertToCode:MTConvertType_RGBColor];
    }
}

#pragma mark - Button Action
- (IBAction)colorSelectedAction:(id)sender {
    [self convertToCode:MTConvertType_ColorWell] ;
}

- (IBAction)clearReslutAction:(id)sender {
    [self.codeTextField setStringValue:@""];
    [self.swiftCodeTextField setStringValue:@""];
    [self.colorView.layer setBackgroundColor:_colorSelecterWell.color.CGColor];
}

- (IBAction)checkSetPasteboard:(NSButton *)sender {
    
    [self.codeSeleter setEnabled:sender.state == NSOnState];
}


#pragma mark - LeftSideBarMenu Delegate

@end
