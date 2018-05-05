//
//  HBPhoneRegisterVC.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/20.
//

#import "HBPhoneRegisterVC.h"
#import "HBSelectCountryView.h"
#import "UILabel+Utilities.h"
#import "HBCountry.h"
#import "HBPhoneAttributionVC.h"
#import "HBInputView.h"
#import "HBLoadButton.h"
#import <MSAuthSDK/MSAuthVCFactory.h>//投篮验证
#import "HBRisk.h"
#import "CodeAuthView.h"
#import "HBMsgCodeAuthVC.h"

@interface HBPhoneRegisterVC ()<HBSelectCountryViewDelegate,HBPhoneAttributionVCDelegate,HBInputViewDelegate,MSAuthProtocol,codeAuthViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong) UIButton *loginBut;//登陆
@property (nonatomic ,strong) UILabel *titleLab;//快速开通
@property (nonatomic ,strong) UIImageView *tipImgView;//tip图片
@property (nonatomic ,strong) UILabel *tipLab;//tip lab
@property (nonatomic ,strong) HBSelectCountryView *selectCountryView;//选择国家的 的view,与点击phoneView进入同一个页面
@property (nonatomic ,strong) HBCountry  *country;//country Mod
@property (nonatomic ,strong) HBInputView *phoneView;//手机输入框
@property (nonatomic ,strong) HBLoadButton *loadButton;//下一步but
@property (nonatomic ,strong)UINavigationController     *nav;
@property (nonatomic, strong)NSMutableDictionary        *afs;
@property (nonatomic, strong)HBRisk   *riskModel;//风控
@property (nonatomic, copy) NSString                    *sessionid;
@property (nonatomic, copy) NSString                    *imgCode;
@property (nonatomic, strong) CodeAuthView *codeView;//验证码输入框


@end

@implementation HBPhoneRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];//设置默认国家
    [self setupUI];
}
-(void)setupUI{
    [self.view addSubview:self.loginBut];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.tipImgView];
    [self.view addSubview:self.tipLab];
    
    _selectCountryView = [[HBSelectCountryView alloc]initWithFrame:CGRectMake(30*WIDTHRation, 208*HeightRation, 123*WIDTHRation, 26*HeightRation)];
    _selectCountryView.country = _country.countries;
    _selectCountryView.delegate = self;
    [self.view addSubview:_selectCountryView];
    
    _phoneView = [[HBInputView alloc]initWithFrame:CGRectMake(27*WIDTHRation, 264.5*HeightRation, 315*WIDTHRation, 50)];
    _phoneView.delegate = self;
    _phoneView.countryCode = _country.showCode;
    _phoneView.type = InputViewType_country;
    _phoneView.keyboardType = UIKeyboardTypeNumberPad;
    _phoneView.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _phoneView.textColor = HBColor(78, 78, 78);
    _phoneView.becomeFirstResponder = YES;
//    [_phoneView setTips:TGLocalized(@"register_phone_tips")
//              tipsColor:HBColor(255, 92, 92)];
    [_phoneView setPlaceholder:TGLocalized(@"register_phone_hint")
              placeholderColor:HBColor(197, 207, 213)
                      fontSize:16];
    [_phoneView setLineNormalColor:HBColor(244, 244, 244)
                         highColor:HBColor(143, 215, 215)];
    [self.view addSubview:_phoneView];
    
    //下一步
    _loadButton = [[HBLoadButton alloc]initWithFrame:CGRectMake(_phoneView.left,331*HeightRation, 315*WIDTHRation, 44*HeightRation)];
    [_loadButton setTitle:TGLocalized(@"register_next")
                 forState:UIControlStateNormal];
    [_loadButton addTarget:self
                    action:@selector(nextClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadButton];
    _loadButton.enabled = NO;
}
- (void)setupData
{
    _country = [HBCountry defautCountry];
}



#pragma mark - HBSelectCountryViewDelegate
- (void)selectCountryView:(HBSelectCountryView *)selectCountryView selectCountry:(NSString *)country
{
    HBPhoneAttributionVC *vc = [[HBPhoneAttributionVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - HBPhoneAttributionVCDelegate   点击国家的代理回调
- (void)phoneAttributionVC:(HBPhoneAttributionVC *)phoneAttributionVC selectCountry:(HBCountry *)country
{
    _selectCountryView.country = country.countries;
    _phoneView.countryCode = country.showCode;
    _country = country;
    
    if (_phoneView.text.length == 0) return;
}

#pragma mark - HBInputViewDelegate
- (void)inputView:(HBInputView *)inputView textFieldEditChangedAtText:(NSString *)text
{
    if (inputView.text.length > 11) {
        inputView.text = [inputView.text substringToIndex:11 ];
    }
    if (inputView.text.length == 0) {
        inputView.tipsHidden = NO;
        inputView.tips = TGLocalized(@"register_phone_hint");
        _loadButton.enabled = NO;
        // 手机号验证
    } else if ([self isValidatePhone:inputView.text]) {
        inputView.tipsHidden = YES;
        inputView.tipsImageHidden = NO;
        if (_phoneView.text.length > 4) {
            _loadButton.enabled = YES;
        } else {
            _loadButton.enabled = NO;
        }
    } else {
        inputView.tipsHidden = NO;
        inputView.tipsImageHidden = YES;
        inputView.tips = TGLocalized(@"register_phone_tips");
        _loadButton.enabled = NO;
    }
}

- (void)inputView:(HBInputView *)inputView textFieldShouldBeginEditAtText:(NSString *)text
{
    if (inputView.text.length == 0) {
        inputView.tipsHidden = NO;
        inputView.tips = TGLocalized(@"register_phone_hint");
        
        // 手机号验证
    } else if ([self isValidatePhone:inputView.text]) {
        inputView.tipsHidden = YES;
        inputView.tipsImageHidden = NO;
    } else {
        inputView.tipsHidden = NO;
        inputView.tipsImageHidden = YES;
        inputView.tips = TGLocalized(@"register_phone_tips");
    }
    [self inputView:_phoneView textFieldEditChangedAtText:_phoneView.text];
}
//响应HBInputView 的代理  点击进入国家选择
- (void)inputView:(HBInputView *)inputView countryCodeButtonClicked:(UIButton *)button
{
    HBPhoneAttributionVC *vc = [[HBPhoneAttributionVC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 手机号验证
- (BOOL)isValidatePhone:(NSString *)string
{
    if ([_country.area_code isEqualToString:@"0086"]) {
        return [string isValidatePhone];
    } else {
        return [string isValidateNumber];
    }
}




- (void)allDisabled
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
//    _loginButton.enabled = NO;
    _selectCountryView.userInteractionEnabled = NO;
//    _treatyButton.enabled = NO;
    _phoneView.userInteractionEnabled = NO;
}

- (void)allEnabled
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
//    _loginButton.enabled = YES;
    _selectCountryView.userInteractionEnabled = YES;
//    _treatyButton.enabled = YES;
    _phoneView.userInteractionEnabled = YES;
}

#pragma mark lazy 
-(UIButton *)loginBut{
    if (!_loginBut) {
        _loginBut = [createLbaelButView createButtonFrame:CGRectMake(332*WIDTHRation, 35.5*HeightRation, 28*WIDTHRation, 14*HeightRation) backImageName:nil title:TGLocalized(@"wallet_login") titleColor:HBColor(4, 159, 246) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] backColor:[UIColor clearColor]];
        [_loginBut addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginBut;
}
-(void)loginAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [createLbaelButView createLabelFrame:CGRectMake(30*WIDTHRation, 105*HeightRation, 120*WIDTHRation, 30*HeightRation) font:30 text:TGLocalized(@"Hb_QuickRegister") textColor:HBColor(78, 78, 78)];
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}
-(UIImageView *)tipImgView{
    if (!_tipImgView) {
        _tipImgView = [[UIImageView alloc]initWithFrame:CGRectMake(30*WIDTHRation, 145*HeightRation, 13*WIDTHRation, 13*WIDTHRation)];
        _tipImgView.image = [UIImage imageNamed:@"HBlogTips"];
        _tipImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tipImgView;
}
-(UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab =  [createLbaelButView createLabelFrame:CGRectMake(48*WIDTHRation, 144*HeightRation, 140*WIDTHRation, 14*HeightRation) font:14 text:TGLocalized(@"HBlogTips") textColor:HBColor(249, 136, 106)];
        _tipLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _tipLab.width = [_tipLab textWidthWithHeight:14*HeightRation];
        _tipLab.textAlignment = NSTextAlignmentLeft;
    }
    return _tipLab;
}

#pragma mark next register
-(void)nextClicked:(HBLoadButton *)btn{
    [self.view endEditing:YES];
    
    if ([_loadButton isLoading]) return;
    
    if ([self isValidatePhone:_phoneView.text]) {
        [_loadButton beginAnimation];
                [self riskVerfitry];
//        [self riskVerfitryVC];
        [self allDisabled];
    } else {
        NSLog(@"NO");
    }
}
//风控验证
- (void)riskVerfitry
{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"scene"] = @(Risk_Register);
    NSString * area = _country.area_code;
    NSString * loginname =[area stringByAppendingString:[NSString stringWithFormat:@"-%@",_phoneView.text]];
    parameters[@"login_name"] = loginname;
    parameters[@"source"] = @(Deveice_APP);
    parameters[@"fingerprint"] = [NSString deviceID];
    
    NSLog(@"%@",parameters);
    
    [HBHttpHelper riskControlWithParameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.riskModel = [HBRisk yy_modelWithJSON:responseObject];
        if ([self.riskModel.risk isEqualToString:@"0"]) {
            [self sendPhoneCode];
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
    //点击确定之后,直接发送手机验证码
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
    [_loadButton endAnimation];
    [self allEnabled];
    _imgCode = nil;
}

#pragma mark 阿里投篮验证
- (void)riskVerfitryVC
{
    NSString * langer = @"zh_CN";
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
    //启动验证（不依赖业务风险防控结果(此部分可能为自己服务器判断)，直接启动验证）
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [MSAuthVCFactory simapleVerifyWithType:MSAuthTypeSlide
                                                             language:langer
                                                             Delegate:self
                                                             authCode:@"0335"
                                                               appKey:nil];
        _nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:_nav animated:YES completion:nil];
    });
    
}
#pragma mark - 校验结果的回调
- (void)verifyDidFinishedWithResult:(t_verify_reuslt)code Error:(NSError *)error SessionId:(NSString *)sessionId  {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_nav dismissViewControllerAnimated:YES completion:nil];
        if (error) {
            _afs = nil;
            [self allEnabled];
            [_loadButton endAnimation];
            [MBProgressHUD showText:TGLocalized(@"trade_status_fail") toView:self.view];
        }else{
            _afs = [[NSMutableDictionary alloc]init];
            _afs[@"platform"] = @"2";
            [_afs setValue:sessionId forKey:@"session"];
            [self sendPhoneCode];
        }
    });
}



#pragma mark - 发送短信验证码
- (void)sendPhoneCode{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = _phoneView.text;
    parameters[@"country_code"] = _country.area_code;
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
//    WeakSelf(self);   
    [HBHttpHelper sendPhoneCodeWithParameters:parameters success:^(id responseObject) {
        [self sendCodeSuccess:responseObject];
    } failure:^(HBErrorModel *error) {
        [self sendCodeFailure:error];
    }];
}
- (void)sendCodeSuccess:(id)obj
{
    [self allEnabled];
    [_loadButton endAnimation];
    if (_codeView) {
        _codeView.hidden = YES;
        _codeView = nil;
        [_codeView removeFromSuperview];
    }
    _imgCode = nil;
    _sessionid = nil;
    //跳转到验证码输入页面
    HBMsgCodeAuthVC *codeVC = [[HBMsgCodeAuthVC alloc]init];
    codeVC.account = _phoneView.text;
    codeVC.countryCode = _country.area_code;
    [self.navigationController pushViewController:codeVC animated:YES];//短信验证
}

- (void)sendCodeFailure:(HBErrorModel *)error
{
    [self allEnabled];
    [_loadButton endAnimation];
    
    if (error.code == HBHttp_error_phone_existed) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:HBLocalizedString(@"register_phone_alert_msg") delegate:self cancelButtonTitle:nil otherButtonTitles:HBLocalizedString(@"register_alert_cancel"),HBLocalizedString(@"register_alert_other"), nil];
        [alertView show];
    } else if (error.code == HBHttp_error_img_code) {
        if (![_riskModel.risk isEqualToString:@"0"]
            &&![_riskModel.captcha_type isEqualToString:@"0"]) {
            [MBProgressHUD showText:error.message toView:self.view];
        }else{
            _codeView.hidden = YES;
            _codeView = nil;
            [HBHttpHelper GetIMgCodeWithSuccess:^(id responseObject) {
                [self codeViewInitWithImg:responseObject];
            } failure:^(HBErrorModel *error) {
                [MBProgressHUD showText:error.message toView:self.view];
            }];
        }
    }else if (error.code == HBHttpCode_networkError) {
        [MBProgressHUD showText:error.message toView:self.view];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.message delegate:nil cancelButtonTitle:HBLocalizedString(@"register_alert_cancel") otherButtonTitles:nil, nil];
        [alertView show];
    }
    if (!(error.code == HBHttp_error_img_code)) {
        if (_codeView) {
            _codeView.hidden = YES;
            _codeView = nil;
        }
        _imgCode = nil;
        _sessionid = nil;
    }
    [self.view endEditing:YES];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:HBNotify_login_account
//                                                            object:_phoneView.text];
//        [[UIApplication sharedApplication].keyWindow endEditing:YES];
//
//        NSArray *vcs = self.navigationController.viewControllers;
//        UIViewController *toVC = nil;
//        for (UIViewController *vc in vcs) {
//            if ([vc isKindOfClass:[HBLoginVC class]]) {
//                toVC = vc;
//                break;
//            }
//        }
//        if (toVC) {
//            [self.navigationController popToViewController:toVC animated:YES];
//        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
    }else{
        _phoneView.text = nil;
    }
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
