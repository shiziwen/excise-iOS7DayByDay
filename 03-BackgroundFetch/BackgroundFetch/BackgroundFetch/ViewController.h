//
//  ViewController.h
//  BackgroundFetch
//
//  Created by mac on 16/1/28.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (NSUInteger)insertStatusObjectsForFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end

