//
//  MyTableCell.m
//  EditTableView
//
//  Created by shiguang on 2017/11/20.
//  Copyright © 2017年 shiguang. All rights reserved.
//

#import "MyTableCell.h"
#import "UIView+SDAutoLayout.h"

#define kDeleteButtonWidth      60.0f
#define kTagButtonWidth         100.0f
#define kCriticalTranslationX   30
#define kShouldSlideX           -2

@interface MyTableCell()

@property (nonatomic, assign) BOOL isSlided;

@end
@implementation MyTableCell
{
    UIButton *_deleteButton;
    UIButton *_tagButton;
    
    UIPanGestureRecognizer *_pan;
    UITapGestureRecognizer *_tap;
    
    BOOL _shouldSlide;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _deleteButton = [UIButton new];
    _deleteButton.backgroundColor = [UIColor redColor];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(aa:) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:_deleteButton belowSubview:self.contentView];
    _deleteButton.sd_layout
    .topEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(kDeleteButtonWidth);
    
    [self setupGestureRecognizer];
}

- (void)aa:(UIButton *)sender
{
    
}

- (void)setupGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    _pan = pan;
    pan.delegate = self;
    pan.delaysTouchesBegan = YES;
    [self.contentView addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.delegate = self;
    tap.enabled = NO;
    [self.contentView addGestureRecognizer:tap];
    _tap = tap;
}
- (void)tapView:(UITapGestureRecognizer *)tap
{
    if (self.isSlided) {
        [self cellSlideAnimationWithX:0];
    }
}

- (void)panView:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:pan.view];
    
    if (self.contentView.left <= kShouldSlideX) {
        _shouldSlide = YES;
    }
    
    if (fabs(point.y) < 1.0) {
        if (_shouldSlide) {
            [self slideWithTranslation:point.x];
        } else if (fabs(point.x) >= 1.0) {
            [self slideWithTranslation:point.x];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat x = 0;
        if (self.contentView.left < -kCriticalTranslationX && !self.isSlided) {
            x = -(kDeleteButtonWidth + kTagButtonWidth);
        }
        [self cellSlideAnimationWithX:x];
        _shouldSlide = NO;
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];
}


- (void)cellSlideAnimationWithX:(CGFloat)x
{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.contentView.left = x;
    } completion:^(BOOL finished) {
        self.isSlided = (x != 0);
    }];
}

- (void)slideWithTranslation:(CGFloat)value
{
    if (self.contentView.left < -(kDeleteButtonWidth + kTagButtonWidth) * 1.1 || self.contentView.left > 30) {
        value = 0;
    }
    self.contentView.left += value;
}

- (void)setIsSlided:(BOOL)isSlided
{
    _isSlided = isSlided;
    
    _tap.enabled = isSlided;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.contentView.left <= kShouldSlideX && otherGestureRecognizer != _pan && otherGestureRecognizer != _tap) {
        return NO;
    }
    return YES;
}
@end
