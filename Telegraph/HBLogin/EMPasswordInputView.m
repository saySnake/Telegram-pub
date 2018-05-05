//
//  EMPasswordInputView.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/24.
//

#import "EMPasswordInputView.h"

#define PERFECT_LINE_WIDTH 17.0f
#define PERFECT_LINE_INTERVAL 7.0f
#define lineHighLightColor HBColor(40, 168, 240)
#define lineNormalColor HBColor(244, 244, 244)
#define verLineHighLightColor HBColor(40, 168, 240)
#define verLineNormalColor [UIColor clearColor]

@interface EMPasswordInputView()<UITextFieldDelegate> {
    
    NSUInteger _numberOfCount;
    
    //    UIColor *_normalLineColor;
    //    UIColor *_highLightLineColor;
    //
    //    UIColor *_verNormalLineColor;
    //    UIColor *_verHighLightLineColor;
    
    NSMutableArray *_lineArrayM;
    NSMutableArray *_verLineArr;
    
    NSString *_contentStr;
    
    UITextField *_mainTextField;
    
    NSMutableArray *_textFieldArrM;
    
    
}
@property (nonatomic, copy) NSDictionary *defaultTextFiledAttributes;

@end

@implementation EMPasswordInputView

+ (instancetype)inputViewWithFrame:(CGRect)frame numberOfCount:(NSUInteger)count widthOfLine:(CGFloat)width intervalOfLine:(CGFloat)interval {
    return [[self alloc] initWithFrame:frame numberOfCount:count widthOfLine:width intervalOfLine:interval];
}

- (instancetype)initWithFrame:(CGRect)frame numberOfCount:(NSUInteger)count widthOfLine:(CGFloat)width intervalOfLine:(CGFloat)interval {
    if (self = [super init]) {
        if (count < 1) {
            
        } else {
            if (frame.size.width < (count * PERFECT_LINE_WIDTH + (count - 1) * PERFECT_LINE_INTERVAL)) {
                NSAssert((count * PERFECT_LINE_WIDTH + (count - 1) * PERFECT_LINE_INTERVAL) <= [[UIScreen mainScreen] bounds].size.width, @"***** EMPasswordInputViewError ***** : 我们已经帮你把横线的宽度和间距调整至最小，但你的屏幕宽度显示不下这么多横线了，减少横线数量试试");
                NSLog(@"***** EMPasswordInputError ***** 设置的宽度已小于最小值，已自动调整合适布局");
                self.frame = CGRectMake(frame.origin.x, frame.origin.y, (count * PERFECT_LINE_WIDTH + (count - 1) * PERFECT_LINE_INTERVAL), frame.size.height);
            } else {
                self.frame = frame;
            }
            self.userInteractionEnabled = YES;
            //整个view 添加手势,让保存textfiled成为第一响应
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] init];
            [ges addTarget:self action:@selector(inputViewClicked)];
            [self addGestureRecognizer:ges];
            _widthOfLine = width;
            _intervalOfLine = interval;
            _numberOfCount = count;
            
            //[UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0]
            //[UIColor colorWithRed:61/255.0 green:216/255.0 blue:76/255.0 alpha:1.0]
            
            //            _normalLineColor = [UIColor blackColor];
            //            _highLightLineColor = [UIColor redColor];
            //
            //            _verNormalLineColor = [UIColor clearColor];
            //            _verHighLightLineColor = [UIColor redColor];
            
            _lineArrayM = [[NSMutableArray alloc] init];
            _verLineArr = [[NSMutableArray alloc]init];
            _textFieldArrM = [[NSMutableArray alloc] init];
            _lineHeight = 2;
            [self initialUI];
        }
    }
    return self;
}

- (void)initialUI {
    [self layoutIfNeeded];
    [self checkFrameSettings];//检查布局
    //起始位给定的宽度-文本所需要的宽度  再/2 即为x坐标
    CGFloat startX = (self.frame.size.width - (_widthOfLine * _numberOfCount + _intervalOfLine * (_numberOfCount - 1))) / 2;
    if (_lineArrayM.count == 0) {
        for (int i = 0; i < (int)_numberOfCount; i ++) {
            //下面的横线
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(startX + i * (_widthOfLine + _intervalOfLine), self.frame.size.height - _lineHeight, _widthOfLine, _lineHeight);
            [self addSubview:lineView];
            [_lineArrayM addObject:lineView];
            //6个text
            UITextField *tf = [[UITextField alloc] init];
            //tf 加到lineview上, 但是坐标为 负
//            tf.frame = CGRectMake(0,  - (self.frame.size.height - lineView.frame.size.height), lineView.frame.size.width, self.frame.size.height - lineView.frame.size.height);
            tf.frame = CGRectMake((lineView.width - 18*WIDTHRation)/2 ,  - (10 + 30)*HeightRation , 18*WIDTHRation, 30*HeightRation);
//            tf.centerX = lineView.centerX;
            tf.defaultTextAttributes = [self.defaultTextFiledAttributes copy];
            tf.textAlignment = NSTextAlignmentCenter;
            tf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            tf.userInteractionEnabled = NO;
            tf.enabled = NO;
            tf.clipsToBounds = YES;
//            tf.tintColor = [UIColor blueColor];
            [lineView addSubview:tf];
            [_textFieldArrM addObject:tf];
            
            UIView *verLineView = [[UIView alloc]init];
            //- (self.frame.size.height - lineView.frame.size.height)+10
//            verLineView.frame = CGRectMake((_widthOfLine - 4.5*WIDTHRation) /2,  - (self.frame.size.height - lineView.frame.size.height)+10, 4.5*WIDTHRation, 31*HeightRation);
            verLineView.frame = CGRectMake((_widthOfLine - 4.5*WIDTHRation) /2,  - (10 + 30)*HeightRation, 4.5*WIDTHRation, 30*HeightRation);
//            verLineView.centerY =  - (self.frame.size.height - lineView.frame.size.height)/2;
            verLineView.backgroundColor = verLineNormalColor;
            [lineView addSubview:verLineView];
            [_verLineArr addObject:verLineView];
            
        }
        //主的text 暂时设置00
        _mainTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _mainTextField.hidden = YES;
        _mainTextField.delegate = self;
        _mainTextField.keyboardType = UIKeyboardTypeDefault;
        _mainTextField.tintColor = [UIColor redColor];
        [_mainTextField becomeFirstResponder];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inputViewStrChanged:) name:UITextFieldTextDidChangeNotification object:_mainTextField];
        [self addSubview:_mainTextField];
        [_mainTextField becomeFirstResponder];
        
        [self inputViewColorWithNormalColor:lineNormalColor highLightColor:lineHighLightColor];
    }
}
//给view增加闪烁效果
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}

- (void)checkFrameSettings {
    CGFloat totalLength = _numberOfCount * _widthOfLine + (_numberOfCount - 1) * _intervalOfLine;
    if (totalLength > self.frame.size.width) {//线*个数+间隔*(个数-1)
        NSLog(@"***** EMPasswordInputError ***** 已自动调整至合适布局");
        if (((_numberOfCount - 1) * _intervalOfLine + _widthOfLine * _numberOfCount) > self.frame.size.width) {
            /** 使用用户设置间距并且使用最小线长度仍大于总宽度*/
            _widthOfLine = (self.frame.size.width - ((_numberOfCount - 1) * _intervalOfLine)) / _numberOfCount;
            if (_widthOfLine < PERFECT_LINE_WIDTH) {
                /** 自动调整宽度已小于最小宽度*/
                _widthOfLine = PERFECT_LINE_WIDTH;
                _intervalOfLine = (self.frame.size.width - _numberOfCount * _widthOfLine) / (_numberOfCount - 1);
                if (_intervalOfLine < PERFECT_LINE_INTERVAL) {
                    _intervalOfLine = PERFECT_LINE_INTERVAL;
                    CGRect rect = self.frame;
                    rect.size.width = PERFECT_LINE_INTERVAL * (_numberOfCount - 1) + PERFECT_LINE_WIDTH * _numberOfCount;
                    self.frame = rect;
                }
            }
        }
    }
}

//- (void)setHighLightColor:(UIColor *)highLightColor {
////    _highLightLineColor = highLightColor;
//    [self inputViewColorWithNormalColor:lineNormalColor highLightColor:lineHighLightColor];
//}

//- (void)setNormalColor:(UIColor *)normalColor {
////    _normalLineColor = normalColor;
//    [self inputViewColorWithNormalColor:lineNormalColor highLightColor:lineHighLightColor];
//}

- (void)inputViewColorWithNormalColor:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor {
    //_lineArrayM.count
    for (int i = 0; i < (int)_lineArrayM.count; i ++) {
        UIView *view = [_lineArrayM objectAtIndex:i];
//        if ((int)_contentStr.length <= i) {
//            view.backgroundColor = lineNormalColor;
//        } else {
//            view.backgroundColor = lineHighLightColor;
//        }
        if ((int)_contentStr.length == 0 && i == 0) {
            view.backgroundColor = lineHighLightColor;
        } else {
            view.backgroundColor = lineNormalColor;
        }
    }
    
    for (int j = 0; j < (int)_verLineArr.count; j++) {
        UIView *view = [_verLineArr objectAtIndex:j];
        if ((int)_contentStr.length == 0 && j == 0) {
            view.backgroundColor = verLineHighLightColor;
             [view.layer addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
        }else{
            view.backgroundColor = verLineNormalColor;
        }
    }
}
-(void)inputViewColorWithNormalColor:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor WithStrLength:(NSUInteger)strlength{
    for (int i = 0; i < (int)_lineArrayM.count; i ++) {
        UIView *view = [_lineArrayM objectAtIndex:i];
        //        if (_contentStr.length <= i) {
        //            view.backgroundColor = normalColor;
        //        } else {
        //            view.backgroundColor = highLightColor;
        //        }
        if ((int)strlength == i) {//highLightColor
            view.backgroundColor = lineHighLightColor;
        }else{//normalColor
            view.backgroundColor = lineNormalColor;
        }
    }
    
    for (int j = 0; j < (int)_verLineArr.count; j++) {
        UIView *view = [_verLineArr objectAtIndex:j];
        if ((int)strlength == j) {
            view.backgroundColor = verLineHighLightColor;
             [view.layer addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
        }else{
            view.backgroundColor = verLineNormalColor;
        }
    }
    
}
//点击响应
- (void)inputViewClicked {
    
    if (!_mainTextField.isFirstResponder) {
        [_mainTextField becomeFirstResponder];
    }
}

- (void)inputViewStrChanged :(NSNotification *)noti {
    _mainTextField = noti.object;
    NSString *str = _mainTextField.text;
    //限制文本大小
    if (str.length > _numberOfCount) {
        _mainTextField.text = [str substringToIndex:_numberOfCount];
    }
    for (int i = 0; i < (int)_numberOfCount; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        //
        if (i < (int)_mainTextField.text.length) {
            if (_passwordType == EMPasswordTypeX) {
                tf.text = @"X";
            } else if (_passwordType == EMPasswordTypeDots) {
                tf.text = @"·";
            } else if (_passwordType == EMPasswordTypeStar) {
                tf.text = @"*";
            }else if (_passwordType == EMPasswordTypeCircle) {
                tf.text = @"○";
            } else if (_passwordType == EMPasswordTypeCustom) {
                tf.text = _customPasswordStr.length > 0?_customPasswordStr:@"C";
            } else if (_passwordType == EMPasswordTypeDefault) {
                //截取字符串  tf赋值
                tf.text = [_mainTextField.text substringWithRange:NSMakeRange(i, 1)];
            } else {
                tf.text = [_mainTextField.text substringWithRange:NSMakeRange(i, 1)];
            }
            
        } else {
            tf.text = @"";
        }
    }
    _contentStr = _mainTextField.text;
    if (_contentStr.length >= _numberOfCount) {
        //当输入长度大于总个数 响应finish 的delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(EM_passwordInputView:finishInput:)]) {
            [self.delegate EM_passwordInputView:self finishInput:_contentStr];
        }
    }
    //响应正在输入的状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(EM_passwordInputView:edittingPassword:inputStr:)]) {
        [self.delegate EM_passwordInputView:self edittingPassword:_contentStr inputStr:_contentStr.length>0?[_contentStr substringFromIndex:_contentStr.length - 1]:@""];
    }
    //    [self inputViewColorWithNormalColor:_normalLineColor highLightColor:_highLightLineColor];
    [self inputViewColorWithNormalColor:lineNormalColor highLightColor:lineHighLightColor WithStrLength:str.length];
}
//设置字体样式
- (void)setContentAttributes:(NSDictionary *)contentAttributes {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.defaultTextFiledAttributes];
    if (!contentAttributes) {
        contentAttributes = [self.defaultTextFiledAttributes copy];
    } else {
        
        [dictM addEntriesFromDictionary:[contentAttributes copy]];
        contentAttributes = [dictM copy];
    }
    _contentAttributes = contentAttributes;
    for (int i = 0; i < (int)_textFieldArrM.count; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        
        tf.defaultTextAttributes = contentAttributes;
    }
}
//默认样式
- (NSDictionary *)defaultTextFiledAttributes {
    if (!_defaultTextFiledAttributes) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        style.alignment = NSTextAlignmentCenter;
        
        _defaultTextFiledAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:9.0f], NSParagraphStyleAttributeName : style};
    }
    return _defaultTextFiledAttributes;
}

- (void)setContentColor:(UIColor *)contentColor {
    _contentColor = contentColor;
    for (int i = 0; i < (int)_textFieldArrM.count; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        tf.textColor = contentColor;
    }
}

- (void)setContentFontSize:(CGFloat)contentFontSize {
    _contentFontSize = contentFontSize;
    for (int i = 0; i < (int)_textFieldArrM.count; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        tf.font = [UIFont systemFontOfSize:contentFontSize];
    }
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    if (_lineHeight>= self.frame.size.height) {
        NSLog(@"***** EMPasswordInputError ***** 横线高度超过控件自身高度，已自动调整至最大高度");
        _lineHeight = self.frame.size.height - 1;
    }
    for (int i = 0; i < (int)_numberOfCount; i ++) {
        UIView *lineView = [_lineArrayM objectAtIndex:i];
        CGRect lineRect = lineView.frame;
        lineRect.origin.y = self.frame.size.height - _lineHeight;
        lineRect.size.height = _lineHeight;
        lineView.frame = lineRect;
        
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        tf.frame = CGRectMake(0,  - (self.frame.size.height - lineView.frame.size.height), lineView.frame.size.width, self.frame.size.height - lineView.frame.size.height);
    }
}

- (void)setWordsLineOffset:(CGFloat)wordsLineOffset {
    _wordsLineOffset = wordsLineOffset;
    for (int i = 0; i < (int)_numberOfCount; i ++) {
        UITextField *tf = [_textFieldArrM objectAtIndex:i];
        CGRect tfRect = tf.frame;
        tfRect.origin.y += _wordsLineOffset;
        tfRect.size.height += _wordsLineOffset > 0 ? 0 : -_wordsLineOffset;
        tf.frame = tfRect;
    }
}

- (void)setPasswordKeyboardType:(UIKeyboardType)passwordKeyboardType {
    _passwordKeyboardType = passwordKeyboardType;
    _mainTextField.keyboardType = _passwordKeyboardType;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
