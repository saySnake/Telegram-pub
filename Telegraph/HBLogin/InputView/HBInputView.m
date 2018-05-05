//
//  HBInputView.m
//  newbi
//
//  Created by 张锐 on 2017/8/16.
//  Copyright © 2017年 张锐. All rights reserved.
//

#import "HBInputView.h"
#import "UITextField+Utilities.h"

@interface HBInputView() <UITextFieldDelegate>

@property (nonatomic, strong) UIView        *lineView;
@property (nonatomic, strong) UILabel       *tipsLabel;
@property (nonatomic, strong) UIButton      *lookButton;
@property (nonatomic, strong) UIImageView   *tipsImgView;
@property (nonatomic, strong) UIButton      *countryCodeButton;//国家的按钮

@property (nonatomic, strong) UIColor       *lineNormalColor;
@property (nonatomic, strong) UIColor       *lineHighColor;

@end

@implementation HBInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor lightGrayColor];
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [[UIColor redColor] CGColor];
    
    [self setupUI];
}

- (void)setupUI
{
    [self addSubview:self.textField];
    [self addSubview:self.lineView];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.lookButton];
    [self addSubview:self.tipsImgView];
    [self addSubview:self.countryCodeButton];
//    [self addSubview:self.countryButAccImg];
}

- (UIButton *)countryCodeButton
{
    if (!_countryCodeButton) {
        _countryCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_countryCodeButton setImage:[UIImage imageNamed:@"Choose_attribution"] forState:UIControlStateNormal];
        [_countryCodeButton setImage:[UIImage imageNamed:@"Choose_attribution"] forState:UIControlStateHighlighted];
        _countryCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_countryCodeButton setTitleColor:HBColor(78, 78, 78)
                                 forState:UIControlStateNormal];
        [_countryCodeButton addTarget:self
                               action:@selector(countryCodeButtonClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _countryCodeButton;
}
//- (UIImageView *)countryButAccImg
//{
//    if (!_countryButAccImg) {
//        _countryButAccImg = [[UIImageView alloc] init];
//        _countryButAccImg.image = [UIImage imageNamed:@"Choose_attribution"];
//        _countryButAccImg.contentMode = UIViewContentModeCenter;
////        _countryButAccImg.hidden = YES;
//    }
//    return _tipsImgView;
//}

- (void)countryCodeButtonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(inputView:countryCodeButtonClicked:)]) {
        [self.delegate inputView:self countryCodeButtonClicked:button];
    }
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = [UIColor whiteColor];
        _textField.tintColor = HBColor(21, 180, 241);
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.font = [UIFont systemFontOfSize:14];
        if (@available(iOS 11.0, *)) {
            // avoid autocomplete password
            self.textField.textContentType = @"";
        }
        _textField.delegate = self;
        [_textField addTarget:self
                       action:@selector(textFieldEditChanged:)
             forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HBColor_alpha(31, 63, 89, 1);
    }
    return _lineView;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = HBColor(255, 92, 92);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

- (UIImageView *)tipsImgView
{
    if (!_tipsImgView) {
        _tipsImgView = [[UIImageView alloc] init];
        _tipsImgView.image = [UIImage imageNamed:@"correct"];
        _tipsImgView.contentMode = UIViewContentModeCenter;
        _tipsImgView.hidden = YES;
    }
    return _tipsImgView;
}

- (UIButton *)lookButton
{
    if (!_lookButton) {
        _lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookButton.hidden = YES;
        UIImage *image = [[UIImage imageNamed:@"Invisible"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_lookButton setImage:image forState:UIControlStateNormal];
        [_lookButton addTarget:self action:@selector(lookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookButton;
}

- (void)lookButtonClicked:(UIButton *)button
{
    // 解决光标异位问题，参考 https://stackoverflow.com/questions/35293379/uitextfield-securetextentry-toggle-set-incorrect-font
//    [self.textField resignFirstResponder];
    
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    [self.textField setFont:nil];
    [self.textField setFont:self.textField.font];
    //解决光标位移出错问题
    [self.textField becomeFirstResponder];
    button.selected = !button.selected;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    
    CGFloat tipsLabel_h = 20;
    CGFloat textField_h = h - tipsLabel_h;
    CGFloat lineView_h = 1;
    
    self.textField.frame = CGRectMake(0, 0, w, textField_h);
    //self.lineView.frame = CGRectMake(0, 30, w, lineView_h);
    self.lineView.frame = CGRectMake(0, textField_h - lineView_h, w, lineView_h);
    
    CGFloat tipsImgView_w = 30;
    CGFloat tipsImgView_h = self.textField.frame.size.height;
//    CGFloat tipsImgView_x = w - tipsImgView_w;
    CGFloat tipsImgView_x = w - 85*WIDTHRation;
    CGFloat tipsImgView_y = self.textField.frame.origin.y;
    self.tipsImgView.frame = CGRectMake(tipsImgView_x, tipsImgView_y, tipsImgView_w, tipsImgView_h);
    
    if (_type == InputViewType_pwd) {
        
        CGFloat lookButton_w = 30;
        CGFloat lookButton_x = w - lookButton_w;
        CGFloat lookButton_y = self.textField.frame.origin.y;
        CGFloat lookButton_h = self.textField.frame.size.height;
        
        CGFloat textField_w = w - lookButton_w;
        
        self.textField.frame = CGRectMake(0, 0, textField_w, textField_h);
        self.lookButton.frame = CGRectMake(lookButton_x, lookButton_y, lookButton_w, lookButton_h);
        self.tipsLabel.frame = CGRectMake(0, textField_h + lineView_h, w-25, tipsLabel_h);
    } else {
        CGFloat tipsLabelW = [self.tipsLabel.text sizeWithAttributes:@{NSFontAttributeName : self.tipsLabel.font}].width;
        if (tipsLabelW > w) {
            tipsLabel_h = tipsLabel_h * 2;
        }
        self.tipsLabel.frame = CGRectMake(0, textField_h + lineView_h, w, tipsLabel_h);
    }
    
    if (_type == InputViewType_country) {
        CGFloat countryCodeLabel_w = 70;
        CGFloat gap = 14;
        CGFloat textField_w = w - countryCodeLabel_w - gap;
        CGFloat textField_x = countryCodeLabel_w + gap;
        if (kScreenHeight <= iPhone5_HEIGHT) {
            textField_x -= 40;
            textField_w += 40;
            countryCodeLabel_w = 75;
        }
        self.countryCodeButton.frame = CGRectMake(5, 0, countryCodeLabel_w, textField_h);
        self.countryCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.countryCodeButton.frame), 0, textField_w, textField_h);
        self.tipsImgView.frame = CGRectMake(tipsImgView_x, tipsImgView_y, w, tipsImgView_h);
    }
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

- (void)setTips:(NSString *)tips
{
    _tips = tips;
    self.tipsLabel.text = tips;
}

- (void)setTipsFont:(UIFont *)tipsFont
{
    _tipsFont = tipsFont;
    self.tipsLabel.font = tipsFont;
}

- (void)setTipsColor:(UIColor *)tipsColor
{
    _tipsColor = tipsColor;
    self.tipsLabel.textColor = tipsColor;
}

- (void)setTipsHidden:(BOOL)tipsHidden
{
    _tipsHidden = tipsHidden;
    self.tipsLabel.hidden = tipsHidden;
}

- (void)setTipsImage:(NSString *)tipsImage
{
    _tipsImage = tipsImage;
    self.tipsImgView.image = [UIImage imageNamed:tipsImage];
}

- (void)setTipsImageHidden:(BOOL)tipsImageHidden
{
    _tipsImageHidden = tipsImageHidden;
    self.tipsImgView.hidden = tipsImageHidden;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setType:(InputViewType)type
{
    _type = type;
    
    switch (type) {
        case InputViewType_pwd:
            self.lookButton.hidden = NO;
            self.textField.secureTextEntry = YES;
            self.countryCodeButton.hidden = YES;
//            self.countryButAccImg.hidden = YES;
            self.lineView.backgroundColor = [UIColor whiteColor];
            break;
            
        case InputViewType_country:
            self.countryCodeButton.hidden = NO;
//            self.countryButAccImg.hidden = NO;
            self.textField.textColor = HBColor(31, 63, 89);
            self.textField.font = [UIFont systemFontOfSize:22];
            self.lineView.backgroundColor = HBColor_alpha(31, 63, 89, 0.15);
            self.tipsLabel.textAlignment = NSTextAlignmentCenter;
            self.tipsImgView.hidden = YES;
            break;
            
        default:
            self.lookButton.hidden = YES;
//            self.countryButAccImg.hidden = YES;
            self.countryCodeButton.hidden = YES;
            self.lineView.backgroundColor = [UIColor whiteColor];
            break;
    }
}

- (void)setText:(NSString *)text
{
    self.textField.text = text;
}

- (NSString *)text
{
    return self.textField.text;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textField.textColor = textColor;
}

- (void)setTips:(NSString *)tips
      tipsColor:(UIColor *)tipsColor
{
    _tipsLabel.text = tips;
    _tipsLabel.textColor = tipsColor;
}

- (void)setPlaceholder:(NSString *)placeholder
      placeholderColor:(UIColor *)placeholderColor
              fontSize:(CGFloat)fontSize
{
    _placeholder = placeholder;
    [_textField setPlaceholder:placeholder
              placeholderColor:placeholderColor
                      fontSize:fontSize];
}

- (void)setLineNormalColor:(UIColor *)normalColor
                 highColor:(UIColor *)highColor
{
    _lineNormalColor = normalColor;
    _lineHighColor = highColor;
    
    _lineView.backgroundColor = normalColor;
}

- (void)setCountryCode:(NSString *)countryCode
{
    _countryCode = countryCode;
    [self.countryCodeButton setTitle:countryCode
                            forState:UIControlStateNormal];
    self.countryCodeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.countryCodeButton.titleLabel.backgroundColor = self.countryCodeButton.backgroundColor;
    self.countryCodeButton.imageView.backgroundColor = self.countryCodeButton.backgroundColor;
    CGFloat interval = 2.0;
//    CGSize titleSize = _countryCodeButton.titleLabel.bounds.size;
    
    CGFloat imageSizeWidth = _countryCodeButton.imageView.bounds.size.width == 0 ? 7 : _countryCodeButton.imageView.bounds.size.width;
    self.countryCodeButton.imageEdgeInsets = UIEdgeInsetsMake(0, [_countryCodeButton.titleLabel textWidthWithHeight:16]+interval, 0, -([_countryCodeButton.titleLabel textWidthWithHeight:16]+interval));
    self.countryCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSizeWidth+interval), 0, imageSizeWidth+interval );
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _textField.keyboardType = keyboardType;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textField.font = textFont;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    self.textField.secureTextEntry = NO;
    _lookButton.selected = YES;
}

- (void)setLookNormalImage:(NSString *)lookNormalImage
{
    _lookNormalImage = lookNormalImage;
    UIImage *image = [[UIImage imageNamed:lookNormalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_lookButton setImage:image forState:UIControlStateNormal];
}

- (void)setLookSelectImage:(NSString *)lookSelectImage
{
    _lookSelectImage = lookSelectImage;
    UIImage *image = [[UIImage imageNamed:lookSelectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_lookButton setImage:image forState:UIControlStateSelected];
}

- (void)setBecomeFirstResponder:(BOOL)becomeFirstResponder
{
    if (becomeFirstResponder) {
        [self.textField becomeFirstResponder];
    } else {
        [self.textField canResignFirstResponder];
    }
}
- (void)setBecomeResignFirstResponder:(BOOL)becomeResignFirstResponder
{
    if (becomeResignFirstResponder) {
        [self.textField resignFirstResponder];
    } else {
        [self.textField canBecomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldEditChanged:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(inputView:textFieldEditChangedAtText:)]) {
        [self.delegate inputView:self textFieldEditChangedAtText:textField.text];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(inputView:textFieldShouldBeginEditAtText:)]) {
        [self.delegate inputView:self textFieldShouldBeginEditAtText:textField.text];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.backgroundColor = _lineHighColor;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [[UIColor redColor] CGColor];
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(inputView:textFieldShouldEndEditAtText:)]) {
        [self.delegate inputView:self textFieldShouldEndEditAtText:textField.text];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.backgroundColor = _lineNormalColor;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [[UIColor clearColor] CGColor];
    }];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(inputView:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate inputView:self shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(inputViewShouldReturn:)]) {
        return [self.delegate inputViewShouldReturn:self];
    } else {
        return YES;
    }
}

@end
