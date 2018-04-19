//
//  UIView+Util.h
//  UsedCar
//
//  Created by Alan on 13-10-25.
//  Copyright (c) 2013年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

/* frame.origin.x */
@property (nonatomic) CGFloat minX;

/* frame.origin.y */
@property (nonatomic) CGFloat minY;

/* frame.origin.x + frame.size.width */
@property (nonatomic) CGFloat maxX;

/* frame.origin.y + frame.size.height */
@property (nonatomic) CGFloat maxY;

/* frame.size.width */
@property (nonatomic) CGFloat width;

/* frame.size.height */
@property (nonatomic) CGFloat height;


/**
 获取view向对于屏幕的x坐标,对scrollView上的子控件也有效
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
    获取view向对于屏幕的y坐标,对scrollView上的子控件也有效
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
    获取view向对于屏幕的frame,对scrollView上的子控件也有效
 */
@property (nonatomic, readonly) CGRect screenFrame;

/* frame.origin */
@property (nonatomic) CGPoint origin;

/* frame.size */
@property (nonatomic) CGSize size;

/**
    圆角(自动裁剪)
 */
@property (nonatomic) CGFloat cornerRadius;

/**
    为view设置一个宽度为(kLinePixel)的边框的颜色
 */
@property (nonatomic,strong) UIColor *borderColor;

/**
    获取子视图或者子视图的子视图....一直类推到最后一个view,中的第一响应者
 */
- (UIView*)subviewWithFirstResponder;
/**
 获取 子视图或者子视图的子视图....一直类推到最最后一个view,的指定类的view
 */

- (UIView*)subviewWithClass:(Class)cls;
/**
    获取 父视图或者父视图的父视图....一直类推到最window,的指定类的view
 */
- (UIView*)superviewWithClass:(Class)cls;

/**
 给view顶边界添加一个灰色细线,宽度自定
 */

-(void)addTopLine:(CGFloat)h;
/**
 给view底边界添加一个灰色细线,宽度自定
 */

-(void)addBottomLine:(CGFloat)h;
/**
 给view左边界添加一个灰色细线,宽度自定
 */

-(void)addLeftLine:(CGFloat)w;
/**
    给view右边界添加一个灰色细线,宽度自定
 */
-(void)addRightLine:(CGFloat)w;

/**
    移除全部子控件
 */
- (void)removeAllSubviews;

/**
    初始化view,并且设置frame和背景颜色
 */

-(instancetype)initWithFrame:(CGRect)frame color:(UIColor *)bgColor;
/**
    屏幕全屏截图
 */
- (UIImage *)screenshot;




@end

@interface UITextField (Util)
-(void)showToolBar;
@end
@interface UITextView (Util)
-(void)showToolBar;
@end

@interface UILabel (RedPoint)
-(instancetype)initRedPoint:(CGPoint)center;
-(instancetype)initUnreadRedPoint:(CGPoint)center;
-(void)setBadgeValue:(NSString *)value attribute:(NSDictionary *)attribute;
@end