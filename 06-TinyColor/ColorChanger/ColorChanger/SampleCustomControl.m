//
//  SampleCustomControl.m
//  ColorChanger
//
//  Created by mac on 16/2/8.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "SampleCustomControl.h"

@implementation SampleCustomControl {
    UIView *_tintColorBlock;
    UILabel *_greyLable;
    UILabel *_tintColorLabel;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self prepareSubviews];
    }
    
    return self;
}

- (void)prepareSubviews {
    _tintColorBlock = [[UIView alloc] init];
    _tintColorBlock.backgroundColor = self.tintColor;
    [self addSubview:_tintColorBlock];
    
    _greyLable = [[UILabel alloc] init];
    _greyLable.text = @"Grey Label";
    _greyLable.textColor = [UIColor grayColor];
    [_greyLable sizeToFit];
    [self addSubview:_greyLable];
    
    _tintColorLabel = [[UILabel alloc] init];
    _tintColorLabel.text = @"Tint color label";
    _tintColorLabel.textColor = self.tintColor;
    [_tintColorLabel sizeToFit];
    [self addSubview:_tintColorLabel];
}

- (void)layoutSubviews {
    _tintColorBlock.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 3, CGRectGetHeight(self.bounds));
    
    CGRect frame = _greyLable.frame;
    frame.origin.x = CGRectGetWidth(self.bounds) / 3 + 10;
    frame.origin.y = 0;
    _greyLable.frame = frame;
    
    frame = _tintColorLabel.frame;
    frame.origin.x = CGRectGetWidth(self.bounds) /3 + 10;
    frame.origin.y = CGRectGetHeight(self.bounds) / 2;
    _tintColorLabel.frame = frame;
}

- (void)tintColorDidChange {
    _tintColorLabel.textColor = self.tintColor;
    _tintColorBlock.backgroundColor = self.tintColor;
}
@end
