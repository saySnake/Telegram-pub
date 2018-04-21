//
//  UIView+EKB.h
//  xiaoke
//
//  Created by PW on 15/2/2.
//  Copyright (c) 2015年 张玮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EKB)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat centreX;

@property (nonatomic, assign) CGFloat centreY;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;

/**
 *  设置顶部圆角
 */
- (void)setCornerOnTop;
/**
 *  设置底部圆角
 */
- (void)setCornerOnBottom;
/**
 *  设置所有圆角
 */
- (void)setAllCorner;
/**
 *  设置没有圆角
 */
- (void)setNoneCorner;
/**
 *  设置左边圆角
 */
- (void)setCornerOnLeft;
/**
 *  设置右边圆角
 */
- (void)setCornerOnRight;

@end
