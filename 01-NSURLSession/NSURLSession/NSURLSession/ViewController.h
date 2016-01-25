//
//  ViewController.h
//  NSURLSession
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) NSURLSessionDownloadTask *resumeTask;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;


- (IBAction)touchStartButton:(id)sender;
- (IBAction)touchPauseButton:(id)sender;
- (IBAction)touchResumeButton:(id)sender;

@end

