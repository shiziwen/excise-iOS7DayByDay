//
//  ItemBehaviorManager.h
//  SpringyCarousel
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ItemBehaviorManager : NSObject

@property (readonly, strong) UIGravityBehavior *gravityBehavior;
@property (readonly, strong) UICollisionBehavior *collisionBehavior;
@property (readonly, strong) NSDictionary *attachmentBehaviors;
@property (readonly, strong) UIDynamicAnimator *animator;

- (instancetype)initWithAnimator:(UIDynamicAnimator *)animator;

- (void)addItem:(UICollectionViewLayoutAttributes *)item anchor:(CGPoint)anchor;
- (void)removeItemAtIndex:(NSIndexPath *)indexPath;
- (void)updateItemCollection:(NSArray *)items;
- (NSArray *)currentlyManagedItemIndexPaths;

@end
