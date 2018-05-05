//
//  HBInputView.h
//  newbi
//
//  Created by 张锐 on 2017/8/16.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, InputViewType)
{
    InputViewType_unknown = 0,
    InputViewType_normal,
    InputViewType_pwd,
    InputViewType_country,
};

@class HBInputView;

@protocol HBInputViewDelegate <NSObject>

@optional
- (void)inputView:(HBInputView *)inputView
textFieldEditChangedAtText:(NSString *)text;

- (void)inputView:(HBInputView *)inputView
textFieldShouldEndEditAtText:(NSString *)text;

- (void)inputView:(HBInputView *)inputView
textFieldShouldBeginEditAtText:(NSString *)text;

- (void)inputView:(HBInputView *)inputView
countryCodeButtonClicked:(UIButton *)button;

- (BOOL)inputView:(HBInputView *)inputView
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string;

- (BOOL)inputViewShouldReturn:(HBInputView *)inputView;

@end

@interface HBInputView : UIView

@property (nonatomic, weak) id<HBInputViewDelegate> delegate;

@property (nonatomic, strong) UITextField       *textField;

@property (nonatomic, copy) NSString            *placeholder;
@property (nonatomic, assign) InputViewType     type;

@property (nonatomic, copy) NSString            *tips;
@property (nonatomic, strong) UIColor           *tipsColor;
@property (nonatomic, strong) UIFont            *tipsFont;
@property (nonatomic, assign) BOOL              tipsHidden;

@property (nonatomic, copy) NSString            *tipsImage;
@property (nonatomic, assign) BOOL              tipsImageHidden;

@property (nonatomic, copy) NSString            *countryCode;

@property (nonatomic, strong) UIColor           *textColor;
@property (nonatomic, strong) UIFont            *textFont;
@property (nonatomic, copy) NSString            *text;

@property(nonatomic) UIKeyboardType             keyboardType;
@property (nonatomic, copy) NSString            *lookNormalImage;
@property (nonatomic, copy) NSString            *lookSelectImage;

@property (nonatomic, assign) BOOL              secureTextEntry;
@property (nonatomic, assign) BOOL              becomeFirstResponder;
@property (nonatomic, assign) BOOL              becomeResignFirstResponder;


- (void)setTips:(NSString *)tips
      tipsColor:(UIColor *)tipsColor;

- (void)setPlaceholder:(NSString *)placeholder
      placeholderColor:(UIColor *)placeholderColor
              fontSize:(CGFloat)fontSize;

- (void)setLineNormalColor:(UIColor *)color
                 highColor:(UIColor *)highColor;

@end
