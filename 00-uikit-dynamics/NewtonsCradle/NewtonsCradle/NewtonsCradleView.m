//
//  NewtonsCradleView.m
//  NewtonsCradle
//
//  Created by mac on 16/1/10.
//  Copyright © 2016年 shiziwen. All rights reserved.
//

#import "NewtonsCradleView.h"
#import "BallBearingView.h"

@implementation NewtonsCradleView {
    NSArray *_ballBearings;
    UIDynamicAnimator *_animator;
    UIPushBehavior *_userDragBehavior;
    
    NSUInteger numberBalls;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        numberBalls = 5;
        [self createBallBearings];
        [self applyDynamicBehavior];
        
        // kick the cradle off with a push to start
        _userDragBehavior = [[UIPushBehavior alloc] initWithItems:@[_ballBearings[0]] mode:UIPushBehaviorModeInstantaneous];
        _userDragBehavior.pushDirection = CGVectorMake(-0.5, 0);
        [_animator addBehavior:_userDragBehavior];
    }
    
    return self;
}

- (void)createBallBearings {
    NSMutableArray *ballBearings = [NSMutableArray array];
    CGFloat ballSize = CGRectGetWidth(self.bounds) / (3.0 * (numberBalls - 1));
    
    for (NSUInteger i=0; i<numberBalls; i++) {
        // 避免球离得太近
        BallBearingView *ballBear = [[BallBearingView alloc] initWithFrame:CGRectMake(0, 0, ballSize - 1, ballSize - 1)];
        
        CGFloat x = CGRectGetWidth(self.bounds) / 3.0 + i * ballSize;
        CGFloat y = CGRectGetWidth(self.bounds) / 2.0;
        ballBear.center = CGPointMake(x, y);
        
        // 添加gesture recogniser
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBallBearingPan:)];
        [ballBear addGestureRecognizer:gesture];
        
        [ballBearings addObject:ballBear];
        [self addSubview:ballBear];
    }
    
    _ballBearings = [NSArray arrayWithArray:ballBearings];
}

#pragma mark - UIGestureRecgnizer target method
- (void)handleBallBearingPan:(UIPanGestureRecognizer *)recognizer {
    // 用户开始拖动时创建一个新的UIPushBehavior,并添加到animator中
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_userDragBehavior) {
            [_animator removeBehavior:_userDragBehavior];
        }
        _userDragBehavior = [[UIPushBehavior alloc] initWithItems:@[recognizer.view] mode:UIPushBehaviorModeContinuous];
        [_animator addBehavior:_userDragBehavior];
    }
    
    // 用户完成拖动时，从animator移除PushBehavior
    _userDragBehavior.pushDirection = CGVectorMake([recognizer translationInView:self].x / 10.f, 0);
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [_animator removeBehavior:_userDragBehavior];
        _userDragBehavior = nil;
    }
}

#pragma mark - UIDynamic utility methods
- (void)applyDynamicBehavior {
    UIDynamicBehavior *behavior = [[UIDynamicBehavior alloc] init];
    
    for (id<UIDynamicItem> ballBearing in _ballBearings) {
        UIDynamicBehavior *attachmentBehavior = [self createAttachmentBehaviorForBallBearing:ballBearing];
        [behavior addChildBehavior:attachmentBehavior];
    }
    
    // apply gravity to the ball bearings
    [behavior addChildBehavior:[self createGravityBehaviorForObjects:_ballBearings]];
    
    // apply collision behavior to ball bearings
    [behavior addChildBehavior:[self createCollisionBehaviorForObjects:_ballBearings]];
    
    // apply dynamic item behavior
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:_ballBearings];
    itemBehavior.elasticity = 1.0;
    itemBehavior.allowsRotation = NO;
    itemBehavior.resistance = 2.f;
    [behavior addChildBehavior:itemBehavior];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    [_animator addBehavior:behavior];
}


- (UIDynamicBehavior *)createAttachmentBehaviorForBallBearing:(id<UIDynamicItem>)ballBearing {
    CGPoint anchor = ballBearing.center;
    anchor.y -= CGRectGetHeight(self.bounds) / 4.0;
    
    UIView *blueBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    blueBox.backgroundColor = [UIColor blueColor];
    blueBox.center = anchor;
    [self addSubview:blueBox];
    
    UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:ballBearing attachedToAnchor:anchor];
    
    return behavior;
}


// create gravity behavior
- (UIDynamicBehavior *)createGravityBehaviorForObjects:(NSArray *)objects {
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:objects];
    gravity.magnitude = 10;
    return gravity;
}


// create collision behavior
- (UIDynamicBehavior *)createCollisionBehaviorForObjects:(NSArray *)objects {
    return [[UICollisionBehavior alloc] initWithItems:objects];
}


@end
