//
//  HBLoginViewController.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//  登录页面 暂时没有 tips


#import "HBLoginViewController.h"
#import "HBInputView.h"//输入框的封装
#import "HBLoadButton.h"
#import <IQKeyboardManager.h>
#import "IQKeyboardManager.h"
#import "HBPhoneAttributionVC.h"//国家页面
#import "HBCountry.h"
#import "HBPhoneRegisterVC.h"
#import "CodeAuthView.h"
#import "HBMsgCodeAuthVC.h"
#import "HBResetPawVC.h"
#import "HBSettingPwdVC.h"
#import "HBFindPwdVC.h"
#import "HBRisk.h"
#import <MSAuthSDK/MSAuthVCFactory.h>//投篮验证
#import "HTCodeAuthView.h"
#import "HTCodeTextView.h"


@interface HBLoginViewController ()<HBInputViewDelegate,HBPhoneAttributionVCDelegate,codeAuthViewDelegate,MSAuthProtocol>{
//    IQKeyboardReturnKeyHandler * _returnKeyHander;
}
@property (nonatomic, strong) UIButton *HotpayBut;//开通hotpay
@property (nonatomic, strong) UILabel *titleLab;//titleLab
@property (nonatomic, strong) HBInputView *phoneView;//手机号的view
@property (nonatomic, strong) HBInputView *pwdView;//输入密码
@property (nonatomic, strong) HBLoadButton *loadButton;//登陆
@property (nonatomic, strong) UIButton *forgetBut;//忘记密码按钮
@property (nonatomic, strong) CodeAuthView *codeView;//验证码输入框
@property (nonatomic, strong) HTCodeAuthView *HTCodeView;
@property (nonatomic, strong)HBRisk   *riskModel;//风控
@property (nonatomic, copy) NSString                    *imgCode;//图像字符
@property (nonatomic, copy) NSString                    *sessionid;//投篮回调中的sessionid
@property (nonatomic, strong)NSMutableDictionary        *afs;  //用于投篮验证的附加的字典
@property (nonatomic, strong)UINavigationController     *nav;
@property (nonatomic, strong)NSString                   *token;//需要二次验证返回的token
@property (nonatomic, strong)NSString                   *account;//二次验证中手机账号



@end

@implementation HBLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //写入这个方法后,这个页面将没有这种效果
    [IQKeyboardManager sharedManager].enable = NO;
    //点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //    _returnKeyHander = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //最后还设置回来,不要影响其他页面的效果
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"用户登录";
    [self creatSubViews];
}
-(void)creatSubViews{
    //右上角跳转  CGRectMake(kScreenWidth - 14.5*WIDTHRation - 77*WIDTHRation, 35.5*HeightRation, 77*WIDTHRation, 14*HeightRation)
    _HotpayBut = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:TGLocalized(@"HBLogin.hotpay") titleColor:HBColor(41, 147, 249) font:[UIFont systemFontOfSize:14] backColor:[UIColor clearColor]];
    [_HotpayBut addTarget:self action:@selector(hotpayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_HotpayBut];
    [_HotpayBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(35.5*HeightRation);
        make.right.mas_equalTo(self.view.mas_right).offset(-14.5*WIDTHRation);
        make.height.mas_equalTo(14*HeightRation);
    }];
    //title :CGRectMake(30*WIDTHRation, 105*HeightRation, 163*WIDTHRation, 30*HeightRation)
    _titleLab = [createLbaelButView createLabelFrame:CGRectZero font:30 text:TGLocalized(@"HBLogin.LogTitle") textColor:HBColor(40, 168, 240)];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
    [self.view addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(105*HeightRation);
        make.left.mas_equalTo(self.view.mas_left).offset(30*WIDTHRation);
        make.height.mas_equalTo(30*HeightRation);
    }];
    //账号输入
    _phoneView = [[HBInputView alloc]initWithFrame:CGRectMake(30*WIDTHRation, 225.5*HeightRation, 315*WIDTHRation, 55*HeightRation)];
    _phoneView.tag = 0;
    _phoneView.delegate = self;
    _phoneView.type = InputViewType_normal;
    _phoneView.keyboardType = UIKeyboardTypeASCIICapable;
    _phoneView.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _phoneView.textColor = HBColor(78, 78, 78);
    //TGLocalized(@"login_account_tips")
    [_phoneView setTips:@"手机号码"
              tipsColor:HBColor(255, 92, 92)];
    [_phoneView setPlaceholder:TGLocalized(@"login_account_hint")
              placeholderColor:HBColor(197, 207, 213)
                      fontSize:16];
    [_phoneView setLineNormalColor:HBColor(244, 244, 244)
                         highColor:HBColor(21, 180, 241)];
    [self.view addSubview:_phoneView];
    //密码输入
    _pwdView = [[HBInputView alloc]initWithFrame:CGRectMake(30*WIDTHRation, 282.5*HeightRation, 315*WIDTHRation, 55*HeightRation)];
    _pwdView.tag = 1;
    _pwdView.delegate = self;
    _pwdView.type = InputViewType_pwd;
    _pwdView.lookNormalImage = @"invalidName";
    _pwdView.lookSelectImage = @"Invisible_black_selected";
    _pwdView.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdView.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _pwdView.textColor = HBColor(78, 78, 78);
    //TGLocalized(@"login_pwd_tips")
    [_pwdView setTips:@"密码"
            tipsColor:HBColor(255, 92, 92)];
    [_pwdView setPlaceholder:TGLocalized(@"login_pwd_text_hint")
            placeholderColor:HBColor(197, 207, 213)
                    fontSize:16];
    [_pwdView setLineNormalColor:HBColor(244, 244, 244)
                       highColor:HBColor(21, 180, 241)];
    [self.view addSubview:_pwdView];

    
    //登录   CGRectMake(_pwdView.left, 349.5*HeightRation, 315*WIDTHRation, 44*HeightRation)
    _loadButton = [[HBLoadButton alloc]initWithFrame: CGRectMake(_pwdView.left, 349.5*HeightRation, 315*WIDTHRation, 44*HeightRation)];
    [_loadButton setTitle:TGLocalized(@"wallet_login")
                 forState:UIControlStateNormal];
    [_loadButton addTarget:self
                    action:@selector(loadButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadButton];
    _loadButton.enabled = NO;
    
    //忘记密码  CGRectMake(_pwdView.left, 423.5*HeightRation, 56*WIDTHRation, 14*HeightRation)
    _forgetBut = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:TGLocalized(@"login_forget_pwd") titleColor:HBColor(40, 168, 240) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] backColor:[UIColor clearColor]];
//    _forgetBut.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_forgetBut addTarget:self action:@selector(forgetPwdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetBut];
    [_forgetBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(423.5*HeightRation);
        make.left.mas_equalTo(self.view.mas_left).offset(30*WIDTHRation);
        make.height.mas_equalTo(14*HeightRation);
    }];
    
    
//    _codeView = [[CodeAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}
-(void)hotpayAction{
//    [self.navigationController pushViewController:[[HBPhoneRegisterVC alloc]init] animated:YES];
//    _HTCodeView = [[HTCodeAuthView alloc]init];
    //[[HTCodeAuthView alloc]initWithFrame:CGRectMake(100, 100, 300*WIDTHRation, 200)]
    
    
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(38*WIDTHRation, 79*HeightRation, 100, 100)];
//    backView.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:backView];
//
//
//    _HTCodeView = [[HTCodeAuthView alloc]init];
//    [backView addSubview:_HTCodeView];
//    _HTCodeView.type = BothImageGoogle;
//    backView.size = CGSizeMake(_HTCodeView.width+10, _HTCodeView.height+10);
    
    HTCodeTextView *textview = [[HTCodeTextView alloc]initWithFrame:CGRectMake(100, 100, 260, 39)];
    textview.type = PhoneType;
    [self.view addSubview:textview];
    

////    _codeView = [[CodeAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithIsImage:YES];
//    _codeView = [[CodeAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithIsImage:NO];
//    _codeView.delegate = self;
//    [self.view addSubview:_codeView];
////    [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:nil WithImage:[UIImage imageNamed:@"h1"]];
////    [_codeView setPhoneAndGoogleWithISgoogle:YES WithPhoneString:nil WithImage:nil];
//    [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:@"17600103768" WithImage:nil];
//    [UIView animateWithDuration:.5 animations:^{
//        _codeView.hidden = NO;
//    }];
}

-(void)forgetPwdAction{
    //test
//    [self.navigationController pushViewController:[[HBMsgCodeAuthVC alloc]init] animated:YES];//短信验证
//    [self.navigationController pushViewController:[[HBResetPawVC alloc]init] animated:YES];//重置密码
//    [self.navigationController pushViewController:[[HBSettingPwdVC alloc]init] animated:YES];//设置密码
//    [self.navigationController pushViewController:[[HBPhoneRegisterVC alloc]init] animated:YES];
    [self.navigationController pushViewController:[[HBFindPwdVC alloc]init] animated:YES];
    
//    [HBHttpHelper GetIMgCodeWithSuccess:^(id responseObject) {
//        NSLog(@"responseObject ------- %@",responseObject);
//    } failure:^(HBErrorModel *error) {
//        NSLog(@"%@",error);
//    }];
}


//test
#pragma mark - HBPhoneAttributionVCDelegate   点击国家的代理回调
- (void)phoneAttributionVC:(HBPhoneAttributionVC *)phoneAttributionVC selectCountry:(HBCountry *)country
{
//    _selectCountryView.country = country.countries;
    _phoneView.text = [NSString stringWithFormat:@"+%@", country.area_code];
//    _country = country;
    if (_phoneView.text.length == 0) return;
}


#pragma mark - HBInputViewDelegate
- (void)inputView:(HBInputView *)inputView textFieldEditChangedAtText:(NSString *)text
{
    if ([self isValidateAccount:_phoneView.text] && _pwdView.text.length > 0) {
        _loadButton.enabled = YES;
    } else {
        _loadButton.enabled = NO;
    }
}

- (void)inputView:(HBInputView *)inputView textFieldShouldBeginEditAtText:(NSString *)text
{
    if ([self isValidateAccount:_phoneView.text] && _pwdView.text.length > 0) {
        _loadButton.enabled = YES;
    } else {
        _loadButton.enabled = NO;
    }
    
//    inputView.tipsImageHidden = YES;
//    inputView.tipsHidden = YES;
}

- (void)inputView:(HBInputView *)inputView textFieldShouldEndEditAtText:(NSString *)text
{
    if ([self isValidateAccount:_phoneView.text] && _pwdView.text.length > 0) {
        _loadButton.enabled = YES;
    } else {
        _loadButton.enabled = NO;
    }
    
    if (inputView.tag == 0) {
        if (inputView.text.length == 0) {
//            inputView.tipsHidden = NO;
//            inputView.tips = HBLocalizedString(@"login_account_write_tips");
        } else if ([self isValidateAccount:inputView.text]) {
//            inputView.tipsHidden = YES;
        } else {
//            inputView.tipsHidden = NO;
//            inputView.tips = HBLocalizedString(@"login_account_tips");
        }
    } else {
        if (inputView.text.length == 0) {
//            inputView.tipsHidden = NO;
//            inputView.tips = HBLocalizedString(@"login_pwd_write_tips");
        } else if ([self isValidatePwd:inputView.text]) {
//            inputView.tipsHidden = YES;
        } else {
//            inputView.tipsHidden = NO;
//            inputView.tips = HBLocalizedString(@"login_pwd_write_tips");
        }
    }
}
- (BOOL)inputViewShouldReturn:(HBInputView *)inputView
{
    if (inputView == self.phoneView) {
        [self.pwdView.textField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    return YES;
}
#pragma mark - 账号
- (BOOL)isValidateAccount:(NSString *)text
{
    if ([text isValidateEmail] || [text isValidateNumber]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 密码
- (BOOL)isValidatePwd:(NSString *)text
{
    if ([text isValidatePwd]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)allDisabled
{
    _forgetBut.enabled = NO;
    _phoneView.userInteractionEnabled = NO;
    _pwdView.userInteractionEnabled = NO;
    self.backButton.userInteractionEnabled = NO;
}
- (void)allEnabled
{
    _forgetBut.enabled = YES;
    _phoneView.userInteractionEnabled = YES;
    _pwdView.userInteractionEnabled = YES;
    self.backButton.userInteractionEnabled = YES;
}
#pragma mark 网络请求相关
- (void)loadButtonClicked:(HBLoadButton *)btn
{
    [self.view endEditing:YES];
    if ([_loadButton isLoading]) return;
    
    [_loadButton beginAnimation];
    [self allDisabled];
    if (_phoneView.text.length > 0 &&
        _pwdView.text.length > 0) {
        //进行风控验证
        [self riskVerfitry];
    }
}
#pragma mark - 请求hb 风控验证
- (void)riskVerfitry
{
    NSMutableDictionary * parm = [[NSMutableDictionary alloc]init];
    parm[@"scene"] = @(Risk_Login);
    parm[@"login_name"] = _phoneView.text;
    parm[@"source"] = @(Deveice_APP);
    parm[@"fingerprint"] = [NSString deviceID];//获取设备uuid
    NSLog(@"%@",parm);
    [HBHttpHelper riskControlWithParameters:parm success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.riskModel = [HBRisk yy_modelWithJSON:responseObject];
        if ([self.riskModel.risk isEqualToString:@"0"]) {
            //没风险 不用图片验证码 直接下一步登录接口
            [self login];
        }else{
            if ([self.riskModel.captcha_type isEqualToString:@"0"]) {
//                [_alertView clean];
//                WeakSelf(self)
                //发送图片验证码
                [HBHttpHelper GetIMgCodeWithSuccess:^(id responseObject) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
                    [self codeViewInitWithImg:responseObject];
//                    });
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
        [self allEnabled];
        [_loadButton endAnimation];
        [MBProgressHUD showText:error.message toView:self.view];
    }];

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
    [self verifyErrorWithToken:_token code:codeStr codeView:codeAuthView];
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
    [_loadButton endAnimation];
    [self allEnabled];
    _imgCode = nil;
}

#pragma mark -- 阿里风控验证
- (void)riskVerfitryVC
{
    NSString * langer;
    //设置语言
//    switch ([[HBLanguageTool shareLanguage]type]) {
//        case LanguageType_zh:
//            langer = @"zh_CN";
//            break;
//        case LanguageType_ko:
//            langer = @"ko";
//            break;
//        case LanguageType_en:
//            langer = @"en";
//            break;
//        default:
//            langer = @"en";
//            break;
//    }
    langer = @"zh_CN";
    
    //启动验证（不依赖业务风险防控结果(此部分可能为自己服务器判断)，直接启动验证）
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
        //自己关闭controller,sdk不会自己关闭
        [_nav dismissViewControllerAnimated:YES completion:nil];
        if (error) {
            _afs = nil;
            [self allEnabled];
            [_loadButton endAnimation];
            [MBProgressHUD showText:HBLocalizedString(@"trade_status_fail") toView:self.view];
        }else{
            //回调结果成功后,将session传给服务器
            _afs = [[NSMutableDictionary alloc]init];
            _afs[@"platform"] = @"2";
            [_afs setValue:sessionId forKey:@"session"];
            [self login];
        }
    });
}
-(void)login{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"login_name"] = _phoneView.text;
    dic[@"password"] = [_pwdView.text appendPwd];
    dic[@"way"] = @"APP_HUOBI_WALLET";
    dic[@"ga_switch"] = @(YES);
    dic[@"fingerprint"] = [NSString deviceID];
    if (_imgCode.length > 0) {//图片验证用户输入的文本
        dic[@"captcha_code"] = _imgCode;
    }
    if (_sessionid.length > 0) {//风险验证的sessionid
        //将sdk验证码参数传递给服务端
        dic[@"captcha_key"] = _sessionid;
    }
    if (_afs.count > 0) {
        [dic setValue:_afs forKey:@"afs"];
    }
    NSLog(@"dic---------------%@",dic);
    [HBHttpHelper loginWithParameters:dic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        //登陆成功应该对按钮进行停止动画
        [self loginSuccess:responseObject];
    } failure:^(HBErrorModel *error) {
        NSLog(@"%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loginFailure:error];
        });
        
    }];
}
#pragma  mark --- login deal
//登陆成功
- (void)loginSuccess:(NSString *)ticket {
//    [UserDefaults saveObject:_phoneView.text forKey:@"userName"];
//    if (_alertView) {
//        [_alertView hide];
//    }
    NSLog(@"%@",ticket);
    _imgCode = nil;
    _sessionid = nil;
    
//    if (![_phoneView.text isEqualToString:_originAccount]) {
//        [HBFingerprintTool setIsOpenFingerprint:NO];
//    }
    //验证设备ticket   验证设备是否为常用设备
//    [self verifyDeviceCommonWithTicket:ticket];
    [self allEnabled];
    [_loadButton endAnimation];
    [MBProgressHUD showText:[NSString stringWithFormat:@"登陆成功 ticket %@",ticket] toView:self.view];
    
}

- (void)loginFailure:(HBErrorModel *)errorModel
{
    _imgCode = nil;
    _sessionid = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self allEnabled];
        [_loadButton endAnimation];
//    });
    
    NSLog(@"%ld",(long)errorModel.code);
    
    //返回10070
    if (errorModel.code == HBHttp_error_login_verficy) {
        //进行二次验证
        [self LoginVerifry:errorModel];
    }
    else if (errorModel.code == HBHttp_error_params) {
        //账号或密码不正确
        [MBProgressHUD showText:@"账号或密码错误" toView:self.view];
    }
    else if (errorModel.code == HBHttp_error_img_code) {//图片验证码错误
        if (![_riskModel.risk isEqualToString:@"0"]
            &&![_riskModel.captcha_type isEqualToString:@"0"]) {
            [MBProgressHUD showText:errorModel.message toView:self.view];
        }else{
//            [_alertView clean];
            _codeView.hidden = YES;
            _codeView = nil;
            [HBHttpHelper GetIMgCodeWithSuccess:^(id responseObject) {
                [self codeViewInitWithImg:responseObject];
            } failure:^(HBErrorModel *error) {
                [MBProgressHUD showText:error.message toView:self.view];
            }];
        }
    }
    else if (errorModel.code == HBHttpCode_networkError) {//网络请求出错
        [MBProgressHUD showText:errorModel.message toView:self.view];
    }
    else if(errorModel.code == HBHttp_error_passerror){//账号密码错误
//        [_alertView hide];
        _codeView.hidden  = YES;
        _codeView = nil;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:errorModel.message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _pwdView.text = @"";
            _loadButton.enabled = NO;
        }];
        UIAlertAction *forgetAction = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self pwdButtonClicked:nil];
            [self forgetPwdAction];
        }];
        [alertController addAction:forgetAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
//        [_alertView hide];
//        _alertView = nil;
        _codeView.hidden = YES;
        _codeView = nil;
        [MBProgressHUD showText:errorModel.message toView:self.view];
    }
}
//二次验证
- (void)LoginVerifry:(HBErrorModel *)error
{
    _codeView.hidden = YES;
    _codeView = nil;
    [_codeView removeFromSuperview];
    //二次验证
    [self VerifyErrorWithToken:error];
}
//二次验证的时候,才调用
- (void)VerifyErrorWithToken:(HBErrorModel *)error {
    NSString * errorType = [NSString stringWithFormat:@"%@",error.data[@"type"]];
//    _alertAction = [[HBInputCodeAlertAction alloc] init];
    _token = error.data[@"token"];
//    WeakSelf(self)
    switch ([errorType integerValue]) {
        case 1:
        {
            //谷歌验证码
//            [_alertAction showGaCodeAlertActionWithTitle:HBLocalizedString(@"alret_action_login_ga_title")];
            _codeView = [[CodeAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithIsImage:YES];
            _codeView.delegate = self;
            [self.view addSubview:_codeView];
//            [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:nil WithImage:img];
            [_codeView setPhoneAndGoogleWithISgoogle:YES WithPhoneString:nil WithImage:nil];
            //    [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:@"17600103768" WithImage:nil];
            [UIView animateWithDuration:.5 animations:^{
                _codeView.hidden = NO;
            }];
            //输入google验证码 ,点确定之后的回调
        }
            break;
        case 2:
        {//发送手机验证码
//            StrongSelf(self)
            _account = error.data[@"phone"];
            _codeView = [[CodeAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithIsImage:NO];
            _codeView.delegate = self;
            [self.view addSubview:_codeView];
            [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:_account WithImage:nil];
            [UIView animateWithDuration:.5 animations:^{
                _codeView.hidden = NO;
            }];
            //发送手机验证码请求
            [self sendVericyPhoneCodeWithIsVoice:NO success:^(id obj) {
                //开启_codeview 的定时  +  发送验证接口的事件
                
            }];
            //重新发送
//            [_alertAction setAfreshBlock:^(HBInputCodeAlertAction *action){
//                [strongSelf sendVericyPhoneCodeWithIsVoice:NO success:^(id obj){
//                    StrongSelf(self)
//                    [strongSelf beginTimer];
//                }];
//            }];
        }
            break;
//        case 3:
//        {//发送邮箱验证码
//            _account = error.data[@"email"];
//            [_alertAction showEmailCodeAlertActionWithTitle:HBLocalizedString(@"alret_action_login_email_title") account:error.data[@"email"]];
//            [self sendVericyEmailCodeWithSuccess:^(id obj){
//                StrongSelf(self)
//                [strongSelf beginTimer];
//            }];
//
//            [_alertAction setAfreshBlock:^(HBInputCodeAlertAction *action){
//                StrongSelf(self)
//                [strongSelf sendVericyEmailCodeWithSuccess:^(id obj){
//                    [strongSelf beginTimer];
//                }];
//            }];
//        }
//            break;
            
        default:
            break;
    }
    //重新发送手机验证码,以delegate方式请求
//    [_alertAction setAffirmBlock:^(HBInputCodeAlertAction *action, NSString *text){
//        StrongSelf(self)
//        [strongSelf verifyErrorWithToken:error.data[@"token"] code:text action:action];
//    }];
}

- (void)verifyErrorWithToken:(NSString *)token code:(NSString *)code codeView:(CodeAuthView *)codeView{
    MBProgressHUD *hud = [MBProgressHUD showLoadingToView:self.view];
    NSDictionary *parameter = @{@"token" : token,
                                @"auth_code" : code};
    [HBHttpHelper verifyErrorLoginWithParameters:parameter success:^(id responseObject) {
        [hud hideHUD:YES];
//        [action hide];
        codeView.hidden = YES;
        [codeView removeFromSuperview];
        [_loadButton beginAnimation];
        [self allDisabled];
        [self loginSuccess:responseObject];
        
    } failure:^(HBErrorModel *error) {
//        [action cleanCode];
        [hud hideHUD:YES];
        if (error.code == HBHttp_error_login_token) {
            _codeView.hidden = YES;
            _codeView = nil;
            NSLog(@"token 过期");
        }
        [MBProgressHUD showText:error.message toView:self.view];
    }];
}
- (void)sendVericyPhoneCodeWithIsVoice:(BOOL)isVoice
                                         success:(void (^)(id))success
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"use_type"] = LOGIN;
    parameters[@"token"] = _token;
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
    NSLog(@"%@",parameters);
    /*
     {
     afs =     {
     platform = 2;
     session = "nc1-01kpKpD9cZIa0BMLxnFjaumZmG7AUy4xelWd2pBZLzSPVG4Ixq0CUlM9SrKtzoNkIh-nc2-05BycC1RVYdxRGBYboM8HvXJAFpwSTL9Pi9iDlpYgs7bYVyaSQt3tjFQYNDL3hF0GE2TOrtmtAjeKnRWW_dj2Gsrlc5F9YNDOV2bkJTRSb2KmeLk5mKI21SnfKkznGt8bFGwoQyjb7x6twtQN1IbD1j5EM07qTyDL0uooaG88v1QK7POo92qIWjug3Wy4otQ6OZQVC8vnfT0tKmwIBWA-91DCQkYFWLUsLmzeU6lC_B_Q5nKCmBYiXeLivorUw7k4xmkEN9vDijZCQjQTmlEw2qrt1bSNaWqNjsCg80sISCKQxr_Zt2uYOvflyzrzRr-R9xEstn8Aq2TW50kjkYsTeYFsAxQHojeOF39MSL4bxBD504SNrBMGyBiiBlECLsYaWlRljdCiTidTUkd3GRki_4dNAYoBy4NF4M8Fx_sxl1YQ-nc3-012fFSZXkPovoERrcGicZEUWM2IX9Sm1dcRpAvchv6vY3skVoj5WbjjdySqay1eTNPUWdS78Ens82RZ3rzDC5zA9IjiP2K9a5HfMFxa6nMeZ8evUWYO2QjnfZizNd0gnVO1UPQdczsEjvTzE0frUZMzA-nc4-FFFFI000000001796D97";
     };
     token = ec700c2f6840483a9e78f806a4693cdf;
     "use_type" = LOGIN;
     voice = 0;
     }
     
     暂不可测
     //显示返回参数出错
     {
     code = 502;
     data = "<null>";
     message = "\U53c2\U6570\U9519\U8bef";
     success = 0;
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showLoadingToView:self.view];
    [HBHttpHelper sendPhoneCodeWithParameters:parameters success:^(id responseObject) {
        [hud hideHUD:YES];
        if (success) {
            success(responseObject);
        }
    } failure:^(HBErrorModel *error) {
        if (error.code == HBHttp_error_login_token) {
            _codeView.hidden = YES;
            _codeView = nil;
        }
        [hud hideHUD:YES];
        [MBProgressHUD showText:error.message toView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
