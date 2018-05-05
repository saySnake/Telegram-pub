//
//  HBSettingPwdVC.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/26.
//  HBChangePasswordVC

#import "HBSettingPwdVC.h"
#import "HBInputView.h"
#import "HBLoadButton.h"

@interface HBSettingPwdVC ()<HBInputViewDelegate>

@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UILabel *tipLab;
@property (nonatomic ,strong) HBInputView *pwdView;
@property (nonatomic ,strong) HBInputView *repeatPwdView;
@property (nonatomic ,strong) HBInputView *inviteView;
@property (nonatomic ,strong) UIButton *agreeBut;
@property (nonatomic ,strong) UILabel *agreeLab;
@property (nonatomic ,strong) UIButton *treatyButton;//协议
@property (nonatomic ,strong) HBLoadButton *loadButton;
@property (assign, nonatomic) BOOL  newp;
@property (assign, nonatomic) BOOL  againp;

@end

@implementation HBSettingPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}
-(void)setupUI{
    _titleLab = [createLbaelButView createLabelFrame:CGRectZero font:30 text:@"设置密码" textColor:HBColor(78, 78, 78)];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(30*WIDTHRation);
        make.top.mas_equalTo(self.view).offset(105*HeightRation);
        make.height.mas_equalTo(30*HeightRation);
    }];
    
    _tipLab = [createLbaelButView createLabelFrame:CGRectZero font:14 text:@"8-20个字符,不能是纯数字" textColor:HBColor(197, 207, 213)];
    _tipLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _tipLab.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:_tipLab];
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_left);
        make.top.equalTo(self.titleLab.mas_bottom).offset(9.5*HeightRation);
        make.height.mas_equalTo(14*HeightRation);
    }];
    
    //CGRectMake(30*WIDTHRation, 282.5*HeightRation, 315*WIDTHRation, 50)
    _pwdView = [[HBInputView alloc]initWithFrame:CGRectZero];
    _pwdView.tag = 0;
    _pwdView.delegate = self;
    _pwdView.type = InputViewType_pwd;
    _pwdView.lookNormalImage = @"invalidName";
    _pwdView.lookSelectImage = @"Invisible_black_selected";
    _pwdView.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdView.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _pwdView.textColor = HBColor(78, 78, 78);
    [_pwdView setTips:@"8-20个字符串,不能是纯数字"
            tipsColor:HBColor(255, 92, 92)];
    [_pwdView setPlaceholder:@"密码"
            placeholderColor:HBColor(197, 207, 213)
                    fontSize:16];
    [_pwdView setLineNormalColor:HBColor(244, 244, 244)
                       highColor:HBColor(72, 187, 252)];
    [self.view addSubview:_pwdView];
    //    _pwdView.tipsHidden = NO;
    [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_left);
        make.top.equalTo(self.view.mas_top).offset(209 *HeightRation);
        make.width.mas_equalTo(315*WIDTHRation);
        make.height.mas_equalTo(55*HeightRation);
    }];
    
    _repeatPwdView = [[HBInputView alloc]initWithFrame:CGRectZero];
    _repeatPwdView.tag = 1;
    _repeatPwdView.delegate = self;
    _repeatPwdView.type = InputViewType_pwd;
    _repeatPwdView.lookNormalImage = @"invalidName";
    _repeatPwdView.lookSelectImage = @"Invisible_black_selected";
    _repeatPwdView.keyboardType = UIKeyboardTypeASCIICapable;
    _repeatPwdView.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _repeatPwdView.textColor = HBColor(78, 78, 78);
    //    _repeatPwdView.tipsImage = @"correct";
    [_repeatPwdView setTips:@"与第一次密码不一致"
                  tipsColor:HBColor(255, 92, 92)];
    [_repeatPwdView setPlaceholder:@"再次输入密码"
                  placeholderColor:HBColor(197, 207, 213)
                          fontSize:16];
    [_repeatPwdView setLineNormalColor:HBColor(244, 244, 244)
                             highColor:HBColor(72, 187, 252)];
    [self.view addSubview:_repeatPwdView];
    [_repeatPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_left);
        make.top.equalTo(self.view.mas_top).offset(267 *HeightRation);
        make.width.mas_equalTo(315*WIDTHRation);
        make.height.mas_equalTo(55*HeightRation);
    }];
    
    
    _inviteView = [[HBInputView alloc]initWithFrame:CGRectZero];
    _inviteView.tag = 2;
    _inviteView.delegate = self;
    _inviteView.type = InputViewType_normal;
    _inviteView.keyboardType = UIKeyboardTypeASCIICapable;
    _inviteView.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _inviteView.textColor = HBColor(78, 78, 78);
//    [_inviteView setTips:TGLocalized(@"login_account_tips")
//              tipsColor:HBColor(255, 92, 92)];
    [_inviteView setPlaceholder:@"邀请码(选填)"
              placeholderColor:HBColor(197, 207, 213)
                      fontSize:16];
    [_inviteView setLineNormalColor:HBColor(244, 244, 244)
                         highColor:HBColor(21, 180, 241)];
    [self.view addSubview:_inviteView];
    [_inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_left);
        make.top.equalTo(self.view.mas_top).offset(324.5 *HeightRation);
        make.width.mas_equalTo(315*WIDTHRation);
        make.height.mas_equalTo(55*HeightRation);
    }];
    
    _agreeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeBut addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreeBut];
    [_agreeBut setImage:[UIImage imageNamed:@"disAgreeBtnImg"] forState:UIControlStateNormal];
    [_agreeBut setImage:[UIImage imageNamed:@"disAgreeBtnImg"] forState: UIControlStateHighlighted];
    [_agreeBut setImage:[UIImage imageNamed:@"agreeBtnImg"] forState:UIControlStateSelected];
    [_agreeBut setImage:[UIImage imageNamed:@"agreeBtnImg"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [_agreeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_left);
        make.top.equalTo(self.view.mas_top).offset(382.5 *HeightRation);
        make.width.mas_equalTo(15*WIDTHRation);
        make.height.mas_equalTo(15*HeightRation);
    }];
    
    _agreeLab = [createLbaelButView createLabelFrame:CGRectZero font:12 text:@"我同意" textColor:HBColor(140, 159, 173)];
    _agreeLab.textAlignment = NSTextAlignmentLeft;
    _agreeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.view addSubview:_agreeLab];
//    CGFloat labwidth = [_agreeLab textWidthWithHeight:12*HeightRation];
    [_agreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(54*WIDTHRation);
        make.centerY.equalTo(_agreeBut.mas_centerY);
//        make.width.mas_equalTo(labwidth);
        make.height.mas_equalTo(12*HeightRation);
    }];
    
    _treatyButton = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:@"使用条款" titleColor:HBColor(41, 174, 249) font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] backColor:[UIColor clearColor]];
    _treatyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_treatyButton addTarget:self action:@selector(treatyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_treatyButton];
    [_treatyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreeLab.mas_right).offset(5*WIDTHRation);
        make.centerY.equalTo(_agreeBut.mas_centerY);
        make.height.mas_equalTo(12*HeightRation);
    }];
    //CGRectMake(30*WIDTHRation, 427*HeightRation, 315*WIDTHRation, 44*HeightRation)
    _loadButton = [[HBLoadButton alloc]initWithFrame:CGRectMake(30*WIDTHRation, 427*HeightRation, 315*WIDTHRation, 44*HeightRation)];
    [_loadButton setTitle:@"注册"
                 forState:UIControlStateNormal];
    [_loadButton addTarget:self
                    action:@selector(loadButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadButton];
    _loadButton.enabled = NO;
//    [_loadButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(30*WIDTHRation);
//        make.top.equalTo(self.view.mas_top).offset(427 *HeightRation);
//        make.width.mas_equalTo(315*WIDTHRation);
//        make.height.mas_equalTo(44*HeightRation);
//    }];

}
#pragma mark - HBInputViewDelegate

- (void)inputView:(HBInputView *)inputView textFieldEditChangedAtText:(NSString *)text
{
    if (inputView.text.length > 20) {
        inputView.text = [inputView.text substringToIndex:20];
    }
    switch (inputView.tag) {
        case 0:
        {//_pwdView
            if (inputView.text.length>7) {
                if ([inputView.text pwdScore]) {
                    _newp =YES;
                    _pwdView.tipsImageHidden = NO;
                    _pwdView.tipsHidden = YES;
//                    _pwdView.tipsColor =HBColor_title;
                }else{
                    _newp= NO;
                     _pwdView.tipsImageHidden = YES;
                    _pwdView.tipsHidden = NO;
//                    _pwdView.tipsColor =[UIColor redColor];
                }
            }else{
                _newp= NO;
                _pwdView.tipsImageHidden = YES;
                _pwdView.tipsHidden = NO;
//                _pwdView.tipsColor =[UIColor redColor];
            }
            
            //返回编辑原始密码对repe的判断   _repeatPwdView
            if ([_pwdView.text isEqualToString:_repeatPwdView.text]) {
                _repeatPwdView.tipsHidden =YES;
                _repeatPwdView.tipsImageHidden = NO;
            }
            else{
                if (_repeatPwdView.text.length>0) {
                    _repeatPwdView.tipsHidden =NO;
                    _repeatPwdView.tipsImageHidden = YES;
                }else{
                    _repeatPwdView.tipsHidden =YES;
                    _repeatPwdView.tipsImageHidden = YES;
                }
            }
        }
            break;
        case 1:
        {// _repeatPwdView  tipsImageHidden
            if (inputView.text.length>7) {
                if ([inputView.text pwdScore]) {
                    if ([_repeatPwdView.text isEqualToString:_pwdView.text]) {
                         _repeatPwdView.tipsImageHidden = NO;
                        _againp =YES;
                    }
                    else{
                        _repeatPwdView.tipsImageHidden = YES;
                        _againp =NO;
                    }
                }else{
                    _repeatPwdView.tipsImageHidden = YES;
                    _againp =NO;
                }
            }else{
                _repeatPwdView.tipsImageHidden = YES;
                _againp =NO;
            }
            //_repeatPwdView  tipsHidden
            if ([_repeatPwdView.text isEqualToString:_pwdView.text]) {
                _repeatPwdView.tipsHidden =YES;
            }
            else if ([self alikeText1:_pwdView.text text2:_repeatPwdView.text]) {
                _repeatPwdView.tipsHidden = YES;
            }
            else{
                _repeatPwdView.tipsHidden =NO;
            }
        }
            break;
        default:
            break;
            
    }
    if (self.newp &&self.againp && _agreeBut.selected) {
        _loadButton.enabled = YES;
    }else{
        _loadButton.enabled = NO;
    }
}



- (BOOL)isPwdScore
{
    NSUInteger score = [_pwdView.text pwdScore];
    return score >= 4;
}

- (BOOL)alikeText1:(NSString *)text1 text2:(NSString *)text2
{
    NSRange range = [text1 rangeOfString:text2];
    if (range.location != NSNotFound) {
        if (range.location == 0 && range.length == text2.length) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

-(void)agreeAction:(UIButton *)button{
    button.selected = !button.selected;
//    if (button.selected && _pwdView.text.length > 0 && _repeatPwdView.text.length > 0) {
//        _loadButton.enabled = YES;
//    } else {
//        _loadButton.enabled = NO;
//    }
    
    if (self.newp &&self.againp && _agreeBut.selected) {
        _loadButton.enabled = YES;
    }else{
        _loadButton.enabled = NO;
    }
}
-(void)treatyButtonClicked:(UIButton *)button{
    NSLog(@"点击进入协议界面");
    [_loadButton endAnimation];
    [self allEnabled];
}
-(void)loadButtonClicked:(UIButton *)button{
    [self.view endEditing:YES];
    if (!_agreeBut.selected) return;
    if ([_loadButton isLoading]) return;
    [_loadButton beginAnimation];
    [self allDisabled];
    
    if (_repeatPwdView.text.length > 0 &&
        _pwdView.text.length > 0) {
        [self registerToHB];
    }
}
- (void)allDisabled
{
    _agreeBut.userInteractionEnabled = NO;
//    _treatyButton.enabled = NO;
    _pwdView.userInteractionEnabled = NO;
    _repeatPwdView.userInteractionEnabled = NO;
}
- (void)allEnabled
{
    _agreeBut.userInteractionEnabled = YES;
//     _treatyButton.enabled = YES;
    _pwdView.userInteractionEnabled = YES;
    _repeatPwdView.userInteractionEnabled = YES;
}
-(void)registerToHB{
    MBProgressHUD *hud = [MBProgressHUD showLoadingToView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"password"] = [_repeatPwdView.text appendPwd];
    parameters[@"country_code"] = _countryCode;
    parameters[@"phone"] = _account;
    parameters[@"auth_code"] =_code;
    parameters[@"password_level"] = @([_repeatPwdView.text pwdScore]);
    parameters[@"authCode"] = _captcha;
    
    [HBHttpHelper registWithParameters:parameters success:^(id responseObject) {
        NSLog(@"login   ========== %@",responseObject);
        //========== {
//        uid = 39735383;
//    }
        [hud hide:YES];
        [self registSuccess];
    } failure:^(HBErrorModel *error) {
        [hud hide:YES];
        [self registFailure:error];
    }];
}

- (void)registSuccess
{
    [self allEnabled];
    [_loadButton endAnimation];
    [MBProgressHUD showText:@"注册成功" toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(KHUDDelay * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
//                       NSArray *vcs = self.navigationController.viewControllers;
//                       UIViewController *popVC = nil;
//                       for (UIViewController *vc in vcs) {
//                           if ([vc isKindOfClass:[HBLoginVC class]]) {
//                               popVC = vc;
//                               break;
//                           }
//                       }
//                       if (popVC) {
//                           [self.navigationController popToViewController:popVC animated:YES];
//                       } else {
//                           [self.navigationController popToRootViewControllerAnimated:YES];
//                       }
                       [self.navigationController popToRootViewControllerAnimated:YES];

                   });
}

- (void)registFailure:(HBErrorModel *)error
{
    [self allEnabled];
    [_loadButton endAnimation];
    NSLog(@"%@", error.message);
    [MBProgressHUD showText:error.message toView:self.view];
//    if (error.code == HBHttp_error_register_captcha) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
//                                     (int64_t)(KHUDDelay * NSEC_PER_SEC)),
//                       dispatch_get_main_queue(), ^{
//                           [self authCodeError];
//                       });
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)inputView:(HBInputView *)inputView textFieldEditChangedAtText:(NSString *)text
//{
//    if (_pwdView.text.length > 0 && _repeatPwdView.text.length > 0  && _agreeBut.selected) {
//        _loadButton.enabled = YES;
//    } else {
//        _loadButton.enabled = NO;
//    }
//
//    if (inputView.tag == 0) {
//        if ([self isPwdScore]) {
//            _pwdView.tipsImageHidden = NO;
//            [_pwdView setTips:@"8-20位字符，包含数字字母"
//                    tipsColor:HBColor(255, 92, 92)];
//        } else {
//            [_pwdView setTips:@"8-20位字符，包含数字字母"
//                    tipsColor:HBColor(255, 92, 92)];
//            _pwdView.tipsImageHidden = YES;
//        }
//    } else if (_repeatPwdView.text.length > 0) {
//        if ([_pwdView.text isEqualToString:_repeatPwdView.text]) {
//            _repeatPwdView.tipsHidden = YES;
//            _repeatPwdView.tipsImageHidden = NO;
//        } else if ([self alikeText1:_pwdView.text text2:_repeatPwdView.text]) {
//            _repeatPwdView.tipsHidden = YES;
//            _repeatPwdView.tipsImageHidden = YES;
//        } else {
//            _repeatPwdView.tipsHidden = NO;
//            _repeatPwdView.tipsImageHidden = YES;
//        }
//    } else {
//        _repeatPwdView.tipsHidden = YES;
//        _repeatPwdView.tipsImageHidden = YES;
//    }
//
////    if (inputView.tag == 2) {
////        if (inputView.text.length == 0) {
////            _inviteView.tipsHidden = NO;
////            [_inviteView setTips:HBLocalizedString(@"fund_setting_pwd_tips")
////                             tipsColor:HBColor_title];
////        }
////    }
//}

//- (void)inputView:(HBInputView *)inputView textFieldShouldBeginEditAtText:(NSString *)text
//{
//    if (_pwdView.text.length > 0 && _repeatPwdView.text.length > 0 &&_agreeBut.selected) {
//        _loadButton.enabled = YES;
//    } else {
//        _loadButton.enabled = NO;
//    }
//}
//
//- (void)inputView:(HBInputView *)inputView textFieldShouldEndEditAtText:(NSString *)text
//{
//    if (_pwdView.text.length > 0 && _repeatPwdView.text.length > 0  &&_agreeBut.selected) {
//        _loadButton.enabled = YES;
//    } else {
//        _loadButton.enabled = NO;
//    }
//
//    if (inputView.tag == 0) {
//        if ([self isPwdScore]) {
//            _pwdView.tipsImageHidden = NO;
//            [_pwdView setTips:@"8-20位字符，包含数字字母"
//                    tipsColor:HBColor(255, 92, 92)];
//        } else {
//            [_pwdView setTips:@"8-20位字符，包含数字字母"
//                    tipsColor:HBColor(255, 92, 92)];
//            _pwdView.tipsImageHidden = YES;
//        }
//    } else if (inputView.tag == 1) {
//        if (_repeatPwdView.text.length > 0) {
//            if ([_pwdView.text isEqualToString:_repeatPwdView.text]) {
//                _repeatPwdView.tipsHidden = YES;
//                _repeatPwdView.tipsImageHidden = NO;
//            } else {
//                _repeatPwdView.tipsHidden = NO;
//                _repeatPwdView.tipsImageHidden = YES;
//            }
//        } else {
//            _repeatPwdView.tipsHidden = YES;
//            _repeatPwdView.tipsImageHidden = YES;
//        }
//    }
////    else if (inputView.tag == 2) {
////        if ([_pwdTipsTextField.text isEqualToString:_pwdView.text]) {
////            _pwdTipsTextField.tipsHidden = NO;
////            [_pwdTipsTextField setTips:HBLocalizedString(@"me_sessage_remarktips")
////                             tipsColor:HBColor_error];
////        } else if (_pwdTipsTextField.text.length > 50) {
////            _pwdTipsTextField.tipsHidden = NO;
////            [_pwdTipsTextField setTips:HBLocalizedString(@"login_pwd_error_tips")
////                             tipsColor:HBColor_error];
////        } else {
////            _pwdTipsTextField.tipsHidden = NO;
////            [_pwdTipsTextField setTips:HBLocalizedString(@"fund_setting_pwd_tips")
////                             tipsColor:HBColor_title];
////        }
////    }
//}

//- (BOOL)inputView:(HBInputView *)inputView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (inputView.tag == 2) {
//        if (inputView.text.length > 50) {
//            return NO;
//        } else {
//            return YES;
//        }
//    } else {
//        return YES;
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
