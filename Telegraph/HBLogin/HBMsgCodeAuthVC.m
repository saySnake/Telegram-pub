//
//  HBMsgCodeAuthVC.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/24.
//

#import "HBMsgCodeAuthVC.h"
#import "EMPasswordInputView.h"
#import "Masonry.h"
#import "BBCaptchaButton.h"
#import <MSAuthSDK/MSAuthVCFactory.h>
#import "CodeAuthView.h"
#import "HBSettingPwdVC.h"
#define KCheckTime 60
#define WS(weakSelf)      __weak __typeof(&*self)weakSelf = self;

@interface HBMsgCodeAuthVC ()<EMPasswordInputViewDelegate,MSAuthProtocol,codeAuthViewDelegate>
@property (nonatomic ,strong)UILabel *titleLab;
@property (nonatomic ,strong)EMPasswordInputView *passWordView;
@property (nonatomic ,strong)UIButton *resendBut;
@property (nonatomic ,strong)UIButton *tipsBut;
@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, strong) NSDate  *date;
@property (nonatomic, strong)HBRisk   *riskModel;//风控
@property (nonatomic, copy) NSString                    *sessionid;
@property (nonatomic, copy) NSString                    *imgCode;
@property (nonatomic, strong)NSMutableDictionary        *afs;
@property (nonatomic ,strong)UINavigationController     *nav;
@property (nonatomic, strong) CodeAuthView *codeView;//验证码输入框
@property (nonatomic, copy) NSString                    *authCode;//验证码



@property (nonatomic ,strong)BBCaptchaButton *captchaBtn;

@end

@implementation HBMsgCodeAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self beginTimer];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HBColor(255, 255, 255);
    //CGRectMake(30*WIDTHRation, 104*HeightRation, 150*WIDTHRation, 30*HeightRation)
    _titleLab = [createLbaelButView createLabelFrame:CGRectZero font:30 text:@"短信验证码" textColor:HBColor(78, 78, 78)];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(30*WIDTHRation);
        make.left.mas_equalTo(self.view).offset(30*WIDTHRation);
        make.top.mas_equalTo(104*HeightRation);
        make.height.mas_equalTo(30*HeightRation);
    }];
    
    //CGRectMake(0, _titleLab.bottom + 50*HeightRation, kScreenWidth, 50*HeightRation)
    //CGRectMake(0, 104*HeightRation + 30*HeightRation  + 50*HeightRation, kScreenWidth, 50*HeightRation)
    _passWordView = [EMPasswordInputView inputViewWithFrame:CGRectMake(0, 104*HeightRation + 30*HeightRation  + 50*HeightRation, kScreenWidth, 50*HeightRation) numberOfCount:6 widthOfLine:44*WIDTHRation intervalOfLine:10*WIDTHRation];
    _passWordView.backgroundColor = [UIColor clearColor];
    _passWordView.delegate = self;
    _passWordView.contentAttributes = @{NSForegroundColorAttributeName : HBColor(78, 78, 78), NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Semibold" size:30]};
//    _passWordView.lineHeight = 1;//设置也给textfild 重新居中布局了
//    _passWordView.wordsLineOffset = 5;
    _passWordView.passwordKeyboardType = UIKeyboardTypeNumberPad;
    _passWordView.passwordType = EMPasswordTypeDefault;
    [self.view addSubview:_passWordView];
//    [_passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.equalTo(_titleLab.mas_bottom).offset(50*HeightRation);
//        make.height.mas_equalTo(50*HeightRation);
//        make.width.mas_equalTo(kScreenWidth);
//    }];
    
    //CGRectMake(30*WIDTHRation, 256.5 *HeightRation, 93*WIDTHRation, 14*HeightRation)
    _resendBut = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:@"46s后重新发送" titleColor:HBColor(197, 207, 213) font:[UIFont fontWithName:@"HelveticaNeue" size:14] backColor:[UIColor clearColor]];
    _resendBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_resendBut addTarget:self action:@selector(resendCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resendBut];
    [_resendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(256.5 *HeightRation);
        make.left.mas_equalTo(30*WIDTHRation);
        make.height.mas_equalTo(14*HeightRation);
    }];
    
    _tipsBut = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:@"短信验证码已发送" titleColor:HBColor(255, 255, 255) font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] backColor:HBColor(135, 154, 164)];
    _tipsBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _tipsBut.userInteractionEnabled = NO;
    _tipsBut.hidden = NO;
    [self.view addSubview:_tipsBut];
    [_tipsBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(297 *HeightRation);
        make.left.mas_equalTo(116.5 *WIDTHRation);
        make.height.mas_equalTo(44 *HeightRation);
        make.width.mas_equalTo(142 *WIDTHRation);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
         _tipsBut.hidden = YES;
    });
 
//    [self.view addSubview:self.captchaBtn];
//    [_captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(100);
//        make.right.mas_equalTo(-15);
//    }];
}
#pragma mark -- EMPasswordInputViewDelegate
//输入到最后一个的回调
- (void)EM_passwordInputView:(EMPasswordInputView *)passwordView finishInput:(NSString *)contentStr {
    NSLog(@"输入完成后str%@",contentStr);
    _authCode = contentStr;
    if (contentStr.length == 6) {
        if ([contentStr isValidateNumber]) {
            NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc]init];
            phoneDic[@"country_code"]=_countryCode;
            phoneDic[@"phone"] = _account;
            phoneDic[@"auth_code"] = contentStr;
            [self verfityCode:phoneDic];
        }
    }
}
#pragma mark 验证手机邮箱
-(void)verfityCode:(NSDictionary *)dic
{
    MBProgressHUD *hud = [MBProgressHUD showLoadingToView:self.view];
    [HBHttpHelper verifyCodeWithParameters:dic success:^(id responseObject) {
        [hud hideHUD:YES];
        [self verfitySuccess:responseObject[@"auth_code"]];
    } failure:^(HBErrorModel *error) {
//            [_codeView clearPassword];
            [hud hideHUD:YES];
            [MBProgressHUD showText:error.message toView:self.view];
    }];

}
-(void)verfitySuccess:(NSString *)code
{
   
    HBSettingPwdVC *setPwdVC = [[HBSettingPwdVC alloc]init];
    setPwdVC.captcha = _authCode;//输入的验证码
    setPwdVC.account = self.account;
    setPwdVC.countryCode = self.countryCode;
    setPwdVC.code = code;//验证接口返回的code
    [self.navigationController pushViewController:setPwdVC animated:YES];
}
//正在编辑的回调
//- (void)EM_passwordInputView:(EMPasswordInputView *)passwordView edittingPassword:(NSString *)contentStr inputStr:(NSString *)inputStr {
//    NSLog(@"2.%@,%@",contentStr,inputStr);
//}

-(void)resendCode:(UIButton *)btn{
    //在本vc 中心发送 获取手机的验证码,通过外部,把参数传进来
//    NSString *account = _account;
    [self riskVerfitry];
//    [self beginTimer];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    NSLog(@"touch");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
#pragma mark ---about timer
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
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
    }
    _resendBut.enabled = YES;
    [_resendBut setTitle:@"重新获取"
                forState:UIControlStateNormal];
}

-(void)dealloc{
    [self destroyTimer];
}
#pragma mark - setter
- (void)setAccount:(NSString *)account
{
    _account = account;
}
- (void)setCountryCode:(NSString *)countryCode
{
    _countryCode = countryCode;
}
#pragma  mark 重新请求 phone code

#pragma mark - 阿里图片验证
- (void)riskVerfitry
{
//    WeakSelf(self)
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"scene"] = @(Risk_Register);
    parameters[@"login_name"] = _account;
    parameters[@"source"] = @(Deveice_APP);
    parameters[@"fingerprint"] = [NSString deviceID];
    [HBHttpHelper riskControlWithParameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.riskModel = [HBRisk yy_modelWithJSON:responseObject];
        if ([self.riskModel.risk isEqualToString:@"0"]) {
            [self sendPhoneCode];
        }else{
            if ([self.riskModel.captcha_type isEqualToString:@"0"]) {
                //                [_alertView clean];
                if (_codeView) {
                    _codeView = nil;
                    [_codeView removeFromSuperview];
                }
                //发送图片验证码
                [HBHttpHelper GetIMgCodeWithSuccess:^(id responseObject) {
                    [self codeViewInitWithImg:responseObject];
                } failure:^(HBErrorModel *error) {
                    [MBProgressHUD showText:error.message toView:self.view];
                }];
            }else{
                //阿里的
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self riskVerfitryVC];
                });
            }
        }
        
    } failure:^(HBErrorModel *error) {
        NSLog(@"%@",error);
        _imgCode = nil;
        _sessionid = nil;
        _resendBut.enabled = YES;
        [MBProgressHUD showText:error.message toView:self.view];
    }];
}
- (void)riskVerfitryVC
{
    NSString * langer;
    switch ([[HBLanguageTool shareLanguage]type]) {
        case LanguageType_zh:
            langer = @"zh_CN";
            break;
        case LanguageType_ko:
            langer = @"ko";
            break;
        case LanguageType_en:
            langer = @"en";
            break;
        default:
            langer = @"en";
            break;
    }
    
    UIViewController *vc = [MSAuthVCFactory simapleVerifyWithType:MSAuthTypeSlide
                                                         language:langer
                                                         Delegate:self
                                                         authCode:@"0335"
                                                           appKey:nil];
    _nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:_nav animated:YES completion:nil];
}
#pragma mark - 校验结果的回调
- (void)verifyDidFinishedWithResult:(t_verify_reuslt)code Error:(NSError *)error SessionId:(NSString *)sessionId  {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_nav dismissViewControllerAnimated:YES completion:nil];
        if (error) {
            _afs = nil;
            _resendBut.enabled = YES;
            [MBProgressHUD showText:HBLocalizedString(@"trade_status_fail") toView:self.view];
        }else{
            _afs = [[NSMutableDictionary alloc]init];
            _afs[@"platform"] = @"2";
            [_afs setValue:sessionId forKey:@"session"];
            [self sendPhoneCode];
        }
    });
}
//如果风控需要图片验证,则请求数据,拿到图片赋值;再次点击图片则重新获取图片
-(void)codeViewInitWithImg:(UIImage *)img{
    _codeView = [[CodeAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithIsImage:YES];
    _codeView.delegate = self;
    [self.view addSubview:_codeView];
    [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:nil WithImage:img];
    //    [_codeView setPhoneAndGoogleWithISgoogle:YES WithPhoneString:nil WithImage:nil];
    //    [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:@"17600103768" WithImage:nil];
    [UIView animateWithDuration:.5 animations:^{
        _codeView.hidden = NO;
    }];
}

#pragma mark CodeAuthViewdelegate
//点击确定
-(void)codeAuthView:(CodeAuthView *)codeAuthView finishAuthWithStr:(NSString *)codeStr{
//    [self verifyErrorWithToken:_token code:codeStr codeView:codeAuthView];
    _imgCode = codeStr;
    [self sendPhoneCode];
    NSLog(@"codestr--------%@",codeStr);
    
}
//从新获取验证码
-(void)codeAuthViewResendIMSCode{
    
}
//点击图片再次获取图片验证码
-(void)codeAuthViewRegetImge{
    [HBHttpHelper GetIMgCodeWithSuccess:^(id responseObject) {//点击再次获取图片的时候,仅仅更改图片
        [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:nil WithImage:responseObject];
    } failure:^(HBErrorModel *error) {
        [MBProgressHUD showText:error.message toView:self.view];
    }];
    //    [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:@"18827317612" WithImage:[UIImage imageNamed:@"h2"]];
}
-(void)touchOrCancelAction{
//    [_loadButton endAnimation];
//    [self allEnabled];
//    _resendBut
    _imgCode = nil;
}
-(void)sendPhoneCode{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = _account;
    parameters[@"country_code"] = _countryCode;
    parameters[@"use_type"] = REGISTER;
    [parameters setObject:[NSNumber numberWithBool:false] forKey:@"voice"];
    if (_imgCode.length > 0) {
        parameters[@"captcha_code"] = _imgCode;
    }
    if (_sessionid.length > 0) {
        parameters[@"captcha_key"] = _sessionid;
    }
    if (_afs.count > 0) {
        [parameters setValue:_afs forKey:@"afs"];
    }
    MBProgressHUD *hud = [MBProgressHUD showLoadingToView:self.view];
    [HBHttpHelper sendPhoneCodeWithParameters:parameters success:^(id responseObject) {
//        [self sendCodeSuccess:responseObject];
        [hud hideHUD:YES];
        [self beginTimer];
    } failure:^(HBErrorModel *error) {
//        [self sendCodeFailure:error];
//        _resendBut.enabled = YES;
        //失败以后结束计时
        [self endTimer];
        [hud hideHUD:YES];
        if (error.code == HBHttp_error_img_code) {
            if (![_riskModel.risk isEqualToString:@"0"]
                &&![_riskModel.captcha_type isEqualToString:@"0"]) {
                [MBProgressHUD showText:error.message toView:self.view];
            }else{
                _codeView.hidden = YES;
                _codeView = nil;
                [_codeView removeFromSuperview];
                [HBHttpHelper GetIMgCodeWithSuccess:^(id responseObject) {
                    [self codeViewInitWithImg:responseObject];
                } failure:^(HBErrorModel *error) {
                    [MBProgressHUD showText:error.message toView:self.view];
                }];
            }
        }else{
            [MBProgressHUD showText:error.message toView:self.view];
        }
    }];
}

/*
- (BBCaptchaButton *)captchaBtn {
    if (!_captchaBtn) {

        WS(weakSelf)
        _captchaBtn  = [[BBCaptchaButton alloc] initWithDuration:60 buttonClicked:^{
            //点击了按钮 回掉
            //这里需要处理判断逻辑,都满足的话, 直接调用BBCaptchaButton的 startCountDown 方法开始倒计时
            [weakSelf.captchaBtn setEnabled:YES];
//            if (weakSelf.clickCaptcha)
//                weakSelf.clickCaptcha();
 
            
            [weakSelf.captchaBtn startCountDown];

        } countDownStart:^{
            //开始倒计时 回掉
            //这里设置倒计时开始的文本
            //同时关闭交互属性,倒计时期间不允许交互
            [weakSelf.captchaBtn setEnabled:NO];
            [weakSelf.captchaBtn setTitle:@"60s" forState:UIControlStateNormal];
            [weakSelf.captchaBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

        } countDownUnderway:^(NSInteger restCountDownNum) {
            //倒计时进行中 回掉 (每秒回掉一次)
            //这里更新倒计时的最新数值
            NSString  * str = [NSString stringWithFormat:@"%lds",restCountDownNum];
            [weakSelf.captchaBtn setTitle:str forState:UIControlStateNormal];
            [weakSelf.captchaBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

        } countDownCompletion:^{
            //倒计时结束 回掉
            //这里恢复按钮的各种状态 文本,字体颜色,等等
            [weakSelf.captchaBtn setEnabled:YES];
            [weakSelf.captchaBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            [weakSelf.captchaBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }];

        [_captchaBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_captchaBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_captchaBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_captchaBtn setEnabled:YES];
    }
    return _captchaBtn;
}
- (void)dealloc {
    if (_captchaBtn)
        [_captchaBtn endCountDown];

    _captchaBtn = nil;
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
