//
//  ViewController.m
//  AssetCatalog
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat y = 100;
    for (UIImage *image in [self images]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, y);
        y += 100;
        [self.view addSubview:imageView];
    }
    
    [self createButtonImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createButtonImages {
    UIImage *btnImage = [UIImage imageNamed:@"ButtonSlice"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:btnImage];
    imageView.bounds = CGRectMake(0, 0, 150, CGRectGetHeight(imageView.bounds));
    imageView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, 300);
    [self.view addSubview:imageView];
    
    imageView = [[UIImageView alloc] initWithImage:btnImage];
    imageView.bounds = CGRectMake(0, 0, 300, CGRectGetHeight(imageView.bounds));
    imageView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, 350);
    [self.view addSubview:imageView];
}

- (NSArray *)images {
    return @[
             [UIImage imageNamed:@"USA"],
             [UIImage imageNamed:@"Australia"]
             ];
}

@end
