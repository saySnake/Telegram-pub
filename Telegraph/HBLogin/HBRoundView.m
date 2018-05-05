//
//  HBRoundView.m
//  newbi
//
//  Created by 张锐 on 2017/9/11.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import "HBRoundView.h"

@interface HBRoundView()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation HBRoundView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.strokeColor = [UIColor redColor].CGColor;
    _circleLayer.lineWidth = 2;
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.strokeEnd = 0;
    [self.layer addSublayer:_circleLayer];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _circleLayer.frame = self.bounds;
    
    CGFloat centerX = self.bounds.size.width / 2;
    CGFloat centerY = self.bounds.size.height / 2;
    CGPoint point = CGPointMake(centerX, centerY);
    CGFloat radius = self.bounds.size.height / 2;
    _circleLayer.path = [UIBezierPath bezierPathWithArcCenter:point
                                                       radius:radius
                                                   startAngle:(-0.5 * M_PI)
                                                     endAngle:(M_PI * 0.9)
                                                    clockwise:YES].CGPath;
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    _circleLayer.strokeColor = strokeColor.CGColor;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _circleLayer.strokeEnd = progress;
}

- (void)beginAnimation
{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 0.7;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:@"HBRefreshHeader.animation"];
}

- (void)endAnimation
{
    [self.layer removeAnimationForKey:@"HBRefreshHeader.animation"];
}

@end
