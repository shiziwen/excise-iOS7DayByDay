//
//  ViewController.m
//  AVSpeechSynthesizer
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "ViewController.h"
#import "GreetingLanguage.h"

@import AVFoundation;

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *avaliableLanguages;
    AVSpeechSynthesizer *speechSynthesizer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    avaliableLanguages = [GreetingLanguage listOfGreetings];
    
    self.languagePicker.delegate = self;
    self.languagePicker.dataSource = self;
    self.greetingLabel.text = [[avaliableLanguages firstObject] greeting];
    
    speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    
    NSLog(@"speechVoices: %@", [AVSpeechSynthesisVoice speechVoices]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchGreetButton:(id)sender {
    GreetingLanguage *greetingLanguage = avaliableLanguages[[self.languagePicker selectedRowInComponent:0]];
    [speechSynthesizer speakUtterance:[greetingLanguage greetingUtterance]];
    
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [avaliableLanguages[row] name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.greetingLabel.text = [avaliableLanguages[row] greeting];
    NSLog(@"Language selected: %@", [avaliableLanguages[row] bcp47]);
}

#pragma mark - UIPickerViewDatasource methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [avaliableLanguages count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

@end
