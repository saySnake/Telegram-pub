//
//  DCPaymentView.m
//  DCPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import "DCPaymentView.h"
#import "DCPwdTextField.h"

#define TITLE_HEIGHT 46
#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width-80
#define PWD_COUNT 6
#define DOT_WIDTH 10
#define KEYBOARD_HEIGHT 216
#define KEY_VIEW_DISTANCE 100
#define ALERT_HEIGHT 240
#define margin 15

@interface DCPaymentView ()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}

@property (nonatomic ,weak) UIView *mask;

@property (nonatomic, strong) UIView *paymentAlert, *inputView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *amountLabel;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *payBtn;
@end

@implementation DCPaymentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        
        [self drawView];
    }
    return self;
}

- (void)drawView {
    if (!_paymentAlert) {
        _paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height-KEYBOARD_HEIGHT-KEY_VIEW_DISTANCE-ALERT_HEIGHT, [UIScreen mainScreen].bounds.size.width-80, ALERT_HEIGHT)];
        _paymentAlert.layer.cornerRadius = 5.f;
        _paymentAlert.layer.masksToBounds = YES;
        _paymentAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
        [self addSubview:_paymentAlert];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, PAYMENT_WIDTH, TITLE_HEIGHT)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_paymentAlert addSubview:_titleLabel];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(0, 0, TITLE_HEIGHT, TITLE_HEIGHT)];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:_closeBtn];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, TITLE_HEIGHT, PAYMENT_WIDTH, .5f)];
        _line.backgroundColor = [UIColor lightGrayColor];
        [_paymentAlert addSubview:_line];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, TITLE_HEIGHT+15, PAYMENT_WIDTH-30, 20)];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        [_paymentAlert addSubview:_detailLabel];
        
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, TITLE_HEIGHT*2+0.5*margin, PAYMENT_WIDTH-30, 25)];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.textColor = [UIColor darkGrayColor];
        _amountLabel.font = [UIFont systemFontOfSize:33];
        [_paymentAlert addSubview:_amountLabel];
        
        //lineView
        _lineView =[[UIView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(_amountLabel.frame)+1.5*margin, PAYMENT_WIDTH-2*margin, .5f)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [_paymentAlert addSubview:_lineView];
        

        
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(15, _paymentAlert.frame.size.height-(PAYMENT_WIDTH-30)/6-margin-5, PAYMENT_WIDTH-30, (PAYMENT_WIDTH-30)/6)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.borderWidth = 1.f;
        _inputView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
        _inputView.hidden =YES;
        [_paymentAlert addSubview:_inputView];
        
        
        //payBtn
        _payBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame =CGRectMake(15, _paymentAlert.frame.size.height-(PAYMENT_WIDTH-30)/6-margin, PAYMENT_WIDTH-30, (PAYMENT_WIDTH-30)/6);
        [_payBtn setBackgroundColor:RGBACOLOR(40.0f, 168.0f, 240.0f, 1)];
        [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.layer.masksToBounds =YES;
        _payBtn.layer.cornerRadius =1;
        [_paymentAlert addSubview:_payBtn];

        pwdIndicatorArr = [[NSMutableArray alloc]init];
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pwdTextField.hidden = YES;
        _pwdTextField.delegate = self;
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_inputView addSubview:_pwdTextField];
        
        CGFloat width = _inputView.bounds.size.width/PWD_COUNT;
        for (int i = 0; i < PWD_COUNT; i ++) {
            UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-DOT_WIDTH)/2.f + i*width, (_inputView.bounds.size.height-DOT_WIDTH)/2.f, DOT_WIDTH, DOT_WIDTH)];
            dot.backgroundColor = [UIColor blackColor];
            dot.layer.cornerRadius = DOT_WIDTH/2.;
            dot.clipsToBounds = YES;
            dot.hidden = YES;
            [_inputView addSubview:dot];
            [pwdIndicatorArr addObject:dot];
            
            if (i == PWD_COUNT-1) {
                continue;
            }
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, _inputView.bounds.size.height)];
            line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
            [_inputView addSubview:line];
        }
    }
}


- (void)pay:(UIButton *)sender
{
    [self disMisBtn];
}

- (void)disMisBtn
{
    _payBtn.transform=CGAffineTransformMakeScale(1,1);
    _inputView.transform=CGAffineTransformMakeScale(0.6,0.6);

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_pwdTextField becomeFirstResponder];
                         _payBtn.transform=CGAffineTransformMakeScale(0.6, 0.6);
                         _payBtn.alpha=0;
                         
                         _inputView.transform =CGAffineTransformMakeScale(1, 1);
                         _inputView.alpha =1;
                         _inputView.hidden =NO;
                     }
                     completion:^(BOOL finished){

                     }];
}

- (void)show:(UIViewController *)viewController {
    UIView *m=[[UIView alloc]initWithFrame:viewController.view.frame];
    [viewController.view addSubview:m];
    m.backgroundColor=[UIColor blackColor];
    m.alpha=0;
    self.mask=m;
    [viewController.view addSubview:self];
    _paymentAlert.transform = CGAffineTransformMakeScale(0.5, 0.5);
    _paymentAlert.alpha = 0;
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _paymentAlert.transform=CGAffineTransformMakeScale(1, 1);
                         _paymentAlert.alpha=1;
                         m.alpha=0.37;
                     }
                     completion:^(BOOL finished){
//                         [_pwdTextField becomeFirstResponder];
                         _paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         _paymentAlert.alpha = 1.0;
                     }];
}


- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    _paymentAlert.alpha = 0;

    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_pwdTextField becomeFirstResponder];
        _paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _paymentAlert.alpha = 1.0;
    } completion:nil];
}

//- (void)dismiss {
//    [_pwdTextField resignFirstResponder];
//    [UIView animateWithDuration:0.3f animations:^{
//        _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
//        _paymentAlert.alpha = 0;
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//            [self removeFromSuperview];
//    }];
//}

- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_pwdTextField resignFirstResponder];
                         _paymentAlert.transform=CGAffineTransformMakeScale(0.6, 0.6);
                         _paymentAlert.alpha=0;
                         self.mask.alpha=0;
                         [self removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [[NSNotificationCenter defaultCenter] removeObserver:self];
                     }];

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= PWD_COUNT && string.length) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    NSString *totalString;
    if (string.length <= 0) {
        totalString = [textField.text substringToIndex:textField.text.length-1];
    }
    else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    [self setDotWithCount:totalString.length];
    
    NSLog(@"_____total %@",totalString);
    if (totalString.length == 6) {
        if (_completeHandle) {
            _completeHandle(totalString);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:.3f];
    NSLog(@"complete");
    }
    
    return YES;
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in pwdIndicatorArr) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}

#pragma mark - 
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = _title;
    }
}

- (void)setDetail:(NSString *)detail {
    if (_detail != detail) {
        _detail = detail;
        _detailLabel.text = _detail;
    }
}

- (void)setAmount:(NSString *)amount {
    if (_amount != amount) {
        _amount = amount;
        _amountLabel.text = _amount;
    }
}

@end
