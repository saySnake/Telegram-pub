//
//  HBFindPwdVC.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/27.
//

#import "HBFindPwdVC.h"
#import "HBInputView.h"
#import "HBLoadButton.h"
#import "CodeAuthView.h"
#import "HBRisk.h"
#import <MSAuthSDK/MSAuthVCFactory.h>
#import "HBSetAccountModel.h"
#import "HBResetPawVC.h"
@interface HBFindPwdVC ()<HBInputViewDelegate,codeAuthViewDelegate,MSAuthProtocol>

@property (nonatomic ,strong) UIButton *cancelBut;
@property (nonatomic ,strong) UILabel *findPwdLab;
@property (nonatomic ,strong) HBInputView *phoneView;
@property (nonatomic ,strong) HBLoadButton *loadButton;
@property (nonatomic ,strong) CodeAuthView *codeView;
@property (nonatomic, strong) HBRisk   *riskModel;//风控
@property (nonatomic, copy) NSString                    *sessionid;
@property (nonatomic, copy) NSString                    *imgCode;
@property (nonatomic ,strong)UINavigationController     *nav;
@property (nonatomic, strong)NSMutableDictionary        *afs;
@property (strong, nonatomic) HBSetAccountModel *model;


@end

@implementation HBFindPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatSubViews];
}
-(void)creatSubViews{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cancelBut = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:@"取消" titleColor:HBColor(197, 207, 213) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] backColor:[UIColor clearColor]];
    [_cancelBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBut];
    [_cancelBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(35.5*HeightRation);
        make.left.mas_equalTo(self.view.mas_left).offset(15*WIDTHRation);
        make.height.mas_equalTo(20*HeightRation);
    }];
    
    _findPwdLab = [createLbaelButView createLabelFrame:CGRectZero font:30 text:@"找回密码" textColor:HBColor(78, 78, 78)];
    _findPwdLab.textAlignment = NSTextAlignmentLeft;
    _findPwdLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
    [self.view addSubview:_findPwdLab];
    [_findPwdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(105*HeightRation);
        make.left.mas_equalTo(self.view.mas_left).offset(30*WIDTHRation);
        make.height.mas_equalTo(30*HeightRation);
    }];
    
    _phoneView = [[HBInputView alloc]initWithFrame:CGRectZero];
    _phoneView.tag = 0;
    _phoneView.delegate = self;
    _phoneView.type = InputViewType_normal;
    _phoneView.keyboardType = UIKeyboardTypePhonePad;
    _phoneView.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _phoneView.textColor = HBColor(78, 78, 78);
    //TGLocalized(@"login_account_tips")
    [_phoneView setTips:@"请输入正确的账号格式"
              tipsColor:HBColor(255, 92, 92)];
    //TGLocalized(@"login_account_hint")
    [_phoneView setPlaceholder:@"手机号码"
              placeholderColor:HBColor(197, 207, 213)
                      fontSize:16];
    [_phoneView setLineNormalColor:HBColor(244, 244, 244)
                         highColor:HBColor(21, 180, 241)];
    [self.view addSubview:_phoneView];
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_findPwdLab.mas_left);
        make.top.equalTo(self.view.mas_top).offset(184.5 *HeightRation);
        make.width.mas_equalTo(315*WIDTHRation);
        make.height.mas_equalTo(55*HeightRation);
    }];
    
    _loadButton = [[HBLoadButton alloc]initWithFrame:CGRectMake(30*WIDTHRation, 241.5*HeightRation, 315*WIDTHRation, 44*HeightRation)];
    [_loadButton setTitle:@"下一步"
                 forState:UIControlStateNormal];
    [_loadButton addTarget:self
                    action:@selector(loadButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadButton];
    _loadButton.enabled = NO;
    
}
#pragma mark - HBInputViewDelegate
- (void)inputView:(HBInputView *)inputView textFieldEditChangedAtText:(NSString *)text
{
    if (inputView.tag == 0) {
        if (inputView.text.length == 0) {
            inputView.tipsHidden = NO;
        } else if ([self isValidateAccount:inputView.text]) {//判断账号
            inputView.tipsHidden = YES;
        } else {
            inputView.tipsHidden = NO;
        }
        if ([inputView.text isValidateNumber]){
            if (inputView.text.length > 11) {
                inputView.text = [inputView.text substringToIndex:11];
                inputView.tipsHidden = YES;
            }
        }
    }
    if ([self isValidateAccount:_phoneView.text]) {
        _loadButton.enabled = YES;
    } else {
        _loadButton.enabled = NO;
    }

}
#pragma mark - 账号
- (BOOL)isValidateAccount:(NSString *)text
{
    if ([text isValidateNumber]&&text.length<12&&text.length>4){
        return YES;
    } else {
        if ([text isValidateEmail]){
            return YES;
        }else{
            return NO;
        }
    }
}
-(void)loadButtonClicked:(HBLoadButton *)btn{
//    [_phoneView resignFirstResponder];
//    _phoneView.becomeFirstResponder = NO;
//    _phoneView.changeToResignFirstResponder = YES;
    _phoneView.becomeResignFirstResponder = YES;

//    _codeView = [[CodeAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithIsImage:NO];
//    _codeView.delegate = self;
//    [self.view addSubview:_codeView];
//    [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:@"17600103768" WithImage:nil];
//    [UIView animateWithDuration:.5 animations:^{
//        _codeView.hidden = NO;
//    }];
    
    [self.view endEditing:YES];
    
    if ([btn isLoading]) return;
    
    if ([_phoneView.text isValidatePhone]) {
        [_loadButton beginAnimation];
        [self riskVerfitry];
        [self allDisabled];
    }
    
}

#pragma mark - 阿里图片验证
- (void)riskVerfitry
{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"scene"] = @(Risk_FindPassWord);
    parameters[@"login_name"] = _phoneView.text;
    parameters[@"source"] = @(Deveice_APP);
    parameters[@"fingerprint"] = [NSString deviceID];
    NSLog(@"%@",parameters);
    
    [HBHttpHelper riskControlWithParameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.riskModel = [HBRisk yy_modelWithJSON:responseObject];
        if ([self.riskModel.risk isEqualToString:@"0"]) {
                [self resetVerifyCode];
        }else{
            if ([self.riskModel.captcha_type isEqualToString:@"0"]) {
                //                [_alertView clean];
                //                WeakSelf(self)
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
    //暂时注释掉  因 首次图片验证 与 之后  修改密码钱的二次验证冲突  ,之后会用blcok解决这个问题
//    _imgCode = codeStr;
//    [self resetVerifyCode];
//    NSLog(@"codestr--------%@",codeStr);
    
    //弹窗输入完成之后 进行接口验证,来判断是否进入设置密码页面
    [self resetVerifySafeActionWithcodeString:codeStr];
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
            [self resetVerifyCode];
        }
    });
}
//调用重置密码验证接口
-(void)resetVerifyCode{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    dic[@"account_name"] = _phoneView.text;
    if (_imgCode.length > 0) {
        dic[@"captcha_code"] = _imgCode;
    }
    if (_sessionid.length > 0) {
        dic[@"captcha_key"] = _sessionid;
    }
    if (_afs.count > 0) {
        [dic setValue:_afs forKey:@"afs"];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showLoadingToView:self.view];
    
    [HBHttpHelper resetVerifyCodeWithParameters:dic success:^(id responseObject) {
       [hud hideHUD:YES];

        //根据返回的 HBSetAccountModel 来显示对应的view
        [self resetVerifySuccess:responseObject];;
    } failure:^(HBErrorModel *error) {
        [hud hideHUD:YES];
        [self resetVerifyFailure:error];
    }];
}
- (void)resetVerifySuccess:(id)obj
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
    //根据model的值,来弹出对应的弹窗
    /*
     data : {
     "account_name" = 17600103768;
     email = "";
     phone = "176****3768";
     token = 34ec5bcdcdfa46debcf609a9fe3f0be4;
     "verify_email" = 0;
     "verify_ga" = 1;
     "verify_phone" = 1;
     },
     */
    NSLog(@"%@",obj);
    self.model = [HBSetAccountModel yy_modelWithDictionary:obj];
    //_model.verify_phone.boolValue  为1 就,请求发送手机验证码的接口;在接口请求成功后,根据model的别的值显示对应的codeview
    if (_model.verify_phone.boolValue) {
        //请求发送手机接口
        MBProgressHUD * hud = [MBProgressHUD  showLoadingToView:self.view];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"account_name"] =_model.account_name;
        parameters[@"use_type"] = RESET_PASSWORD;
        parameters[@"token"] = _model.token;
        [parameters setObject:[NSNumber numberWithBool:false] forKey:@"voice"];
        [HBHttpHelper sendPhoneCodeWithParameters:parameters success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"发送手机验证码成功,根据model弹出对应的视图");
           [hud hideHUD:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_model.verify_phone.boolValue && _model.verify_ga.boolValue) {
                    //弹出 手机和 google验证视图
                }else{
                    //仅仅为手机
                    if (_model.verify_phone.boolValue) {
                        _codeView = [[CodeAuthView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithIsImage:NO];
                        _codeView.delegate = self;
                        [self.view addSubview:_codeView];
                        //                    [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:nil WithImage:img];
                        //    [_codeView setPhoneAndGoogleWithISgoogle:YES WithPhoneString:nil WithImage:nil];
                        [_codeView setPhoneAndGoogleWithISgoogle:NO WithPhoneString:_model.account_name WithImage:nil];
                        [UIView animateWithDuration:.5 animations:^{
                            _codeView.hidden = NO;
                        }];
                        //在代理方法中点击输入验证码后进行接口验证,成功则跳转到设置密码页面
                    }
                    //仅仅为google
                    if (_model.verify_ga.boolValue) {
                        
                    }
                }
            });
            

            
        } failure:^(HBErrorModel *error) {
            
            [hud hideHUD:YES];
            [MBProgressHUD showText:error.message toView:self.view];
            
        }];
    }
}
- (void)resetVerifyFailure:(HBErrorModel *)error
{
    [self allEnabled];
    [_loadButton endAnimation];
    
     if (error.code == HBHttp_error_img_code) {
        if (![_riskModel.risk isEqualToString:@"0"]
            &&![_riskModel.captcha_type isEqualToString:@"0"]) {
            [MBProgressHUD showText:error.message toView:self.view];
        }else{
            if (_codeView) {
                _codeView.hidden = YES;
                _codeView = nil;
                [_codeView removeFromSuperview];
            }
            [HBHttpHelper GetIMgCodeWithSuccess:^(id responseObject) {
                [self codeViewInitWithImg:responseObject];
            } failure:^(HBErrorModel *error) {
                [MBProgressHUD showText:error.message toView:self.view];
            }];
        }
    }else {
        if (_codeView) {
            _codeView.hidden = YES;
            _codeView = nil;
            [_codeView removeFromSuperview];
        }
        _imgCode = nil;
        _sessionid = nil;
        [MBProgressHUD showText:error.message toView:self.view];
    }
}

-(void)resetVerifySafeActionWithcodeString:(NSString *)string {
    //目前仅仅支持一个弹窗验证
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"account_name"] = _model.account_name;
    dic[@"sms_code"] = string;
//    if (_gaView.text.length>0) {
//        dic[@"ga_code"] = _gaView.text;
//    }
//    if (_phoneView.text.length>0) {
//        dic[@"sms_code"] = _phoneView.text;
//    }
//    if (_emailView.text.length>0) {
//        dic[@"email_code"] = _emailView.text;
//    }
    dic[@"token"] = _model.token;
    MBProgressHUD *hud =[MBProgressHUD showLoadingToView:self.view];
    [HBHttpHelper resetVerifySafeAccountWithParameters:dic success:^(id responseObject) {
        [hud hideHUD:YES];
        NSLog(@"%@",responseObject);
        //"reset_token" = 9c36d1c5214b4da483a17e893e0f2671;
        //进入设置密码页面
        HBResetPawVC *resetPwdVC = [[HBResetPawVC alloc]init];
        resetPwdVC.reset_token =responseObject[@"reset_token"];
        [self.navigationController pushViewController:resetPwdVC animated:YES];
    } failure:^(HBErrorModel *error) {
        
        [hud hideHUD:YES];
        [MBProgressHUD showText:error.message toView:self.view];
    }];
//    [HBAccountHttpTool resetVerifySafeAccountWithParameters:dic success:^(id obj) {
//        [hud hideHUD:YES];
//        HBResetPasswordVC * VC = [UIStoryboard storyboardWithName:@"Safe" identifier:@"HBResetPasswordVC"];
//        VC.reset_token =obj[@"reset_token"];
//        [self.navigationController pushViewController:VC animated:YES];
//
//    } failure:^(HBErrorModel *error) {
//        [hud hideHUD:YES];
//        [MBProgressHUD showText:error.message toView:self.view];
//    }];
}

- (void)allDisabled
{
   _cancelBut.userInteractionEnabled = NO;
    _phoneView.userInteractionEnabled = NO;
}

- (void)allEnabled
{
    _cancelBut.userInteractionEnabled = YES;
    _phoneView.userInteractionEnabled = YES;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
