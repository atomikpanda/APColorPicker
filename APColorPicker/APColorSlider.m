//
//  APColorSlider.m
//  APColorPicker
//
//  Created by Bailey Seymour on 10/21/17.
//  Copyright © 2017 Bailey Seymour. All rights reserved.
//

#import "APColorSlider.h"
#import <APColorPicker/UIColor+APColor.h>

@interface PFColorSliderBackgroundView : UIView
@property (nonatomic, retain) UIColor *color;
@property (assign) APSliderBackgroundStyle style;
- (id)initWithFrame:(CGRect)frame color:(UIColor *)color style:(APSliderBackgroundStyle)s;
@end

@implementation PFColorSliderBackgroundView
@synthesize color;

- (id)initWithFrame:(CGRect)frame color:(UIColor *)col style:(APSliderBackgroundStyle)s
{
    self = [super initWithFrame:frame];
    self.color = col;
    self.style = s;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    for (int x = 0; x < rect.size.width; x++) {
        float percent = 100 - (((rect.size.width - x) / rect.size.width) * 100.f);
        
        if (self.style == APSliderBackgroundStyleSaturation)
            [[UIColor colorWithHue:[self.color APHue] saturation:(percent / 100) brightness:1 alpha:1] setFill];
        else if (self.style == APSliderBackgroundStyleBrightness)
            [[UIColor colorWithHue:[self.color APHue] saturation:1 brightness:(percent / 100) alpha:1] setFill];
        else if (self.style == APSliderBackgroundStyleAlpha)
            [[UIColor colorWithHue:self.color.APHue saturation:self.color.APSaturation brightness:self.color.APBrightness alpha:(percent / 100)] setFill];
        
        CGContextFillRect(context, CGRectMake(x, 0, 1, rect.size.height));
    }
    
    self.layer.cornerRadius = rect.size.height/2;
    self.clipsToBounds = YES;
}

- (void)dealloc
{
    self.color = nil;
    [super dealloc];
}

@end

@interface APColorSlider ()
@property (nonatomic, retain) PFColorSliderBackgroundView *backgroundView;
@property (assign) APSliderBackgroundStyle style;
@end

@implementation APColorSlider
@synthesize backgroundView;
@synthesize slider;

- (id)initWithFrame:(CGRect)frame color:(UIColor *)c style:(APSliderBackgroundStyle)s
{
    self = [super initWithFrame:frame];
    
    CGRect internalFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    self.style = s;
    
    self.slider = [[[UISlider alloc] initWithFrame:internalFrame] autorelease];
    self.slider.minimumValue = 0.0000001f;
    self.slider.maximumValue = 1.0;
    internalFrame.size.height = 10; // set to ten because we want a thin BG
    internalFrame.origin.y = ((frame.size.height - 10) / 2);
    self.backgroundView = [[[PFColorSliderBackgroundView alloc] initWithFrame:internalFrame color:c style:s] autorelease];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.slider];
    
    [self updateGraphicsWithColor:c];
    
    return self;
}

- (void)updateGraphicsWithColor:(UIColor *)color
{
    if (self.style == APSliderBackgroundStyleSaturation)
    {
        [self.slider setThumbImage:[self thumbImageWithColor:[UIColor colorWithHue:color.APHue saturation:color.APSaturation brightness:1 alpha:1]] forState:UIControlStateNormal];
    }
    else if (self.style == APSliderBackgroundStyleBrightness)
    {
        [self.slider setThumbImage:[self thumbImageWithColor:[UIColor colorWithHue:color.APHue saturation:1 brightness:color.APBrightness alpha:1]] forState:UIControlStateNormal];
    }
    else if (self.style == APSliderBackgroundStyleAlpha)
    {
        [self.slider setThumbImage:[self thumbImageWithColor:[UIColor colorWithHue:color.APHue saturation:color.APSaturation brightness:color.APBrightness alpha:color.APAlpha]] forState:UIControlStateNormal];
    }
    
    self.slider.maximumTrackTintColor = [UIColor clearColor];
    self.slider.minimumTrackTintColor = [UIColor clearColor];
    
    self.backgroundView.color = color;
    [self.backgroundView setNeedsDisplay];
    
    if (self.style == APSliderBackgroundStyleSaturation)
        self.slider.value = color.APSaturation;
    else if (self.style == APSliderBackgroundStyleBrightness)
        self.slider.value = color.APBrightness;
    else if (self.style == APSliderBackgroundStyleAlpha)
        self.slider.value = color.APAlpha;
    
    // self.backgroundColor = [UIColor colorWithPatternImage:[self trackImageWithColor:[UIColor purpleColor]]];
}

// - (UIImage *)trackImageWithColor:(UIColor *)color
// {
//   CGRect rect = self.bounds;
//   rect.size.height = 10;
//   UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, 10), NO, [UIScreen mainScreen].scale);
//   CGContextRef context = UIGraphicsGetCurrentContext();
//
//
//   for (int x = 0; x < rect.size.width; x++) {
//     float percent = 100-(((rect.size.width - x)/rect.size.width)*100.f);
//
//     if (self.style == PFSliderBackgroundStyleSaturation)
//       [[UIColor colorWithHue:[color hue] saturation:percent/100 brightness:1 alpha:1] setFill];
//     else if (self.style == PFSliderBackgroundStyleBrightness)
//       [[UIColor colorWithHue:[color hue] saturation:1 brightness:percent/100 alpha:1] setFill];
//       else if (self.style == PFSliderBackgroundStyleBrightness)
//         [[UIColor colorWithHue:[color hue] saturation:1 brightness:percent/100 alpha:1] setFill];
//
//     CGContextFillRect(context, CGRectMake(x, 0, 1, rect.size.height));
//   }
//
//
//   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//   UIGraphicsEndImageContext();
//   return image;
// }

- (UIImage *)thumbImageWithColor:(UIColor *)color
{
    CGFloat size = 40.0f;
    CGRect rect = CGRectMake(0.0f, 0.0f, size, size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
//    UIColor* color = [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 1];
    
    //// Shadow Declarations
    NSShadow* shadow = [[[NSShadow alloc] init] autorelease];
    shadow.shadowColor = [UIColor.blackColor colorWithAlphaComponent: 0.7];
    shadow.shadowOffset = CGSizeMake(0, 3);
    shadow.shadowBlurRadius = 9;
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(8, 8, 23, 23)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
    [color setFill];
    [ovalPath fill];
    CGContextRestoreGState(context);
    
    [UIColor.whiteColor setStroke];
    ovalPath.lineWidth = 7;
    [ovalPath stroke];

    /*
    CGContextSetLineWidth(context, 6);
    
    // CGContextSetFillColorWithColor(context, CGColorCreate(cs, components));
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1);
    
    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, rect.size.width / 3, 0, 2 * M_PI, 1);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    // CGContextScaleCTM(context, 0.8, 0.8);
    
    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, (rect.size.width / 3) - 3, 0, 2 * M_PI, 1);
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextDrawPath(context, kCGPathEOFill);
    CGContextSaveGState(context);
    
    CGContextAddArc(context, rect.size.width / 2, rect.size.height / 2, (rect.size.width / 3)*1.5 - 3, 0, 2 * M_PI, 1);
    CGContextSetShadow(context, CGSizeMake(0, 3), 5);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
    
//     CGContextSetShadow(context, CGSizeMake(0, 0), 0);
    // CGContextTranslateCTM(context, 0, rect.size.height);
    // CGContextScaleCTM(context, 1, -1);
    // CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    // CGContextSetLineWidth(context, 2.0);
    // CGContextSelectFont(context, "Helvetica Neue Bold", 15.0, kCGEncodingMacRoman);
    // CGContextSetCharacterSpacing(context, 1.7);
    // CGContextSetTextDrawingMode(context, kCGTextFill);
    // CGContextShowTextAtPoint(context, 10, 15, [NSString stringWithCharacters:&letter length:1].UTF8String, 1);
    */
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)dealloc
{
    self.backgroundView = nil;
    self.slider = nil;
    [super dealloc];
}

@end
