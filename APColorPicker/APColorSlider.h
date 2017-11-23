//
//  APColorSlider.h
//  APColorPicker
//
//  Created by Bailey Seymour on 10/21/17.
//  Copyright © 2017 Bailey Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum APSliderBackgroundStyle : NSUInteger {
    APSliderBackgroundStyleSaturation = 5,
    APSliderBackgroundStyleBrightness = 6,
    APSliderBackgroundStyleAlpha      = 7
} APSliderBackgroundStyle;

@interface APColorSlider : UIView
@property (nonatomic, retain) UISlider *slider;
- (id)initWithFrame:(CGRect)frame color:(UIColor *)c style:(APSliderBackgroundStyle)s;
- (void)updateGraphicsWithColor:(UIColor *)color;
@end
