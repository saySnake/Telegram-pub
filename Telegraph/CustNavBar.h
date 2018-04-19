//
//  CustNavBar.h
//  Drlink-IOS
//
//  Created by 张玮 on 15/3/17.
//  Copyright (c) 2015年 DrLink. All rights reserved.
// 导航栏

#import <UIKit/UIKit.h>
typedef void (^navItemClick)(NSInteger index);
typedef void (^navTitleClick)(UIButton *button);

@interface CustNavBar :UIView
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic ,copy)navItemClick itemClick;
@property (nonatomic ,copy)navTitleClick btnClick;


-(void)setLeftItemImage:(NSString *)image;
-(void)setRightItemImage:(NSString *)image;
-(void)setBarTitle:(NSString *)title;
- (void)setCenterView:(UIView *)view;
///**
// *  晃动
// *
// *  @param str   str
// *  @param shake shake
// */
//- (void)showAlertWithString:(NSString *)str isShaeke:(BOOL)shake;
//
@end

