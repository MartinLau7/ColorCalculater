//
//  MTUtils.h
//  ColorCalculater
//
//  Created by Martin on 15/8/5.
//  Copyright (c) 2015年 Tuxun Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MTUtils : NSObject

+ (NSColor *)colorWithHexString:(NSString *)string withAlpha:(CGFloat)alpha;

@end
