//
//  HBLoadButton.m
//  newbi
//
//  Created by 张锐 on 2017/8/16.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import "HBLoadButton.h"
#import "HBRoundView.h"
#import "UIImage+Utilities.h"

static NSString *kLoadButtonStrokeAnimationKey = @"loadButton.stroke";

@interface HBLoadButton()

@property (nonatomic, strong) HBRoundView   *roundView;
@property (nonatomic, assign) BOOL          isLoading;
@property (nonatomic, assign) CGRect        originFrame;

@end

@implementation HBLoadButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI
{
    _roundView = [[HBRoundView alloc] init];
    _roundView.hidden = YES;
    _roundView.strokeColor = [UIColor whiteColor];
    _roundView.progress = 1;
    [self addSubview:_roundView];
    
    _isLoading = NO;
//    self.clipsToBounds = YES;  //layer.cornerRadius
    [self setBackgroundImage:[UIImage imageWithColor:HBColor(21, 180, 241)]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:HBColor(27, 153, 202)]
                    forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:HBColor_alpha(40, 168, 240, 0.4)]
                    forState:UIControlStateDisabled];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_originFrame.size.height == 0) {
//        self.layer.cornerRadius = self.bounds.size.height / 2;
        _originFrame = self.frame;
        //居中
        CGFloat wh = _originFrame.size.height / 2;
        CGFloat x = (_originFrame.size.height - wh) / 2;
        CGFloat y = (_originFrame.size.height - wh) / 2;
        _roundView.frame = CGRectMake(x, y, wh, wh);
    }
}

- (void)beginAnimation
{
    _isLoading = YES;
    _roundView.progress = 1;
    //圆形
    self.layer.cornerRadius = self.bounds.size.height / 2;
    self.clipsToBounds = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat radius = MIN(_originFrame.size.height, _originFrame.size.width);
        CGFloat x = (CGRectGetMinX(_originFrame) + CGRectGetWidth(_originFrame) / 2 - radius / 2);
        CGFloat y = CGRectGetMinY(_originFrame);
        CGFloat wh = radius;
        self.frame = CGRectMake(x, y, wh, wh);
        self.imageView.alpha = 0;
        self.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        _roundView.hidden = NO;
        [_roundView beginAnimation];
        [self setNeedsLayout];
        [self layoutIfNeeded]; 
    }];
}

- (void)endAnimation
{
    _isLoading = NO;
    _roundView.progress = 0;
    [_roundView endAnimation];
//    self.layer.cornerRadius = self.bounds.size.height / 2;
    self.clipsToBounds = NO;//完成动画后剪切关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _roundView.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = _originFrame;
            self.imageView.alpha = 1;
            self.titleLabel.alpha = 1;
        } completion:^(BOOL finished) {
            _roundView.hidden = YES;
        }];
    });
}

- (BOOL)isLoading
{
    return _isLoading;
}

@end
