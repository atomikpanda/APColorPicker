//
//  APColorAlert.h
//  APColorPicker
//
//  Created by Bailey Seymour on 10/21/17.
//  Copyright © 2017 Bailey Seymour. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIWindow, UIColor;

@interface APColorAlert : NSObject
@property (nonatomic, retain) UIWindow *popWindow;

//- (void)showWithStartColor:(UIColor *)startColor showAlpha:(BOOL)showAlpha completion:(void (^)(UIColor *pickedColor))completionBlock;
+ (APColorAlert *)colorAlertWithStartColor:(UIColor *)startColor showAlpha:(BOOL)showAlpha;
- (APColorAlert *)initWithStartColor:(UIColor *)startColor showAlpha:(BOOL)showAlpha;
- (void)displayWithCompletion:(void (^)(UIColor *pickedColor))fcompletionBlock;
- (void)close;
@end
