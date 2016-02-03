//
//  SpringyCarousel.m
//  SpringyCarousel
//
//  Created by mac on 16/2/2.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "SpringyCarousel.h"
#import "ItemBehaviorManager.h"

@implementation SpringyCarousel {
    CGSize _itemSize;
    UIDynamicAnimator *_dynamicAnimator;
    ItemBehaviorManager *_behaviorManager;
}

- (id)initWithItemSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _itemSize = size;
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        _behaviorManager = [[ItemBehaviorManager alloc] initWithAnimator:_dynamicAnimator];
    }
    
    return self;
}

#pragma mark - Overridden methods
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGFloat scrollDelta = newBounds.origin.x - self.collectionView.bounds.origin.x;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    for (UIAttachmentBehavior *behavior in [_behaviorManager.attachmentBehaviors allValues]) {
        CGPoint anchorPoint = behavior.anchorPoint;
        CGFloat distFromTouch = ABS(anchorPoint.x - touchLocation.x);
        
        UICollectionViewLayoutAttributes *attr = [behavior.items firstObject];
        CGPoint center = attr.center;
        CGFloat scrollFactor = MIN(1, distFromTouch / 500);
        
        center.x += scrollDelta * scrollFactor;
        attr.center = center;
        
        [_dynamicAnimator updateItemUsingCurrentState:attr];
    }
    
    return NO;
}

- (void)prepareLayout {
    [UIView setAnimationsEnabled:NO];
    self.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(self.collectionView.bounds) - _itemSize.height, 0, 0, 0);
    [super prepareLayout];
    
    // Get a list of the objects around the current view
    CGRect expandedViewPort = self.collectionView.bounds;
    expandedViewPort.origin.x -= 2 * _itemSize.width;
    expandedViewPort.size.width += 4 * _itemSize.width;
    NSArray *currentItems = [super layoutAttributesForElementsInRect:expandedViewPort];
    
    // We update our behavior collection to just contain the objects we can currently (almost) see
    [_behaviorManager updateItemCollection:currentItems];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

@end
