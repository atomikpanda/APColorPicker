//
//  ViewController.m
//  APExampleApp
//
//  Created by Bailey Seymour on 10/21/17.
//  Copyright © 2017 Bailey Seymour. All rights reserved.
//

#import "ViewController.h"
#import <APColorPicker/APColorPicker.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showColorPicker)];
    [self.view addGestureRecognizer:gest];
    
    UIImageView *tmpBg = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Users/atomikpanda/Downloads/IMG_0143.jpg"]];
    tmpBg.frame = self.view.frame;
    [self.view addSubview:tmpBg];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showColorPicker];
}

- (void)showColorPicker {
    NSString *readFromKey = @"someCoolKey"; //  (You want to load from prefs probably)
    NSString *fallbackHex = @"#ff0000";  // (You want to load from prefs probably)
    
    UIColor *startColor = [UIColor redColor];//LCPParseColorString(readFromKey, fallbackHex); // this color will be used at startup
    APColorAlert *alert = [APColorAlert colorAlertWithStartColor:startColor showAlpha:YES];
    
    // show alert and set completion callback
    [alert displayWithCompletion:
     ^void (UIColor *pickedColor) {
         // save pickedColor or do something with it
         NSString *hexString = [UIColor AP_hexFromColor:pickedColor];
         hexString = [hexString stringByAppendingFormat:@":%f", pickedColor.APAlpha];
         // you probably want to save hexString to your prefs
         // maybe post a notification here if you need to
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
