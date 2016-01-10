//
//  BallBearingView.m
//  NewtonsCradle
//
//  Created by mac on 16/1/10.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "BallBearingView.h"

@implementation BallBearingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // init
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = MIN(CGRectGetHeight(frame), CGRectGetWidth(frame)) / 2.0;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2;
    }
    
    return self;
}

@end
