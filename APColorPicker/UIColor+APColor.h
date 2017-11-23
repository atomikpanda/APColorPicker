//
//  NUColor.h
//  Nucleus
//
//  Created by Bailey Seymour on 3/18/14.
//  Copyright (c) 2014 Bailey Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (APColor)
+ (UIColor *)AP_colorWithHex:(NSString *)hexString;
+ (NSString *)AP_hexFromColor:(UIColor *)color;
@property (nonatomic, assign, readonly) CGFloat APAlpha;
@property (nonatomic, assign, readonly) CGFloat APRed;
@property (nonatomic, assign, readonly) CGFloat APGreen;
@property (nonatomic, assign, readonly) CGFloat APBlue;
@property (nonatomic, assign, readonly) CGFloat APHue;
@property (nonatomic, assign, readonly) CGFloat APSaturation;
@property (nonatomic, assign, readonly) CGFloat APBrightness;
- (UIColor *)AP_desaturate:(CGFloat)percent;
- (UIColor *)AP_lighten:(CGFloat)percent;
- (UIColor *)AP_darken:(CGFloat)percent;
@end

