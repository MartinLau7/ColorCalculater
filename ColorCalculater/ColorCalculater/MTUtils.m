//
//  MTUtils.m
//  ColorCalculater
//
//  Created by Martin on 15/8/5.
//  Copyright (c) 2015年 Tuxun Inc. All rights reserved.
//

#import "MTUtils.h"

@implementation MTUtils

+ (NSColor *)colorWithHexString:(NSString *)string withAlpha:(CGFloat)alpha
{
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureHexString length] != 6) {
        return [NSColor whiteColor];
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
    
    return [NSColor colorWithDeviceRed:((float) r / 255.0f)
                                 green:((float) g / 255.0f)
                                  blue:((float) b / 255.0f)
                                 alpha:alpha];
}

@end
