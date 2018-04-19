//
//  YJAlertView.h
//  DrLink_IOS
//
//  Created by liuwenjie on 15/5/22.
//  Copyright (c) 2015年 DrLink. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJAlertView;

static CGFloat const kTitleHeight = 40.f;
static CGFloat const kButtonHeight = 40.f;
static CGFloat const kInputHeight = 30.f;
static CGFloat const kMsgMaxHeight = 300.f;



typedef NS_ENUM(NSInteger, YJAlertViewStyle) {
    YJAlertViewStyleNormal,
    YJAlertViewStyleInput,
    YJAlertViewStyleCustom
};
typedef void(^CompeletClick)(YJAlertView *alert, NSInteger index);

@interface YJAlertView : UIView
{
}
@property (nonatomic, strong) UILabel *msgLbl;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSString *inputText;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic) BOOL isOpenTapClose;

/**
 自定义 alertView
 */
-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                   btnTitles:(NSArray *)titles
                       click:(CompeletClick)cblock;
/**
 自定义带输入框的alertView
 */
-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                  inputPlace:(NSString *)input
                   btnTitles:(NSArray *)titles
                       click:(CompeletClick)cblock;
/**
 
 */
-(instancetype)initWithTitle:(NSString *)title
            customCenterView:(UIView *)cview
            customBottomView:(UIView *)bview;
/**
 
 */
-(instancetype)initWithTitle:(NSString *)title
            customCenterView:(UIView *)cview
                       click:(CompeletClick)cblock;
/**
 
 */
-(instancetype)initWithTitle:(NSString *)title
            customCenterView:(UIView *)cview
                       click:(CompeletClick)cblock
                buttonTitles:(NSArray *)titles;
/**
 
 */
-(instancetype)initWithTitle:(NSString *)title customCenterView:(UIView *)cview customBottomView:(UIView *)bview withDuartion:(NSTimeInterval )time;

/**
    注册
 */
-(instancetype)initWithRegisterPhoto:(CompeletClick)cblock;
/**
    选择图片样式
 */
-(instancetype)initWithAlbumPhoto:(CompeletClick)cblock;

-(instancetype)initWithCustomAlertView:(UIView *)alertView;

-(void)show;
-(void)close;

-(void)showInView:(UIView *)view;

@end
