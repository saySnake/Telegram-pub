//
//  DDButton.h
//  DDBuyMedicine
//
//  Created by 柳文杰 on 15/3/16.
//  Copyright (c) 2015年 柳文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger, DDButtonSubviewLayoutStyle) {
    DDButtonSubviewLayoutStyleHorizontal    =0,
    DDButtonSubviewLayoutStyleHorizontalReverse,
    DDButtonSubviewLayoutStyleVertical,
    DDButtonSubviewLayoutStyleVerticalReverse,
};


@interface DDButton : UIButton
@property (nonatomic) CGRect imgFrame;
@property (nonatomic) CGRect titFrame;
@property (nonatomic) NSTextAlignment textAlignment;

-(instancetype)initWithTitleFrame:(CGRect)tframe;

-(instancetype)initWithImageFrame:(CGRect)iframe;

-(instancetype)initWithImageFrame:(CGRect)iframe withTitleFrame:(CGRect)tframe;

/**
    初始化
 */
- (instancetype)initWithStyle:(DDButtonSubviewLayoutStyle)style;
/**
    imageView 和 titleLabel 布局样式, 默认 DDButtonSubviewLayoutStyleVertical;
 */
@property (nonatomic) NSInteger subviewLayoutStyle;

/**
    按钮内部imageView size
 */
@property (nonatomic, assign) CGSize imageViewSize;

/**
    按钮内部imageView的frame调整,
    @top:   距离顶部间隔调整
    @left:  左边间隔调整
    @bottom:    底部间隔
    @right:     右边间隔
 */
@property (nonatomic) UIEdgeInsets imageInsets;

/**
    字体 默认 kFontNormal
 */
@property (nonatomic, strong) UIFont *titleFont;


//-(void)startAnimation;
//-(void)stopAnimation;
//
@end


