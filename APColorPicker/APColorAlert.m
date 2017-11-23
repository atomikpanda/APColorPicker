//
//  APColorAlert.m
//  APColorPicker
//
//  Created by Bailey Seymour on 10/21/17.
//  Copyright © 2017 Bailey Seymour. All rights reserved.
//

#import "APColorAlert.h"
#import <UIKit/UIKit.h>
#import <APColorPicker/UIColor+APColor.h>
#import <APColorPicker/APHaloHueView.h>
#import <APColorPicker/APColorSlider.h>
#import <APColorPicker/APColorPreviewView.h>


@interface APColorAlertViewController : UIViewController
@end

@interface APColorAlert() <APHaloHueViewDelegate>

- (APColorAlert *)init;

@property (nonatomic, retain) APHaloHueView *haloView;
@property (nonatomic, retain) APColorAlertViewController *mainViewController;
@property (nonatomic, retain) UIView *blurView;
@property (nonatomic, retain) UIButton *hexButton;
@property (nonatomic, retain) UIWindow *darkeningWindow;
@property (nonatomic, retain) APColorSlider *brightnessSlider;
@property (nonatomic, retain) APColorSlider *saturationSlider;
@property (nonatomic, retain) APColorSlider *alphaSlider;
@property (nonatomic, retain) APColorPreviewView *colorPreviewView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, copy) void (^completionBlock)(UIColor *pickedColor);

@end

@implementation APColorAlertViewController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end

@implementation APColorAlert
@synthesize popWindow;
@synthesize haloView;
@synthesize mainViewController;
@synthesize blurView;
@synthesize hexButton;
@synthesize darkeningWindow;
@synthesize brightnessSlider;
@synthesize saturationSlider;
@synthesize alphaSlider;
@synthesize colorPreviewView;
@synthesize completionBlock;

- (APColorAlert *)init
{
    self = [super init];
    
    self.isOpen = NO;
    
    UIColor *startColor = [UIColor whiteColor];
    
    self.darkeningWindow = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.darkeningWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    
    CGRect winFrame = [UIScreen mainScreen].bounds;
    
    winFrame.origin.x = (winFrame.size.width * 0.09f) / 2;
    winFrame.origin.y = (winFrame.size.height * 0.09f) / 2;
    
    winFrame.size.width = winFrame.size.width - (winFrame.size.width * 0.09f);
    winFrame.size.height = winFrame.size.height - (winFrame.size.height * 0.09f);
    
    
    self.popWindow = [[[UIWindow alloc] initWithFrame:winFrame] autorelease];
    self.popWindow.layer.masksToBounds = true;
    self.popWindow.layer.cornerRadius = 15;
    
    self.mainViewController = [[[APColorAlertViewController alloc] init] autorelease];
    self.mainViewController.view.frame = CGRectMake(0, 0, winFrame.size.width, winFrame.size.height);
    
    const CGRect mainFrame = self.mainViewController.view.frame;
    

    self.blurView = [[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]] autorelease];
    self.blurView.frame = mainFrame;

    
    [self.blurView removeFromSuperview]; // <-- not sure why you're doing this but okay ¯\_(ツ)_/¯
    [self.mainViewController.view addSubview:self.blurView];
    
    CGRect haloViewFrame = CGRectMake((mainFrame.size.width / 2) - (((mainFrame.size.width / 3) * 2) / 2), (mainFrame.size.width / 6),
                                      (mainFrame.size.width / 3) * 2, (mainFrame.size.width / 3) * 2);
    
    self.haloView =
    // HUE HARDCODED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    [[[APHaloHueView alloc] initWithFrame:haloViewFrame minValue:0 maxValue:1 value:startColor.APHue delegate:self] autorelease];
    
    // [self.haloView makeReadyForDisplay];
    
    [self.haloView removeFromSuperview];
    [self.mainViewController.view addSubview:self.haloView];
    
    const CGRect sliderFrame = CGRectMake((mainFrame.size.width / 2) - (((mainFrame.size.width / 3) * 2) / 2),
                                          haloViewFrame.origin.y + haloViewFrame.size.height, (mainFrame.size.width / 3) * 2, 40);
    
    self.saturationSlider = [[[APColorSlider alloc] initWithFrame:sliderFrame color:startColor style:APSliderBackgroundStyleSaturation] autorelease];
    [self.mainViewController.view addSubview:self.saturationSlider];
    
    CGRect brightnessSliderFrame = sliderFrame;
    brightnessSliderFrame.origin.y = brightnessSliderFrame.origin.y + brightnessSliderFrame.size.height;
    
    self.brightnessSlider = [[[APColorSlider alloc] initWithFrame:brightnessSliderFrame color:startColor style:APSliderBackgroundStyleBrightness] autorelease];
    [self.mainViewController.view addSubview:self.brightnessSlider];
    
    CGRect alphaSliderFrame = brightnessSliderFrame;
    alphaSliderFrame.origin.y = alphaSliderFrame.origin.y + alphaSliderFrame.size.height;
    
    self.alphaSlider = [[[APColorSlider alloc] initWithFrame:alphaSliderFrame color:startColor style:APSliderBackgroundStyleAlpha] autorelease];
    [self.mainViewController.view addSubview:self.alphaSlider];
    
    self.alphaSlider.hidden = NO; // defaulting to NO
    
    self.hexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hexButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.hexButton addTarget:self action:@selector(chooseHexColor) forControlEvents:UIControlEventTouchUpInside];
    [self.hexButton setTitle:@"#" forState:UIControlStateNormal];
    self.hexButton.frame = CGRectMake(self.mainViewController.view.frame.size.width - (80 + 10), 10, 80, 25);
    [self.mainViewController.view addSubview:self.hexButton];
    
    CGRect colorPreviewViewFrame = CGRectMake((mainFrame.size.width / 2) - (((mainFrame.size.width / 6) * 2) / 2),
                                             (((haloViewFrame.origin.y) + (haloViewFrame.size.height)) - (((mainFrame.size.width / 6) * 2)) - ((mainFrame.size.width / 6))),
                                             (mainFrame.size.width / 6) * 2, (mainFrame.size.width / 6) * 2);
    
    self.colorPreviewView = [[[APColorPreviewView alloc] initWithFrame:colorPreviewViewFrame     // HUE HARDCODED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                                mainColor:[UIColor colorWithHue:startColor.APHue saturation:startColor.APSaturation brightness:startColor.APBrightness alpha:startColor.APAlpha] previousColor: startColor] autorelease];
    
    [self.colorPreviewView removeFromSuperview]; // why even xD adding view1 to view2 automatically removes view1 from its prior superview
    [self.mainViewController.view addSubview:self.colorPreviewView];
    
    self.darkeningWindow.hidden = NO;
    self.darkeningWindow.alpha = 0.0f;
    [self.darkeningWindow makeKeyAndVisible];
    
    self.popWindow.rootViewController = self.mainViewController;
    self.darkeningWindow.windowLevel = UIWindowLevelAlert - 2.0f;
    self.popWindow.windowLevel = UIWindowLevelAlert - 1.0f;
    self.popWindow.backgroundColor = [UIColor clearColor];
    self.popWindow.hidden = NO;
    self.popWindow.alpha = 0.0f;
    
    [self makeViewDynamic:self.popWindow];
    CGRect popWindowFrame = self.popWindow.frame;
    popWindowFrame.origin.y = ([UIScreen mainScreen].bounds.size.height - popWindowFrame.size.height) / 2;
    
    self.popWindow.frame = popWindowFrame;
    
    [self.saturationSlider.slider addTarget:self action:@selector(saturationChanged:) forControlEvents:UIControlEventValueChanged];
    [self.brightnessSlider.slider addTarget:self action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
    [self.alphaSlider.slider addTarget:self action:@selector(alphaChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self setPrimaryColor:startColor];
    
    return self;
}

- (APColorAlert *)initWithStartColor:(UIColor *)startColor showAlpha:(BOOL)showAlpha
{
    self = [self init];
    
    [self.haloView setValue:startColor.APHue];
    [self.saturationSlider updateGraphicsWithColor:startColor];
    [self.brightnessSlider updateGraphicsWithColor:startColor];
    [self.alphaSlider updateGraphicsWithColor:startColor];
    [self.colorPreviewView setMainColor:[UIColor colorWithHue:startColor.APHue saturation:startColor.APSaturation brightness:startColor.APBrightness alpha:startColor.APAlpha] previousColor:startColor];
    
    [self setPrimaryColor:startColor];
    
    self.alphaSlider.hidden = showAlpha ? 0 : 1; // invert logic
    
    return self;
}

- (void)makeViewDynamic:(UIView *)view
{
    CGRect dynamicFrame = view.frame;
    if (!self.alphaSlider.hidden)
        dynamicFrame.size.height =
        self.alphaSlider.frame.origin.y + (self.mainViewController.view.frame.size.width / 6) + self.alphaSlider.frame.size.height;
    else
        dynamicFrame.size.height =
        self.brightnessSlider.frame.origin.y + (self.mainViewController.view.frame.size.width / 6) + self.brightnessSlider.frame.size.height;
    
    view.frame = dynamicFrame;
}

+ (APColorAlert *)colorAlertWithStartColor:(UIColor *)startColor showAlpha:(BOOL)showAlpha
{
    return [[[APColorAlert alloc] initWithStartColor:startColor showAlpha:showAlpha] autorelease];
}

- (void)displayWithCompletion:(void (^)(UIColor *pickedColor))fcompletionBlock
{
    if (self.isOpen) return;
    
    self.completionBlock = fcompletionBlock;
    
    [self retain];
    
    [self.popWindow makeKeyAndVisible];

    [UIView animateWithDuration:0.3f animations:^{
        
        
        self.darkeningWindow.alpha = 1.0f;
        self.popWindow.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        self.isOpen = YES;
        UITapGestureRecognizer *tgr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)] autorelease];
        self.darkeningWindow.userInteractionEnabled = YES;
        [self.darkeningWindow addGestureRecognizer:tgr];
        
        
        
    }];
}

- (void)setPrimaryColor:(UIColor *)primary
{
    //UIColor *pr = [primary retain];
    [self.colorPreviewView updateWithColor:primary];
    
    [self.saturationSlider updateGraphicsWithColor:primary];
    [self.brightnessSlider updateGraphicsWithColor:primary];
    [self.alphaSlider updateGraphicsWithColor:primary];
    
    // THIS LINE SHOULD BE ACTIVE BUT DISABLED IT FOR NOW
    // UNTIL WE CAN GET THE HUE SLIDER WORKING
    [self.haloView setValue:primary.APHue];
    [self.hexButton setTitle:[UIColor AP_hexFromColor:self.colorPreviewView.mainColor] forState:UIControlStateNormal]; // update hex label
}

- (void)hueChanged:(float)hue
{
    [self.colorPreviewView updateWithColor:
     [UIColor colorWithHue:hue saturation:self.colorPreviewView.mainColor.APSaturation brightness:self.colorPreviewView.mainColor.APBrightness alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.saturationSlider updateGraphicsWithColor:
     [UIColor colorWithHue:hue saturation:self.colorPreviewView.mainColor.APSaturation brightness:self.colorPreviewView.mainColor.APBrightness alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.brightnessSlider updateGraphicsWithColor:
     [UIColor colorWithHue:hue saturation:self.colorPreviewView.mainColor.APSaturation brightness:self.colorPreviewView.mainColor.APBrightness alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.alphaSlider updateGraphicsWithColor:
     [UIColor colorWithHue:hue saturation:self.colorPreviewView.mainColor.APSaturation brightness:self.colorPreviewView.mainColor.APBrightness alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.hexButton setTitle:[UIColor AP_hexFromColor:self.colorPreviewView.mainColor] forState:UIControlStateNormal]; // update hex label
}

- (void)saturationChanged:(UISlider *)_slider
{
    [self.colorPreviewView updateWithColor:
     [UIColor colorWithHue:self.colorPreviewView.mainColor.APHue saturation:_slider.value brightness:self.colorPreviewView.mainColor.APBrightness alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.saturationSlider updateGraphicsWithColor:
     [UIColor colorWithHue:self.colorPreviewView.mainColor.APHue saturation:_slider.value brightness:self.colorPreviewView.mainColor.APSaturation alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.alphaSlider updateGraphicsWithColor:
     [UIColor colorWithHue:self.colorPreviewView.mainColor.APHue saturation:_slider.value brightness:self.colorPreviewView.mainColor.APBrightness alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.hexButton setTitle:[UIColor AP_hexFromColor:self.colorPreviewView.mainColor] forState:UIControlStateNormal]; // update hex label
}

- (void)brightnessChanged:(UISlider *)_slider
{
    [self.colorPreviewView updateWithColor:
     [UIColor colorWithHue:self.colorPreviewView.mainColor.APHue saturation:self.colorPreviewView.mainColor.APSaturation brightness:_slider.value alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.brightnessSlider updateGraphicsWithColor:
     [UIColor colorWithHue:self.colorPreviewView.mainColor.APHue saturation:self.colorPreviewView.mainColor.APSaturation brightness:_slider.value alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.alphaSlider updateGraphicsWithColor:
     [UIColor colorWithHue:self.colorPreviewView.mainColor.APHue saturation:self.colorPreviewView.mainColor.APSaturation brightness:_slider.value alpha:self.colorPreviewView.mainColor.APAlpha]];
    
    [self.hexButton setTitle:[UIColor AP_hexFromColor:self.colorPreviewView.mainColor] forState:UIControlStateNormal]; // update hex label
}

- (void)alphaChanged:(UISlider *)_slider
{
    [self.colorPreviewView updateWithColor:
     [UIColor colorWithHue:self.colorPreviewView.mainColor.APHue saturation:self.colorPreviewView.mainColor.APSaturation brightness:self.colorPreviewView.mainColor.APBrightness alpha:_slider.value]];
    
    [self.alphaSlider updateGraphicsWithColor:
     [UIColor colorWithHue:self.colorPreviewView.mainColor.APHue saturation:self.colorPreviewView.mainColor.APSaturation brightness:self.colorPreviewView.mainColor.APBrightness alpha:_slider.value]];
    
    [self.hexButton setTitle:[UIColor AP_hexFromColor:self.colorPreviewView.mainColor] forState:UIControlStateNormal]; // update hex label
}

- (void)chooseHexColor
{
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Hex Color" message:@"Enter a hex color or copy it to your pasteboard." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Set", @"Copy", nil];
    prompt.delegate = self;
    [prompt setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[prompt textFieldAtIndex:0] setText:[UIColor AP_hexFromColor:self.colorPreviewView.mainColor]];
    [prompt show];
    [prompt release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if ([[alertView textFieldAtIndex:0].text hasPrefix:@"#"] && [UIColor AP_colorWithHex:[alertView textFieldAtIndex:0].text])
        {
            [self setPrimaryColor:[UIColor AP_colorWithHex:[alertView textFieldAtIndex:0].text]];
        }
    }
    else if (buttonIndex == 2)
    {
        [[UIPasteboard generalPasteboard] setString:[UIColor AP_hexFromColor:self.colorPreviewView.mainColor]];
    }
}

- (void)close
{
    if (!self.isOpen) return;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.darkeningWindow.alpha = 0.0f;
        self.popWindow.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if (self.completionBlock)
            self.completionBlock(self.colorPreviewView.mainColor);
        
        self.popWindow.hidden = YES;
        self.isOpen = NO;
        
        [self release];
        
    }];
}

- (void)dealloc
{
    self.popWindow = nil;
    self.haloView = nil;
    self.mainViewController = nil;
    self.blurView = nil;
    self.hexButton = nil;
    self.darkeningWindow = nil;
    self.brightnessSlider = nil;
    self.saturationSlider = nil;
    self.alphaSlider = nil;
    self.colorPreviewView = nil;
    self.completionBlock = nil;
    
    [super dealloc];
}

@end
