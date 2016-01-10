//
//  ViewController.m
//  NewtonsCradle
//
//  Created by mac on 16/1/10.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "ViewController.h"
#import "NewtonsCradleView.h"

@interface ViewController () {
    NewtonsCradleView *_newtonsCradle;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _newtonsCradle = [[NewtonsCradleView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_newtonsCradle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
