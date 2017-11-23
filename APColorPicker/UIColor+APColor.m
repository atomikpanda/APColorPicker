//
//  NUColor.m
//  Nucleus
//
//  Created by Bailey Seymour on 3/18/14.
//  Copyright (c) 2014 Bailey Seymour. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIColor+APColor.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIColor (APColor)

+ (UIColor *)AP_colorWithHex:(NSString *)hexString {
    if (hexString.length > 0) {
        if ([hexString hasPrefix:@"#"])
            hexString = [hexString substringFromIndex:1];
        
         if (hexString) {
         NSScanner *scanner = [NSScanner scannerWithString:hexString];
         if ([hexString hasPrefix:@"#"])
         [scanner setScanLocation:1]; // bypass '#' character
          unsigned rgbValue = 0;
         [scanner scanHexInt:&rgbValue];
         return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
        
//        return [UIColor colorWithRed:int(rgbColor[0])/255.f green:int(rgbColor[1])/255.f blue:int(rgbColor[2])/255.f alpha:1];
    }
    }
    else {
        //Random
//        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    }
    return nil;
}

+ (NSString *)AP_hexFromColor:(UIColor *)color {
    if (!color) return nil;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"#%02X%02X%02X", (int)(r * 255),  (int)(g * 255), (int)(b * 255)]; return hexString;
}

#pragma mark Components
- (CGFloat)APAlpha {
    CGFloat a;
    [self getWhite:NULL alpha:&a];
    return a;
}

- (CGFloat)APRed {
    CGFloat r;
    [self getRed:&r green:NULL blue:NULL alpha:NULL];
    return r;
}

- (CGFloat)APGreen {
    CGFloat g;
    [self getRed:NULL green:&g blue:NULL alpha:NULL];
    return g;
}


- (CGFloat)APBlue {
    CGFloat b;
    [self getRed:NULL green:NULL blue:&b alpha:NULL];
    return b;
}

- (CGFloat)APHue {
    CGFloat h;
    [self getHue:&h saturation:NULL brightness:NULL alpha:NULL];
    return h;
}

- (CGFloat)APSaturation {
    CGFloat s;
    [self getHue:NULL saturation:&s brightness:NULL alpha:NULL];
    return s;
}

- (CGFloat)APBrightness {
    CGFloat b;
    [self getHue:NULL saturation:NULL brightness:&b alpha:NULL];
    return b;
}

#pragma mark Manipulation
- (UIColor *)AP_desaturate:(CGFloat)percent {
        return [UIColor colorWithHue:[self APHue] saturation:[self APSaturation]*(1-(percent/100)) brightness:[self APBrightness] alpha:[self APAlpha]];
}

- (UIColor *)AP_lighten:(CGFloat)percent {
   return [UIColor colorWithHue:[self APHue] saturation:[self APSaturation]*(1-(percent/100)) brightness:[self APBrightness]*(1+(percent/100)) alpha:[self APAlpha]];
}

- (UIColor *)AP_darken:(CGFloat)percent {
    return [UIColor colorWithHue:[self APHue] saturation:[self APSaturation]*(1+(percent/100)) brightness:[self APBrightness]*(1-(percent/100)) alpha:[self APAlpha]];
}


@end

