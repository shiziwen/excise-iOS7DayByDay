//
//  SpringyCarousel.m
//  SpringyCarousel
//
//  Created by mac on 16/2/2.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "SpringyCarousel.h"

@implementation SpringyCarousel {
    CGSize _itemSize;
}

- (id)initWithItemSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _itemSize = size;
    }
    
    return self;
}

- (void)prepareLayout {
    [UIView setAnimationsEnabled:NO];
    self.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(self.collectionView.bounds) - _itemSize.height, 0, 0, 0);
    [super prepareLayout];
    
}
@end
