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
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2;
    }
    
    return self;
}

@end
