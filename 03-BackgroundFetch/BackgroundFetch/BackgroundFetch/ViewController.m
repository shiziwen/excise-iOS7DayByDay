//
//  ViewController.m
//  BackgroundFetch
//
//  Created by mac on 16/1/28.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)insertStatusObjectsForFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSUInteger numberCreated = 3;
    NSLog(@"Background fetch completed - %lu new updates", (unsigned long)numberCreated);
    UIBackgroundFetchResult result = UIBackgroundFetchResultNoData;
    if(numberCreated > 0) {
        result = UIBackgroundFetchResultNewData;
    }
    completionHandler(result);
    return numberCreated;
}

@end
