//
//  createLbaelButView.h
//  poetryReading
//
//  Created by 锋俊天成-2 on 16/10/12.
//  Copyright © 2016年 锋俊天成-2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface createLbaelButView : NSObject
//UITextField的封装
+(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder;
//背景的封装
+(UIView *)createBgViewWithFrame:(CGRect)frame;
//label的封装
+(UILabel *)createLabelFrame:(CGRect)frame font:(NSInteger)font text:(NSString *)text textColor:(UIColor *)color;
//封装button
+(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font backColor:(UIColor *)backColor;
@end
