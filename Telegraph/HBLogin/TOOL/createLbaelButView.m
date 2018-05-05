//
//  createLbaelButView.m
//  poetryReading
//
//  Created by 锋俊天成-2 on 16/10/12.
//  Copyright © 2016年 锋俊天成-2. All rights reserved.
//

#import "createLbaelButView.h"

@implementation createLbaelButView

//UITextField的封装
+(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor blackColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}
//背景的封装
+(UIView *)createBgViewWithFrame:(CGRect)frame{
    
    UIView *BgView =[[UIView alloc]initWithFrame:frame];;
    BgView.layer.cornerRadius=3.0;
    BgView.backgroundColor = [UIColor redColor];
    return BgView;
    
}
//label的封装
+(UILabel *)createLabelFrame:(CGRect)frame font:(NSInteger)font text:(NSString *)text textColor:(UIColor *)color{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.font=[UIFont systemFontOfSize:font];
    return label;
}
+(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font backColor:(UIColor *)backColor
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (backColor) {
        
        [btn setBackgroundColor:backColor];
    }
    return btn;
}

@end
