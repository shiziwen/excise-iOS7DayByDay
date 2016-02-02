//
//  ViewController.m
//  SpringyCarousel
//
//  Created by mac on 16/2/1.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewSampleCell.h"
#import "SpringyCarousel.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UICollectionViewFlowLayout *_collectionViewLayout;
    NSMutableArray *_collectionViewCellContent;
    CGSize itemSize;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    itemSize = CGSizeMake(70, 70);
    
    [self prepareSpringCarousel];
    [self createCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareSpringCarousel {
    _collectionViewLayout = [[SpringyCarousel alloc] initWithItemSize:itemSize];
    self.collectionView.collectionViewLayout = _collectionViewLayout;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)createCells {
    _collectionViewCellContent = [NSMutableArray array];
    for (int i=0; i<30; i++) {
        [_collectionViewCellContent addObject:@(i)];
    }
}

# pragma mark - UICollectionViewDataSource method
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_collectionViewCellContent count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewSampleCell *cell = (CollectionViewSampleCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"SpringyCell" forIndexPath:indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)[_collectionViewCellContent[indexPath.row] integerValue]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return itemSize;
}

@end
