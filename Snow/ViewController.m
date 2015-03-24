//
//  ViewController.m
//  Snow
//
//  Created by AP Fritts on 3/23/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate>

@property (strong, nonatomic) NSArray *snowFlakes;
@property (strong, nonatomic) NSMutableSet *moltenSnowFlakes;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc] init];
    self.collision = [[UICollisionBehavior alloc] init];
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    [self.collision addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0, self.view.frame.size.height) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.collision addBoundaryWithIdentifier:@"roof" fromPoint:CGPointMake(0, self.view.frame.size.height * 0.6) toPoint:CGPointMake(self.view.frame.size.width * 0.3, self.view.frame.size.height * 0.7)];
    self.collision.collisionDelegate = self;
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
    self.moltenSnowFlakes = [NSMutableSet set];
}

-(void)makeSnow {
    NSInteger x = arc4random_uniform(self.view.frame.size.width);
    UIView *snowFlake = [[UIView alloc] initWithFrame:CGRectMake(x, -8, 8, 8)];
    snowFlake.backgroundColor = [UIColor whiteColor];
    snowFlake.layer.cornerRadius = 4;
    [self.view addSubview:snowFlake];
    [self.gravity addItem:snowFlake];
    [self.collision addItem:snowFlake];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p {
    NSString *boundary = (NSString *)identifier;
    if (![boundary isEqualToString:@"bottom"]) {
        return;
    }
    UIView *snowFlake = (UIView *)item;
    if ([self.moltenSnowFlakes containsObject:snowFlake]) {
        return;
    }
    [self meltSnowFlake:snowFlake];
    [self.moltenSnowFlakes addObject:snowFlake];
}

- (void)meltSnowFlake:(UIView *)snowFlake {
//    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:2.0 animations:^{
//        snowFlake.transform = scaleTransform;
        snowFlake.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.moltenSnowFlakes removeObject:snowFlake];
        [snowFlake removeFromSuperview];
        [self.gravity removeItem:snowFlake];
        [self.collision removeItem:snowFlake];
    }];
}


@end
