//
//  APColorPreviewView.h
//  APColorPicker
//
//  Created by Bailey Seymour on 10/21/17.
//  Copyright © 2017 Bailey Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APColorPreviewView : UIView
@property (nonatomic, retain) UIColor *mainColor;
@property (nonatomic, retain) UIColor *previousColor;
- (void)updateWithColor:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame mainColor:(UIColor *)mc previousColor:(UIColor *)prev;
- (void)setMainColor:(UIColor *)mc previousColor:(UIColor *)prev;
@end
