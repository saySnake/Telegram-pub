//
//  HBResetPawVC.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/25.
//

#import "HBResetPawVC.h"
#import "HBInputView.h"
#import "HBLoadButton.h"
@interface HBResetPawVC ()<HBInputViewDelegate>
@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UILabel *tipLab;
@property (nonatomic ,strong) HBInputView *pwdView;
@property (nonatomic ,strong) HBInputView *repeatPwdView;
@property (nonatomic ,strong) HBLoadButton *loadButton;
//@property (nonatomic ,strong)UIButton *resetBut;
@property (nonatomic ,strong)UIImageView *btnImgView;//按钮上的图片

@property (assign, nonatomic) BOOL  newp;
@property (assign, nonatomic) BOOL  againp;

@end

@implementation HBResetPawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}
-(void)setupUI{
    //test
//    UIButton *testBut = [UIButton buttonWithType:UIButtonTypeCustom];
//    testBut.backgroundColor = [UIColor redColor];
//    testBut.frame = CGRectMake(0, 100, 100, 100);
//    [testBut addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:testBut];
 
    _titleLab = [createLbaelButView createLabelFrame:CGRectZero font:30 text:@"重置密码" textColor:HBColor(78, 78, 78)];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:30];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(30*WIDTHRation);
        make.top.mas_equalTo(self.view).offset(104*HeightRation);
        make.height.mas_equalTo(30*HeightRation);
    }];
    
    _tipLab = [createLbaelButView createLabelFrame:CGRectZero font:14 text:@"8-20个字符,不能是纯数字" textColor:HBColor(140, 159, 173)];
    _tipLab.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    _tipLab.textAlignment =NSTextAlignmentLeft;
    [self.view addSubview:_tipLab];
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(HEADER_ICON_LEFT_OFFSET);
//        make.width.height.mas_equalTo(HEADER_ICON_SIZE);
//        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLab.mas_left);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10.5*HeightRation);
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
    [_pwdView setPlaceholder:@"输入密码"
            placeholderColor:HBColor(197, 207, 213)
                    fontSize:16];
    [_pwdView setLineNormalColor:HBColor(244, 244, 244)
                       highColor:HBColor(72, 187, 252)];
    [self.view addSubview:_pwdView];
//    _pwdView.tipsHidden = NO;
    [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_left);
        make.top.equalTo(self.view.mas_top).offset(208 *HeightRation);
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
        make.top.equalTo(self.view.mas_top).offset(256 *HeightRation);
        make.width.mas_equalTo(315*WIDTHRation);
        make.height.mas_equalTo(55*HeightRation);
    }];
    
//    _resetBut = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:@"重置" titleColor:HBColor(255, 255, 255) font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] backColor:[UIColor clearColor]];
//    [_resetBut setBackgroundImage:[UIImage imageWithColor:HBColor(21, 180, 241)]
//                    forState:UIControlStateNormal];
//    [_resetBut setBackgroundImage:[UIImage imageWithColor:HBColor(27, 153, 202)]
//                    forState:UIControlStateHighlighted];
//    [_resetBut setBackgroundImage:[UIImage imageWithColor:HBColor_alpha(40, 168, 240, 0.4)]
//                    forState:UIControlStateDisabled];
//    [_resetBut addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
//    _resetBut.enabled = NO;
//    [self.view addSubview:_resetBut];
//    [_resetBut mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLab.mas_left);
//        make.top.equalTo(self.view.mas_top).offset(323 *HeightRation);
//        make.width.mas_equalTo(315*WIDTHRation);
//        make.height.mas_equalTo(44*HeightRation);
//    }];
    
    _loadButton = [[HBLoadButton alloc]initWithFrame:CGRectMake(30*WIDTHRation, 323 *HeightRation, 315*WIDTHRation, 44*HeightRation)];
    [_loadButton setTitle:@"重置"
                 forState:UIControlStateNormal];
    [_loadButton addTarget:self
                    action:@selector(loadButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadButton];
    _loadButton.enabled = NO;
    
    _btnImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"whiteCorrect"]];
     _btnImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_loadButton addSubview:_btnImgView];
    _btnImgView.hidden = YES;
    [_btnImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_loadButton);
        make.width.mas_equalTo(16.5*WIDTHRation);
        make.height.mas_equalTo(13*HeightRation);
    }];
    
}
-(void)loadButtonClicked:(UIButton *)btn{
    [self.view endEditing:YES];
    if ([_loadButton isLoading]) return;
    
    [_loadButton beginAnimation];
    [self allDisabled];
    
    if (_repeatPwdView.text.length > 0 &&
        _pwdView.text.length > 0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic[@"reset_token"] = _reset_token;
        dic[@"password"] = [_pwdView.text appendPwd];
        dic[@"password_level"] = @([_pwdView.text pwdScore]);
        MBProgressHUD *hud = [MBProgressHUD showLoadingToView:self.view];
        [HBHttpHelper resetPasswordtWithParameters:dic success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            [hud hideHUD:YES];
            [MBProgressHUD showSuccess:@"更改密码成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } failure:^(HBErrorModel *error) {
            [hud hideHUD:YES];
            [MBProgressHUD showText:error.message toView:self.view];
        }];
    }
}
//-(void)testAction:(UIButton *)but{
//    [_loadButton endAnimation];
//    [self allEnabled];
//    [_loadButton setTitle:@""
//                 forState:UIControlStateNormal];
//    _btnImgView.hidden = NO;
//}
- (void)allDisabled
{
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    _pwdView.userInteractionEnabled = NO;
    _repeatPwdView.userInteractionEnabled = NO;
}
- (void)allEnabled
{
//    self.navigationItem.rightBarButtonItem.enabled = YES;
    _pwdView.userInteractionEnabled = YES;
    _repeatPwdView.userInteractionEnabled = YES;
}

#pragma mark - HBInputViewDelegate
- (void)inputView:(HBInputView *)inputView textFieldEditChangedAtText:(NSString *)text
{
    if (inputView.text.length > 20) {
        inputView.text = [inputView.text substringToIndex:20];
    }
    switch (inputView.tag) {
        case 0:
        {
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
            
            //返回编辑原始密码对repe的判断
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
        {
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
            //_repeatPwdView hidden
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
    if (self.newp &&self.againp) {
        _loadButton.enabled = YES;
//        _resetBut.enabled = YES;
    }else{
        _loadButton.enabled = NO;
//        _resetBut.enabled = NO;
    }
}

////改变
//- (void)inputView:(HBInputView *)inputView textFieldEditChangedAtText:(NSString *)text
//{
//    
////    if (_pwdView.text.length > 0 && _repeatPwdView.text.length > 0) {
////        _loadButton.enabled = YES;
////    } else {
////        _loadButton.enabled = NO;
////    }
//    
//    if (inputView.tag == 0) {
//        if ([self isPwdScore]) {
//            _pwdView.tipsImageHidden = NO;
//            [_pwdView setTips:@"8-20位字符，包含数字字母"
//                    tipsColor:HBColor(255, 92, 92)];
//            _pwdView.tipsHidden = YES;
//            
//        } else {
//            [_pwdView setTips:@"8-20位字符，包含数字字母"
//                    tipsColor:HBColor(255, 92, 92)];
//            _pwdView.tipsImageHidden = YES;
//            _pwdView.tipsHidden = NO;
//        }
//        //用于再次输入完密码后,回来对第一个view进行更改,相同则打开交互,不同则关闭
//        if ([_pwdView.text isEqualToString:_repeatPwdView.text]&& _repeatPwdView.text.length > 0) {
//            _repeatPwdView.tipsHidden = YES;
//            _repeatPwdView.tipsImageHidden = NO;
//            
//            _resetBut.enabled = YES;
//            //            _resetBut.titleLabel.hidden = YES;
////            [_resetBut setTitle:@"" forState:UIControlStateNormal];
////            _btnImgView.hidden = NO;
//        }else{
//            //根据rep长度来 来显示
//            if (_repeatPwdView.text.length > 0 ) {
//                _repeatPwdView.tipsHidden = NO;
//                _repeatPwdView.tipsImageHidden = YES;
//            }
//            
//            //返回编辑的 重新设置_resert状态
//            _resetBut.enabled = NO;
////            [_resetBut setTitle:@"重置" forState:UIControlStateNormal];
////            _btnImgView.hidden = YES;
//        }
//        
//    } else if (_repeatPwdView.text.length > 0) {
//        if ([_pwdView.text isEqualToString:_repeatPwdView.text]) {
//            _repeatPwdView.tipsHidden = YES;
//            _repeatPwdView.tipsImageHidden = NO;
//            
//            _resetBut.enabled = YES;
////            [_resetBut setTitle:@"" forState:UIControlStateNormal];
////            _btnImgView.hidden = NO;
//        } else if ([self alikeText1:_pwdView.text text2:_repeatPwdView.text]) {
//            _repeatPwdView.tipsHidden = YES;
//            _repeatPwdView.tipsImageHidden = YES;
//            
//            _resetBut.enabled = NO;
////            [_resetBut setTitle:@"重置" forState:UIControlStateNormal];
////            _btnImgView.hidden = YES;
//        } else {
//            _repeatPwdView.tipsHidden = NO;
//            _repeatPwdView.tipsImageHidden = YES;
//            
//            _resetBut.enabled = NO;
////            [_resetBut setTitle:@"重置" forState:UIControlStateNormal];
////            _btnImgView.hidden = YES;
//        }
//    } else {
//        _repeatPwdView.tipsHidden = YES;
//        _repeatPwdView.tipsImageHidden = YES;
//    }
//}
////开始编辑
//- (void)inputView:(HBInputView *)inputView textFieldShouldBeginEditAtText:(NSString *)text
//{
//    
//    
////    if (_pwdView.text.length > 0 && _repeatPwdView.text.length > 0) {
////        _loadButton.enabled = YES;
////    } else {
////        _loadButton.enabled = NO;
////    }
//}
////  点击另外一个input input 指的结束的那个
//- (void)inputView:(HBInputView *)inputView textFieldShouldEndEditAtText:(NSString *)text
//{
////    if (_pwdView.text.length > 0 && _repeatPwdView.text.length > 0) {
////        _loadButton.enabled = YES;
////    } else {
////        _loadButton.enabled = NO;
////    }
//    NSLog(@"%ld",inputView.tag);
//    if (inputView.tag == 0) {
//        if ([self isPwdScore]) {
//            _pwdView.tipsImageHidden = NO;
//            [_pwdView setTips:@"8-20位字符，包含数字字母"
//                    tipsColor:HBColor(255, 92, 92)];
//            _pwdView.tipsHidden = YES;
//        } else {
//            [_pwdView setTips:@"8-20位字符，包含数字字母"
//                    tipsColor:HBColor(255, 92, 92)];
//            _pwdView.tipsImageHidden = YES;
//            _pwdView.tipsHidden = NO;
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
//}
//
//- (BOOL)inputView:(HBInputView *)inputView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//        return YES;
//}
- (BOOL)isPwdScore
{
    NSUInteger score = [_pwdView.text pwdScore];
    return score >= 4;
}
- (BOOL)alikeText1:(NSString *)text1 text2:(NSString *)text2
{   //在text1 中搜索 有没有 text2
    NSRange range = [text1 rangeOfString:text2];
    if (range.location != NSNotFound) {
        //
        if (range.location == 0 && range.length == text2.length) {
            return YES;
        } else {
            return NO;
        }
    } else {
        //没有返回no
        return NO;
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
