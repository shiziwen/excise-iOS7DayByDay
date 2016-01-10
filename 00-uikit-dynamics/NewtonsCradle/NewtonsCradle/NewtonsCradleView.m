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
    NSArray *_ballAnchors;
    
    UIDynamicAnimator *_animator;
    UIPushBehavior *_userDragBehavior;
    
    NSUInteger numberBalls;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        numberBalls = 5;
        
        [self createBallBearingsAndAnchors];
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
    //估算球的大小，占屏1/3，处于屏幕中间方便用户玩
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
        
        //为球添加Oberser，当球的center属性发生改变时，会通知UIView的方法，刷新view，这儿主要是为了在球移动的时候保持锚点和球之间的连接线。
        // [ballBear addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:Nil];
        
        [ballBearings addObject:ballBear];
        [self addSubview:ballBear];
    }
    
    _ballBearings = [NSArray arrayWithArray:ballBearings];
}

// create balls and anchors
- (void)createBallBearingsAndAnchors {
    NSMutableArray *ballBearings = [NSMutableArray array];
    NSMutableArray *ballAnchors = [NSMutableArray array];
    
    //估算球的大小，占屏1/3，处于屏幕中间方便用户玩
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
        
        //为球添加Oberser，当球的center属性发生改变时，会通知UIView的方法，刷新view，这儿主要是为了在球移动的时候保持锚点和球之间的连接线。
        [ballBear addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:Nil];
        
        [ballBearings addObject:ballBear];
        [self addSubview:ballBear];
        
        // 锚点
        CGPoint anchor = ballBear.center;
        anchor.y -= CGRectGetHeight(self.bounds) / 4.0;
        UIView *blueBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        blueBox.backgroundColor = [UIColor blueColor];
        blueBox.center = anchor;
        
        [ballAnchors addObject:blueBox];
        [self addSubview:blueBox];
    }
    
    _ballBearings = [NSArray arrayWithArray:ballBearings];
    _ballAnchors = [NSArray arrayWithArray:ballAnchors];
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
    // 添加UIDynamic的动力行为，同时把多个动力行为组合为一个复杂的动力行为。
    UIDynamicBehavior *behavior = [[UIDynamicBehavior alloc] init];
    
    [self applyAttachmentBehaviorForBalls:behavior];
    
    [behavior addChildBehavior:[self createGravityBehaviorForObjects:_ballBearings]];
    [behavior addChildBehavior:[self createCollisionBehaviorForObjects:_ballBearings]];
    [behavior addChildBehavior:[self createItemBehaviorForObjects:_ballBearings]];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    [_animator addBehavior:behavior];
}

// 为每个球到对应的锚点添加一个AttachmentBehavior，并作为一个子Behavior添加到一个Behavior中
- (void)applyAttachmentBehaviorForBalls:(UIDynamicBehavior *)behavior {
    for (NSUInteger i=0; i<numberBalls; i++) {
        UIDynamicBehavior *attachmentBehavior = [self createAttachmentBehaviorForBallBearing:[_ballBearings objectAtIndex:i]
                                                                                    toAnchor:[_ballAnchors objectAtIndex:i]];
        [behavior addChildBehavior:attachmentBehavior];
    }
}

- (UIDynamicBehavior *)createAttachmentBehaviorForBallBearing:(id<UIDynamicItem>)ballBearing {
    CGPoint anchor = ballBearing.center;
    anchor.y -= CGRectGetHeight(self.bounds) / 4.0;
    
    // 锚点
    UIView *blueBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    blueBox.backgroundColor = [UIColor blueColor];
    blueBox.center = anchor;
    [self addSubview:blueBox];
    
    // 把球attach到锚点上
    UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:ballBearing attachedToAnchor:anchor];
    
    return behavior;
}


- (UIDynamicBehavior *)createAttachmentBehaviorForBallBearing:(id<UIDynamicItem>)ballBearing toAnchor:(id<UIDynamicItem>)anchor {
    // 把球attach到锚点上
    UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:ballBearing attachedToAnchor:[anchor center]];
    
    return behavior;
}

// 为所有的球添加一个重力行为
- (UIDynamicBehavior *)createGravityBehaviorForObjects:(NSArray *)objects {
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:objects];
    gravity.magnitude = 10;
    return gravity;
}

// 为所有的球添加一个碰撞行为
- (UIDynamicBehavior *)createCollisionBehaviorForObjects:(NSArray *)objects {
    return [[UICollisionBehavior alloc] initWithItems:objects];
}

// 为所有的球的动力行为做一个公有配置，像空气阻力，摩擦力，弹性密度等
- (UIDynamicBehavior *)createItemBehaviorForObjects:(NSArray *)objects {
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:objects];
    itemBehavior.elasticity = 1.0;
    itemBehavior.allowsRotation = NO;
    itemBehavior.resistance = 2.f;
    
    return itemBehavior;
}

#pragma mark - Observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //    Observer方法，当ball的center属性发生变化时，刷新整个view
    [self setNeedsDisplay];
}

//覆盖父类的方法，主要是为了在锚点和球之间画一条线
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(id<UIDynamicItem> ballBearing in _ballBearings){
        CGPoint anchor =[[_ballAnchors objectAtIndex:[_ballBearings indexOfObject:ballBearing]] center];
        CGPoint ballCenter = [ballBearing center];
        CGContextMoveToPoint(context, anchor.x, anchor.y);
        CGContextAddLineToPoint(context, ballCenter.x, ballCenter.y);
        CGContextSetLineWidth(context, 1.0f);
        [[UIColor blackColor] setStroke];
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    [self setBackgroundColor:[UIColor whiteColor]];
}

//添加了Observer必须释放，不然会造成内存泄露。
-(void)dealloc
{
    for (BallBearingView *ballBearing in _ballBearings) {
        [ballBearing removeObserver:self forKeyPath:@"center"];
    }
}
@end
