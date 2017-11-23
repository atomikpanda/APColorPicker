//
//  APHaloHueView.h
//  APColorPicker
//
//  Created by Bailey Seymour on 10/21/17.
//  Copyright © 2017 Bailey Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APHaloHueViewDelegate <NSObject>
- (void)hueChanged:(float)hue;
@end

@interface APHaloHueView : UIView

- (id)initWithFrame:(CGRect)frame minValue:(float)minimumValue maxValue:(float)maximumValue value:(float)initialValue delegate:(id<APHaloHueViewDelegate>)del;
@property (assign, getter = value, setter = setValue:) float value;
@property (assign) float minValue;
@property (assign) float maxValue;
@property (nonatomic, assign) id<APHaloHueViewDelegate> delegate;

@end
