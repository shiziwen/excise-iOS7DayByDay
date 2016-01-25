//
//  ViewController.m
//  NSURLSession
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDownloadDelegate> {
    NSData *partialData;
    NSURLSession *inProgressSession;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressBar.progress = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchStartButton:(id)sender {
    NSLog(@"Start");
    
    if (!inProgressSession) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        inProgressSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    NSString *url = @"http://farm6.staticflickr.com/5505/9824098016_0e28a047c2_b_d.jpg";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    self.resumeTask = [inProgressSession downloadTaskWithRequest:request];
    [self.resumeTask resume];
}

- (IBAction)touchPauseButton:(id)sender {
    if (self.resumeTask) {
        [self.resumeTask cancelByProducingResumeData:^(NSData *resumeData){
            partialData = resumeData;
            self.resumeTask = nil;
        }];
    }
}

- (IBAction)touchResumeButton:(id)sender {
    NSLog(@"resume task");
    
    if (!self.resumeTask) {
        if (!inProgressSession) {
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            inProgressSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        }
        
        if (partialData) {
            self.resumeTask = [inProgressSession downloadTaskWithResumeData:partialData];
        } else {
            NSString *url = @"http://farm6.staticflickr.com/5505/9824098016_0e28a047c2_b_d.jpg";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            self.resumeTask = [inProgressSession downloadTaskWithRequest:request];
        }
        [self.resumeTask resume];
    }
}


#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    
    NSError *error;
    [fileManager removeItemAtURL:destinationPath error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
    
    // 文件保存成功后，使用GCD调用主线程把图片文件显示在UIImageView中
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationPath path]];
            self.imageView.image = image;
            self.imageView.hidden = NO;
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
        });
    } else {
        NSLog(@"Error when copy file: %@", error);
    }
    
    self.resumeTask = nil;
    partialData = nil;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 刷新进度条的delegate方法，同样的，获取数据，调用主线程刷新UI
    double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressBar.hidden = NO;
        self.progressBar.progress = currentProgress;
    });
}

@end
