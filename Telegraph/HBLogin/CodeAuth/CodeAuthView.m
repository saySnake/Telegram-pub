//
//  CodeAuthView.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/23.
//

#import "CodeAuthView.h"
#define bottonViewHeight (151.5*HeightRation + 88.4*HeightRation)
#define boottonImgViewHeight (160*HeightRation + 63*HeightRation)
#define KCheckTime 60

@interface CodeAuthView ()<UITextFieldDelegate>
@property (nonatomic ,strong) UIView *topView;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UILabel *tipLab;
@property (nonatomic ,strong) UIButton *cancelBut;

@property (nonatomic ,strong)UITextField *codeField;
@property (nonatomic ,strong) UIButton *resendBut;
@property (nonatomic ,strong) UIButton *sureBut;//确认
@property (nonatomic ,copy) NSString *phoneStr;//传进来的手机号
@property (nonatomic ,assign) BOOL isGoogle;
@property (nonatomic ,assign) BOOL isImage;
@property (nonatomic ,assign) CGFloat bottomHeight;

@property (nonatomic ,strong)UITextField *imgCodeText;//图像验证的text
@property (nonatomic ,strong) UIImageView *codeImage;//codeimage


@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, strong) NSDate  *date;

@end


@implementation CodeAuthView
//-(instancetype)initWithFrame:(CGRect)frame WithPhoneShow:(BOOL)phoneShow WithGoogleShow:(BOOL)googleShow WithGoogleShow:(BOOL)ImageShow{
-(instancetype)initWithFrame:(CGRect)frame WithIsImage:(BOOL )isImage{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _isImage = isImage;
        _bottomHeight = (_isImage ? boottonImgViewHeight: bottonViewHeight);
        self.hidden = YES;
        [self listeningKeyboard];
        [self createSubviews];
    }
    
    return self;
}
-(void)setPhoneAndGoogleWithISgoogle:(BOOL)IsGoogle WithPhoneString:(NSString *)phoneString WithImage:(UIImage *)image{
    if (_isImage) {
        _codeImage.image = image;
    }else{
        _phoneStr = phoneString;
        _isGoogle = IsGoogle;
        if (IsGoogle) {
            _phoneLab.text = @"GA验证码";
            _codeField.placeholder = @"GA验证码";
            _resendBut.hidden = YES;
        }else{
            [self beginTimer];//进到界面就开启定时器
            _phoneLab.text =  [_phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4)  withString:@"****"];
        }
    }
}
-(void)createSubviews{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - _bottomHeight  - iphoneXBottomHeight)];
    _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self addSubview:_topView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [_topView addGestureRecognizer:tapGesture];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - _bottomHeight - iphoneXBottomHeight  , kScreenWidth, _bottomHeight  + iphoneXBottomHeight)];
    _bottomView.backgroundColor = HBColor_alpha(255, 255, 255, .95);
    [self addSubview:_bottomView];
    
    _tipLab = [createLbaelButView createLabelFrame:CGRectMake(15*WIDTHRation, 30*HeightRation, 64*WIDTHRation, 16 *HeightRation) font:16 text:@"安全验证" textColor:HBColor(78, 78, 78)];
    _tipLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    _tipLab.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:_tipLab];
    
    
    _cancelBut = [createLbaelButView createButtonFrame:CGRectMake(332*WIDTHRation, 31*HeightRation, 28*WIDTHRation, 14*HeightRation) backImageName:nil title:@"取消" titleColor:HBColor(78, 78, 78) font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] backColor:[UIColor clearColor]];
    [_cancelBut addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    _cancelBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_bottomView addSubview:_cancelBut];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63*HeightRation, kScreenWidth, 1)];
    lineView.backgroundColor = HBColor(231, 235, 238);
    [_bottomView addSubview:lineView];
    if (_isImage) {//图片验证
        _imgCodeText = [createLbaelButView createTextFielfFrame:CGRectMake(_tipLab.left, lineView.bottom+ 40.5*HeightRation, 112*WIDTHRation, 16*HeightRation) font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] placeholder:@"输入图形验证码"];
        _imgCodeText.textAlignment = NSTextAlignmentLeft;
        _imgCodeText.keyboardType = UIKeyboardTypeNumberPad;
        _imgCodeText.delegate = self;
        [_bottomView addSubview:_imgCodeText];
        
        _codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(283.5*WIDTHRation, lineView.bottom +30*HeightRation, 76.5*WIDTHRation, 31*HeightRation)];
        _codeImage.image = [UIImage imageNamed:@"h1"];
        [_bottomView addSubview:_codeImage];
        _codeImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *ImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regetImageGesture:)];
        [_codeImage addGestureRecognizer:ImageGesture];
        
        UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(_imgCodeText.left, _imgCodeText.bottom + 14.5*HeightRation, kScreenWidth - _imgCodeText.left, 1)];
        bottomline.backgroundColor = HBColor(231, 235, 238);
        [_bottomView addSubview:bottomline];
        
        _sureBut = [createLbaelButView createButtonFrame:CGRectMake(_tipLab.left, bottomline.bottom + 30*HeightRation, kScreenWidth - _tipLab.left*2, 44*HeightRation) backImageName:nil title:@"确认" titleColor:HBColor(255, 255, 255) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:14] backColor:HBColor(40, 168, 240)];
        [_sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_sureBut];
        
    }else{//手机和google验证码
        
        _phoneLab = [createLbaelButView createLabelFrame:CGRectMake(_tipLab.left, 93.5*HeightRation, 75*WIDTHRation, 12*HeightRation) font:12 text:@"176****3768" textColor:HBColor(78, 78, 78)];
        _phoneLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _phoneLab.textAlignment = NSTextAlignmentLeft;
        [_bottomView addSubview:_phoneLab];
        
        _codeField = [createLbaelButView createTextFielfFrame:CGRectMake(_tipLab.left, 125.5*HeightRation, 80*WIDTHRation, 16*HeightRation) font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] placeholder:@"短信验证码"];
        _codeField.textAlignment = NSTextAlignmentLeft;
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.delegate = self;
        [_bottomView addSubview:_codeField];
        //CGRectMake(246*WIDTHRation, 125.5 *HeightRation, 114*WIDTHRation, 16*HeightRation)
        _resendBut = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:@"发送" titleColor:HBColor(40, 168, 240) font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16] backColor:[UIColor clearColor]];
        //    [_resendBut sizeToFit];
        _resendBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_resendBut addTarget:self action:@selector(resendCode) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_resendBut];
        [_resendBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView.mas_top).offset(125.5 *HeightRation);
            make.right.mas_equalTo(-15*WIDTHRation);
//            make.width.mas_equalTo(315*WIDTHRation);
//            make.height.mas_equalTo(55*HeightRation);
        }];
        
        
        UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(_tipLab.left, 151.5*HeightRation, kScreenWidth - _tipLab.left, 1)];
        bottomline.backgroundColor = HBColor(231, 235, 238);
        [_bottomView addSubview:bottomline];
        
        _sureBut = [createLbaelButView createButtonFrame:CGRectMake(_tipLab.left, bottomline.bottom + 30*HeightRation, kScreenWidth - _tipLab.left*2, 44*HeightRation) backImageName:nil title:@"确认" titleColor:HBColor(255, 255, 255) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:14] backColor:HBColor(40, 168, 240)];
        [_sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_sureBut];
    }
    
    
}
//监听垫盘调用的通知
- (void)listeningKeyboard {
    //键盘将要显示时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //键盘将要结束时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

//键盘将要显示
-(void)boardWillShow:(NSNotification *)notification{
    //获取键盘高度，
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //键盘弹出的时间
    CGFloat time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    if (self.delegate&&[self.delegate respondsToSelector:@selector(InputBounced: time:)]){
    //        [self.delegate InputBounced:kbHeight time:time];
    //    }
    [UIView animateWithDuration:time animations:^{
        _bottomView.bottom = kScreenHeight - kbHeight ;
    }];
}

//键盘将要结束
-(void)boardDidHide:(NSNotification *)notification{
    
    //获取键盘高度，
//    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //键盘弹出的时间
    CGFloat time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    if (self.delegate&&[self.delegate respondsToSelector:@selector(hidenBounced: time:)]) {
    //        [self.delegate hidenBounced:kbHeight time:time];
    //    }
    [UIView animateWithDuration:time animations:^{
         _bottomView.bottom = kScreenHeight ;
    }];
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.codeField) {
        if (string.length == 0) return YES;
//        if (range.location >= 6)
        if (range.location > 6)
            return NO; // return NO to not change text
        return YES;
    }else if (textField == self.imgCodeText){
//        if (range.location >= 5)
        if (range.location > 5)
            return NO; // return NO to not change text
        return YES;
    }else{
        return NO;
    }
    
}
#pragma mark ---更多按钮弹出的控制面板点击事件
- (void)tapGestureAction:(UITapGestureRecognizer *)tap{
    self.hidden = YES;
    //隐藏键盘,既失去第一响应
    if (_codeField) {
        [_codeField resignFirstResponder];
    }
    if (_imgCodeText) {
        [_imgCodeText resignFirstResponder];
    }
    [self destroyTimer];
    
    if ([self.delegate respondsToSelector:@selector(touchOrCancelAction)]) {
        [self.delegate touchOrCancelAction];
    }

}
-(void)hideView{
    self.hidden = YES;
    //隐藏键盘,既失去第一响应
    if (_codeField) {
        [_codeField resignFirstResponder];
    }
    if (_imgCodeText) {
        [_imgCodeText resignFirstResponder];
    }
    [self destroyTimer];
    if ([self.delegate respondsToSelector:@selector(touchOrCancelAction)]) {
        [self.delegate touchOrCancelAction];
    }
}
#pragma arguments about timer
-(void)destroyTimer{
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
    }
    NSLog(@"%@",_timer);
}
- (void)beginTimer
{
    _resendBut.enabled = NO;
    _timer = [NSTimer timerWithTimeInterval:1
                                     target:self
                                   selector:@selector(timeInterval:)
                                   userInfo:nil
                                    repeats:YES];
    _date = [NSDate date];
    [_timer setFireDate:_date];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)timeInterval:(NSTimer *)timer
{
    NSInteger timeInterval = [_date timeIntervalSinceDate:timer.fireDate];
    NSInteger interval = timeInterval + KCheckTime;
    if (interval < 0) {
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        _resendBut.enabled = YES;
        [_resendBut setTitleColor:HBColor(40, 168, 240) forState:UIControlStateNormal];
        [_resendBut setTitle:@"重新获取"
                     forState:UIControlStateNormal];
    } else {
        _resendBut.enabled = NO;
        NSString *title = [NSString stringWithFormat:@"%zd秒后重新获取", interval];
        [_resendBut setTitleColor:HBColor(197, 203, 213) forState:UIControlStateNormal];
        [_resendBut setTitle:title forState:UIControlStateNormal];
    }
}
- (void)endTimer
{
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
    _resendBut.enabled = YES;
    [_resendBut setTitle:@"重新获取"
                 forState:UIControlStateNormal];
}
-(void)resendCode{
    //点击重新发送验证码  在此处用代理 要去重新发送code,并且此处重新开始计时
    if ([self.delegate respondsToSelector:@selector(codeAuthViewResendIMSCode)]) {
        [self.delegate codeAuthViewResendIMSCode];
    }
    [self beginTimer];
}
-(void)sureAction{
    //在此处代理,吧相关的值传过去,让其进行验证  并且关闭定时器
    [self destroyTimer];
    if ([self.delegate respondsToSelector:@selector(codeAuthView: finishAuthWithStr:)]) {
        if (_isImage) {
             [self.delegate codeAuthView:self finishAuthWithStr:_imgCodeText.text];
        }else{
           [self.delegate codeAuthView:self finishAuthWithStr:_codeField.text];
        }
    }
    self.hidden = YES;
    //隐藏键盘,既失去第一响应
    if (_codeField) {
        [_codeField resignFirstResponder];
    }
    if (_imgCodeText) {
        [_imgCodeText resignFirstResponder];
    }
}
-(void)regetImageGesture:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(codeAuthViewRegetImge)]) {
        [self.delegate codeAuthViewRegetImge];
    }
}
@end
