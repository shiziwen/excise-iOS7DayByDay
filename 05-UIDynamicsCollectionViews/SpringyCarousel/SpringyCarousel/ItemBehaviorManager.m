//
//  ItemBehaviorManager.m
//  SpringyCarousel
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "ItemBehaviorManager.h"

@interface ItemBehaviorManager () {
    NSMutableDictionary *_attachmentBehaviors;
}

@end

@implementation ItemBehaviorManager

- (instancetype)initWithAnimator:(UIDynamicAnimator *)animator {
    self = [super init];
    if (self) {
        _animator = animator;
        _attachmentBehaviors = [NSMutableDictionary dictionary];
        [self createGravityBehavior];
        [self createCollisionBehavior];
        
        [self.animator addBehavior:self.gravityBehavior];
        [self.animator addBehavior:self.collisionBehavior];
    }
    
    return self;
}

#pragma mark - Property override

- (NSDictionary *)attachmentBehaviors {
    return [_attachmentBehaviors copy];
}

#pragma mark - Utility methods

- (void)createGravityBehavior {
    _gravityBehavior = [[UIGravityBehavior alloc] init];
    _gravityBehavior.magnitude = 0.3;
}

- (void)createCollisionBehavior {
    _collisionBehavior = [[UICollisionBehavior alloc] init];
    _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] init];
    itemBehavior.elasticity = 1;
    [_collisionBehavior addChildBehavior:itemBehavior];
}

- (UIAttachmentBehavior *)createAttachmentBehaviorForItem:(id<UIDynamicItem>)item anchor:(CGPoint)anchor {
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:item attachedToAnchor:anchor];
    attachmentBehavior.damping = 0.5;
    attachmentBehavior.frequency = 0.8;
    attachmentBehavior.length = 0;
    
    return attachmentBehavior;
}

#pragma mark - API Methods

- (void)addItem:(UICollectionViewLayoutAttributes *)item anchor:(CGPoint)anchor {
    UIAttachmentBehavior *attachmentBehavior = [self createAttachmentBehaviorForItem:item anchor:anchor];
    [self.animator addBehavior:attachmentBehavior];
    
    // And store it in the dictionary. Keyed by the index path
    [_attachmentBehaviors setObject:attachmentBehavior forKey:item.indexPath];
    
    // Also need to add this item to the global behaviors
    [self.gravityBehavior addItem:item];
    [self.collisionBehavior addItem:item];
}

- (void)removeItemAtIndex:(NSIndexPath *)indexPath {
    UIAttachmentBehavior *attachmentBehavior = self.attachmentBehaviors[indexPath];
    [self.animator removeBehavior:attachmentBehavior];
    
    for(UICollectionViewLayoutAttributes *attr in [self.gravityBehavior.items copy]) {
        if([attr.indexPath isEqual:indexPath]) {
            [self.gravityBehavior removeItem:attr];
        }
    }
    
    for (UICollectionViewLayoutAttributes *attr in [self.collisionBehavior.items copy]) {
        if ([attr.indexPath isEqual:indexPath]) {
            [self.collisionBehavior removeItem:attr];
        }
    }
    
    [_attachmentBehaviors removeObjectForKey:indexPath];
}

- (void)updateItemCollection:(NSArray *)items {
    NSMutableSet *toRemove = [NSMutableSet setWithArray:[self.attachmentBehaviors allKeys]];
    [toRemove minusSet:[NSSet setWithArray:[items valueForKey:@"indexPath"]]];
    
    for (NSIndexPath *indexPath in toRemove) {
        [self removeItemAtIndex:indexPath];
    }
    
    NSArray *exisitingIndexPaths = [self currentlyManagedItemIndexPaths];
    for (UICollectionViewLayoutAttributes *attr in items) {
        BOOL alreadyExists = NO;
        for (NSIndexPath *indexPath in exisitingIndexPaths) {
            if ([indexPath isEqual:attr.indexPath]) {
                alreadyExists = YES;
            }
        }
        if (!alreadyExists) {
            [self addItem:attr anchor:attr.center];
        }
    }
}

- (NSArray *)currentlyManagedItemIndexPaths {
    return [[_attachmentBehaviors allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([(NSIndexPath*)obj1 item] < [(NSIndexPath*)obj2 item]) {
            return NSOrderedAscending;
        } else if ([(NSIndexPath*)obj1 item] > [(NSIndexPath*)obj2 item]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

@end
