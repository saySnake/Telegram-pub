//
//  HTCodeTextView.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/5/3.
//

#import "HTCodeTextView.h"

@interface HTCodeTextView ()<UITextFieldDelegate>

@end


@implementation HTCodeTextView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self);
        }];
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
            make.height.mas_equalTo(15*HeightRation);
            make.width.greaterThanOrEqualTo(@(41*WIDTHRation));
        }];
    }
    return self;
}

-(void)setType:(HTCodeTextType)type{
    _type = type;
    switch (type) {
        case PhoneType:{
            [self addSubview:self.sendBut];
            [self.sendBut mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-10);
                make.height.mas_equalTo(15*HeightRation);
            }];
        }
            break;
        case GoogleType:{
            
        }
            
            break;
        case ImageType:{
            [self addSubview:self.imgView];
            [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).offset(-10);
                make.height.mas_equalTo(31*HeightRation);
                make.width.mas_equalTo(76.5*WIDTHRation);
            }];
        }
            break;
        default:
            break;
    }
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor blackColor];
        _textField.tintColor = HBColor(178, 178, 178);
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
//        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];;
        if (@available(iOS 11.0, *)) {
            // avoid autocomplete password
            self.textField.textContentType = @"";
        }
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor redColor];
//        [_textField addTarget:self
//                       action:@selector(textFieldEditChanged:)
//             forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HBColor_alpha(242, 242, 242, 1);
        UITapGestureRecognizer *ImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeFirstResponder:)];
        [_backView addGestureRecognizer:ImageGesture];
    }
    return _backView;
}
-(void)becomeFirstResponder:(UITapGestureRecognizer *)tap{
    [_textField becomeFirstResponder];
}
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.userInteractionEnabled = YES;
        _imgView.image = [UIImage imageNamed:@"h1"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *ImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regetImageGesture:)];
        [_imgView addGestureRecognizer:ImageGesture];
    }
}
-(void)regetImageGesture:(UITapGestureRecognizer *)tap{
//    if ([self.delegate respondsToSelector:@selector(codeAuthViewRegetImge)]) {
//        [self.delegate codeAuthViewRegetImge];
//    }
}
-(UIButton *)sendBut{
    if (!_sendBut) {
        _sendBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_sendBut setImage:[UIImage imageNamed:@"Choose_attribution"] forState:UIControlStateNormal];
//        [_sendBut setImage:[UIImage imageNamed:@"Choose_attribution"] forState:UIControlStateHighlighted];
        [_sendBut setTitleColor:HBColor(197, 203, 213) forState:UIControlStateNormal];
        [_sendBut setTitle:@"60秒后重新获取"
                    forState:UIControlStateNormal];
        _sendBut.contentVerticalAlignment = NSTextAlignmentRight;
        _sendBut.backgroundColor = [UIColor redColor];
        _sendBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendBut setTitleColor:HBColor(78, 78, 78)
                                 forState:UIControlStateNormal];
        [_sendBut addTarget:self
                               action:@selector(ResetCode:)
                     forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendBut;
}
- (void)ResetCode:(UIButton *)button
{
//    if ([self.delegate respondsToSelector:@selector(inputView:countryCodeButtonClicked:)]) {
//        [self.delegate inputView:self countryCodeButtonClicked:button];
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
