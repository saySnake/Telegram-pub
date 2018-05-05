//
//  HBPaymentViewController.m
//  Telegraph
//
//  Created by 段智林 on 2018/4/25.
//

#import "HBPaymentViewController.h"
#import "HBTextField.h"
#import "Masonry.h"
#import "HBPaymentTitleView.h"
#import "HBReceiptViewController.h"
#import "HBScanPayViewController.h"
#import "HBPayResultViewController.h"

@interface HBPaymentViewController ()
{
    HBPaymentTitleView *_titleView;
    UIView       *_paymentView;
    HBTextField  *_walletAddrField;
    HBTextField  *_numberField;
    HBTextField  *_payPasswordField;
    HBTextField  *_remarkField;
    UIButton     *_confirmBtn;

}
@end

@implementation HBPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden =YES;
}


- (void)loadView{
    [super loadView];
    BOOL  isIphoneX =[RTDeviceHardWare iPhoneXDevice];
    UIView *NavView =[[UIView alloc] init];
    NavView.backgroundColor =RGBACOLOR(204.0f, 204.0f, 204.0f, 1);
    [self.view addSubview:NavView];
//    HEIGHT_NAV_STATUS_BAR
    [NavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(HEIGHT_NAV_STATUS_BAR);
    }];
    
    UIButton *left =[UIButton buttonWithType:UIButtonTypeCustom];
    left.backgroundColor =[UIColor clearColor];
    [left setImage:[UIImage imageNamed:@"BtcLeft.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.bottom.mas_equalTo(NavView.bottom).offset(-12);
        make.width.height.mas_equalTo(20);
    }];
    
    
    UIButton *centBtn =[UIButton buttonWithType: UIButtonTypeCustom];
    [NavView addSubview:centBtn];
    centBtn.backgroundColor =[UIColor clearColor];
    [centBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [centBtn setTitle:@"付款BTC" forState:UIControlStateNormal];
    [centBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(NavView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.bottom.mas_equalTo(NavView.bottom).offset(-12);
    }];
    
    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [NavView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(NavView.bottom).offset(-12);
        make.size.mas_equalTo(CGSizeMake(25, 20));
        make.right.mas_equalTo(NavView.mas_right).offset(-12);
    }];
    [rightBtn setImage:[UIImage imageNamed:@"336.png"] forState:UIControlStateNormal];
    
    
//                      WithFrame:CGRectMake(0, 0, DScreenW, isIphoneX?88:64)];
    
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    if ([navBar respondsToSelector:@selector(setBarTintColor:)]) {
//        navBar.barTintColor = UIColorFromRGB(247, 247, 247);
//        navBar.shadowImage = nil;
//    }
//    navBar.barStyle = UIBarStyleBlackTranslucent;
//    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
//        [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsLandscapePhone];
//    }
////    self.navigationController.navigationBar.translucent = NO;
//
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,16,16)];
//    [rightButton setImage:[UIImage imageNamed:@"nav_btn_payment"]forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"nav_btn_payment"]forState:UIControlStateHighlighted];
//    [rightButton addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    _titleView= [HBPaymentTitleView defaultTitleView];
//    _titleView.payment = YES;
//    _titleView.title = @"付款BTC";
//    self.navigationItem.titleView = _titleView;
    
    _paymentView = [UIView new];
    _paymentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_paymentView];
    
    __weak HBPaymentViewController *weakSelf = self;
    [_paymentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(0.0f);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(HEIGHT_NAV_STATUS_BAR);
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.frame.size.width, SCREEN_HEIGHT - HEIGHT_NAV_STATUS_BAR));
    }];
    
    _walletAddrField = [[HBTextField alloc] init];
    _walletAddrField.placeholder =@"收款人钱包地址";
    _walletAddrField.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16.0f];
    _walletAddrField.textColor = UIColorFromRGB(142, 142, 147);
    _walletAddrField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _walletAddrField.borderStyle = UITextBorderStyleNone;
    _walletAddrField.textAlignment = NSTextAlignmentLeft;;
    _walletAddrField.returnKeyType = UIReturnKeyNext;
    _walletAddrField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _walletAddrField.autocorrectionType = UITextAutocorrectionTypeNo;
    _walletAddrField.backgroundColor = [UIColor clearColor];
    _walletAddrField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _walletAddrField.enablesReturnKeyAutomatically = YES;
    [_paymentView addSubview:_walletAddrField];
    [_walletAddrField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0f);
        make.top.mas_equalTo(_paymentView.mas_top).with.offset(0.0f);
        make.right.mas_equalTo(_paymentView.mas_right).with.offset(-20.0f);
        make.height.mas_equalTo(50.0f);
    }];

    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = UIColorFromRGB(225, 225, 225);
    [_paymentView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0f);
        make.right.mas_equalTo(_paymentView.mas_right).with.offset(-20.0f);
        make.top.mas_equalTo(_walletAddrField.mas_bottom).with.offset(0);
        make.height.mas_equalTo(1.0f);
    }];
    
    _numberField = [[HBTextField alloc] init];
    _numberField.placeholder =@"请输入收款币数";
    _numberField.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16.0f];
    _numberField.textColor = UIColorFromRGB(142, 142, 147);
    _numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _numberField.borderStyle = UITextBorderStyleNone;
    _numberField.textAlignment = NSTextAlignmentLeft;;
    _numberField.returnKeyType = UIReturnKeyNext;
    _numberField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _numberField.autocorrectionType = UITextAutocorrectionTypeNo;
    _numberField.backgroundColor = [UIColor clearColor];
    _numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _numberField.enablesReturnKeyAutomatically = YES;
    [_paymentView addSubview:_numberField];
    [_numberField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0f);
        make.right.mas_equalTo(_paymentView.mas_right).with.offset(-20.0f);
        make.top.mas_equalTo(line1.mas_bottom).with.offset(0.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    UILabel *line2 = [[UILabel alloc] init];
    line2.backgroundColor = UIColorFromRGB(225, 225, 225);
    [_paymentView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0f);
        make.right.mas_equalTo(_paymentView.mas_right).with.offset(-20.0f);
        make.top.mas_equalTo(_numberField.mas_bottom).with.offset(0);
        make.height.mas_equalTo(1.0f);
    }];
    
    _payPasswordField = [[HBTextField alloc] init];
    _payPasswordField.placeholder =@"请输入支付密码";
    _payPasswordField.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16.0f];
    _payPasswordField.textColor = UIColorFromRGB(142, 142, 147);
    _payPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _payPasswordField.borderStyle = UITextBorderStyleNone;
    _payPasswordField.textAlignment = NSTextAlignmentLeft;;
    _payPasswordField.returnKeyType = UIReturnKeyNext;
    _payPasswordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _payPasswordField.autocorrectionType = UITextAutocorrectionTypeNo;
    _payPasswordField.backgroundColor = [UIColor clearColor];
    _payPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _payPasswordField.enablesReturnKeyAutomatically = YES;
    [_paymentView addSubview:_payPasswordField];
    [_payPasswordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0f);
        make.right.mas_equalTo(_paymentView.mas_right).with.offset(-20.0f);
        make.top.mas_equalTo(line2.mas_bottom).with.offset(0);
        make.height.mas_equalTo(50.0f);
    }];
    
    UILabel *line3 = [[UILabel alloc] init];
    line3.backgroundColor = UIColorFromRGB(225, 225, 225);
    [_paymentView addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0f);
        make.right.mas_equalTo(_paymentView.mas_right).with.offset(-20.0f);
        make.top.mas_equalTo(_payPasswordField.mas_bottom).with.offset(0);
        make.height.mas_equalTo(1.0f);
    }];
    
    _remarkField = [[HBTextField alloc] init];
    _remarkField.placeholder =@"备注";
    _remarkField.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16.0f];
    _remarkField.textColor = UIColorFromRGB(142, 142, 147);
    _remarkField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _remarkField.borderStyle = UITextBorderStyleNone;
    _remarkField.textAlignment = NSTextAlignmentLeft;;
    _remarkField.returnKeyType = UIReturnKeyNext;
    _remarkField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _remarkField.autocorrectionType = UITextAutocorrectionTypeNo;
    _remarkField.backgroundColor = [UIColor clearColor];
    _remarkField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _remarkField.enablesReturnKeyAutomatically = YES;
    [_paymentView addSubview:_remarkField];
    [_remarkField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0f);
        make.right.mas_equalTo(_paymentView.mas_right).with.offset(-20.0f);
        make.top.mas_equalTo(line3.mas_bottom).with.offset(0.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    UILabel *line4 = [[UILabel alloc] init];
    line4.backgroundColor = UIColorFromRGB(225, 225, 225);
    [_paymentView addSubview:line4];
    
    [line4 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0f);
        make.right.mas_equalTo(_paymentView.mas_right).with.offset(-20.0f);
        make.top.mas_equalTo(_remarkField.mas_bottom).with.offset(0);
        make.height.mas_equalTo(1.0f);
    }];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn.layer setCornerRadius:6.0];
    [_confirmBtn setBackgroundColor:RGBACOLOR(250.0f, 255.0f, 0, 1)];
    [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 16.0f]];
    [_paymentView addSubview:_confirmBtn];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(_paymentView.mas_left).with.offset(20.0);
        make.top.mas_equalTo(line4.mas_bottom).with.offset(22.0f);
        make.right.mas_equalTo(_paymentView.mas_right).offset(-20.f);
        make.height.mas_equalTo(@44.0f);
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)clickRight
{
    HBScanPayViewController *scanPayVC = [[HBScanPayViewController alloc] init];
    [self.navigationController pushViewController:scanPayVC animated:YES];
}

-(void)confirm:(id)sender
{
    HBPayResultViewController *resultVC = [[HBPayResultViewController alloc] init];
    [self.navigationController pushViewController:resultVC animated:YES];
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
