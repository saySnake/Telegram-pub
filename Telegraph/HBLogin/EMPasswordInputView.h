//
//  EMPasswordInputView.h
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/24.
//

#import <UIKit/UIKit.h>

@class EMPasswordInputView;
@protocol EMPasswordInputViewDelegate <NSObject>
@optional
/** 输入结束后调用，返回结果字符*/
- (void)EM_passwordInputView:(EMPasswordInputView *)passwordView finishInput:(NSString *)contentStr;

/** 编辑时调用，返回当前完整字符串及当前最后一位*/
- (void)EM_passwordInputView:(EMPasswordInputView *)passwordView edittingPassword:(NSString *)contentStr inputStr:(NSString *)inputStr;
@end

@interface EMPasswordInputView : UIView

typedef NS_ENUM(NSInteger, EMPasswordType){
    EMPasswordTypeDefault,  // ------明文显示
    EMPasswordTypeStar,     // ------星号显示
    EMPasswordTypeX,        // ------叉号显示
    EMPasswordTypeDots,     // ------圆点显示
    EMPasswordTypeCircle,   // ------圆圈显示
    EMPasswordTypeCustom,   // ------自定义字符串，最多两位
};

/** 密码显示类型,默认为明文显示*/
@property (nonatomic,assign) EMPasswordType passwordType;
/** 密码显示字符，当passwordType设置为Custom时生效*/
@property (nonatomic, copy) NSString *customPasswordStr;

/** 只读，获取横线宽度*/
@property (nonatomic, assign, readonly) CGFloat widthOfLine;
/** 只读，获取横线间隔*/
@property (nonatomic, assign, readonly) CGFloat intervalOfLine;

/** 设置未输入状态横线颜色*/
//@property (nonatomic, strong) UIColor *normalColor;
///** 设置输入后横线颜色*/
//@property (nonatomic, strong) UIColor *highLightColor;

/** 设置内容文字颜色*/
@property (nonatomic, strong) UIColor *contentColor;
/** 设置内容文字字体*/
@property (nonatomic, assign) CGFloat contentFontSize;

/** 设置内容文字属性*/
@property (nonatomic, strong) NSDictionary *contentAttributes;

/** 设置横线高度,默认为2.0f*/
@property (nonatomic, assign) CGFloat lineHeight;

/** 设置横线与文字偏移量,默认为0*/
@property (nonatomic, assign) CGFloat wordsLineOffset;

/** 设置键盘类型，默认为UIKeyboardTypeDefault*/
@property (nonatomic, assign) UIKeyboardType passwordKeyboardType;

/** 设置代理*/
@property (nonatomic, weak) id<EMPasswordInputViewDelegate> delegate;


/**
 * 初始化方法
 * @param frame 设置当前view的frame
 * @param count 需要字符位数的数量
 * @param width 设置横线宽度
 * @param interval 设置横线间隔
 */
+ (instancetype)inputViewWithFrame:(CGRect)frame numberOfCount:(NSUInteger)count widthOfLine:(CGFloat)width intervalOfLine:(CGFloat)interval;

/**
 * 初始化方法
 * @param frame 设置当前view的frame
 * @param count 需要字符位数的数量
 * @param width 设置横线宽度
 * @param interval 设置横线间隔
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfCount:(NSUInteger)count widthOfLine:(CGFloat)width intervalOfLine:(CGFloat)interval;

/**
 * 改变横线的颜色，与设置属性效果相同
 * @param normalColor 普通状态下横线颜色
 * @param highLightColor 高亮状态下横线颜色
 */
- (void)inputViewColorWithNormalColor:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor;


@end
