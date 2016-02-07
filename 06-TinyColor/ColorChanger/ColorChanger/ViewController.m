//
//  ViewController.m
//  ColorChanger
//
//  Created by mac on 16/2/6.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.dimTintSwitch.on = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeColorHandler:(id)sender {
    // Generate a random color
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.tintColor = color;
    [self updateProgressViewTint];
}

- (void)updateProgressViewTint
{
    self.progressView.progressTintColor = self.view.tintColor;
}

- (IBAction)dimTintHandler:(id)sender {
    if (self.dimTintSwitch.isOn) {
        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    } else {
        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    }
    [self updateProgressViewTint];
}

@end
