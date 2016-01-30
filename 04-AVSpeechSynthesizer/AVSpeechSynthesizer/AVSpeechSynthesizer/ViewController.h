//
//  ViewController.h
//  AVSpeechSynthesizer
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *languagePicker;

@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
- (IBAction)touchGreetButton:(id)sender;

@end

