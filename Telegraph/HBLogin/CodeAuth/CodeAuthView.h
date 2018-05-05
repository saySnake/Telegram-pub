//
//  CodeAuthView.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/23.
/*
 本页面为三选一:
 1.在风控验证的时候,需要在阿里滑块和图形验证二选一
 2.再通过分控验证之后,是如果登陆失败是会出现有可能会出现两种情况:1.出现图片验证出错,再次出现图形验证2.出现需要二次验证,出现手机或google验证
 
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CodeAuthView;

@protocol codeAuthViewDelegate <NSObject>

-(void)codeAuthView:(CodeAuthView *)codeAuthView finishAuthWithStr:(NSString *)codeStr;//点击确定传值
-(void)codeAuthViewResendIMSCode;//重新发送信息验证码
-(void)codeAuthViewRegetImge;//重置图片
-(void)touchOrCancelAction;//取消或者触摸上部
@optional

@end

@interface CodeAuthView : UIView

@property (nonatomic, weak) id<codeAuthViewDelegate> delegate;
@property (nonatomic ,strong) UILabel *phoneLab;//公开

-(instancetype)initWithFrame:(CGRect)frame WithIsImage:(BOOL )isImage;
-(void)setPhoneAndGoogleWithISgoogle:(BOOL)IsGoogle WithPhoneString:(NSString *)phoneString WithImage:(UIImage *)image;
@end
