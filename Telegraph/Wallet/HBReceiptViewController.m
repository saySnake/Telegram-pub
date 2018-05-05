//
//  HBPaymentViewController.m
//  Telegraph
//
//  Created by 段智林 on 2018/4/25.
//

#import "HBReceiptViewController.h"
#import "HBTextField.h"
#import "Masonry.h"
#import "HBPaymentTitleView.h"
#import "HBPaymentViewController.h"

@interface HBReceiptViewController ()
{
    HBPaymentTitleView    *_titleView;
    
    UIView       *receiptView;
    UILabel      *receiptTipLable;
    UIImageView  *receiptImageView;
    HBTextField  *receiptNumberField;
    UIButton     *copyBtn;
    UILabel      *receiptAddrLable;
    
}
@end

@implementation HBReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}
- (void)loadView{
    [super loadView];
    
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
//    self.navigationController.navigationBar.translucent = NO;
    
    
    
    UIView *NavView =[[UIView alloc] init];
    NavView.backgroundColor =UIColorFromRGB(204,204,204);
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
    
    [centBtn setTitle:@"收款BTC" forState:UIControlStateNormal];
    [centBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(NavView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.bottom.mas_equalTo(NavView.bottom).offset(-12);
    }];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    _titleView= [HBPaymentTitleView defaultTitleView];
//    _titleView.payment = YES;
//    _titleView.title = @"收款BTC";
//    self.navigationItem.titleView = _titleView;
    
    __weak HBReceiptViewController *weakSelf = self;
    
    receiptView = [UIView new];
    receiptView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:receiptView];
    [receiptView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(0.0f);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(HEIGHT_NAV_STATUS_BAR);
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.frame.size.width, SCREEN_HEIGHT - HEIGHT_NAV_STATUS_BAR));
    }];
    
    receiptTipLable = [[UILabel alloc] init];
    receiptTipLable.textAlignment = NSTextAlignmentCenter;
    receiptTipLable.backgroundColor = [UIColor clearColor];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"请将下方二维码或对应收款地址发送给付款方" attributes:@{
                                                                                                                                         NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 16.0f],
                                                                                                                                         NSForegroundColorAttributeName: [UIColor colorWithRed:135.0f / 255.0f green:142.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f]
                                                                                                                                         }];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:4.0f / 255.0f green:159.0f / 255.0f blue:246.0f / 255.0f alpha:1.0f] range:NSMakeRange(4, 3)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:4.0f / 255.0f green:159.0f / 255.0f blue:246.0f / 255.0f alpha:1.0f] range:NSMakeRange(10, 4)];
    
    [receiptTipLable setAttributedText:attributedString];
    [receiptView addSubview:receiptTipLable];
    
    [receiptTipLable mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(receiptView.mas_left).with.offset(10.0f);
        make.right.mas_equalTo(receiptView.mas_right).with.offset(-10.0f);
        make.top.mas_equalTo(receiptView.mas_top).with.offset(30.0f);
        make.height.equalTo(@20.0f);
    }];
    
    
    receiptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recepit_code"]];
    [receiptView addSubview:receiptImageView];
    [receiptImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_equalTo(receiptView);
        make.top.mas_equalTo(receiptTipLable.mas_bottom).with.offset(30.0f);
        make.size.mas_equalTo(CGSizeMake(130.0f, 130.0f));
    }];
    
    UIView *receiptNumberView = [UIView new];
    receiptNumberView.backgroundColor =UIColorFromRGB(247,247,247);
    [receiptView addSubview:receiptNumberView];
    [receiptNumberView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(receiptView.mas_left).with.offset(10.0f);
        make.right.mas_equalTo(receiptView.mas_right).with.offset(-10.0f);
        make.top.mas_equalTo(receiptImageView.mas_bottom).with.offset(30.0f);
        make.height.equalTo(@44.0f);
    }];
    
    receiptNumberField = [[HBTextField alloc] init];
    receiptNumberField.placeholder =@"设置收款币数";
    receiptNumberField.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16.0f];
    receiptNumberField.textColor = UIColorFromRGB(142, 142, 147);
    receiptNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    receiptNumberField.borderStyle = UITextBorderStyleNone;
    receiptNumberField.textAlignment = NSTextAlignmentLeft;;
    receiptNumberField.returnKeyType = UIReturnKeyDone;
    receiptNumberField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    receiptNumberField.autocorrectionType = UITextAutocorrectionTypeNo;
    receiptNumberField.backgroundColor = [UIColor clearColor];
    receiptNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    receiptNumberField.enablesReturnKeyAutomatically = YES;
    [receiptNumberView addSubview:receiptNumberField];
    [receiptNumberField mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_equalTo(receiptNumberView);
        make.centerY.mas_equalTo(receiptNumberView);
    }];
    
    UILabel *lineV = [[UILabel alloc] init];
    lineV.backgroundColor = UIColorFromRGB(135, 142, 152);
    [receiptNumberView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(receiptNumberField.mas_left).with.offset(-5.0f);
        make.top.mas_equalTo(receiptNumberView.mas_top).with.offset(4.0f);
        make.bottom.mas_equalTo(receiptNumberView.mas_bottom).with.offset(-4.0f);
        make.width.mas_equalTo(1.0f);
    }];
    
    copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn.layer setCornerRadius:6.0];
    [copyBtn setBackgroundColor:UIColorFromRGB(250, 225, 0)];
    [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [copyBtn setTitle:@"复制收款地址" forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyReceiptAddr:) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 16.0f]];
    [receiptView addSubview:copyBtn];
    
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(receiptView.mas_left).with.offset(20.0);
        make.top.mas_equalTo(receiptNumberView.mas_bottom).with.offset(22.0f);
        make.right.mas_equalTo(receiptView.mas_right).offset(-20.f);
        make.height.mas_equalTo(@44.0f);
    }];
    
    receiptAddrLable = [[UILabel alloc] init];
    receiptAddrLable.textAlignment = NSTextAlignmentCenter;
    receiptAddrLable.backgroundColor = [UIColor clearColor];
    receiptAddrLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
    receiptAddrLable.text = @"3oejopwgjo345j43o5j43k2j54o32543j25j43test";
    [receiptView addSubview:receiptAddrLable];
    [receiptAddrLable mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(receiptView.mas_left).with.offset(10.0f);
        make.right.mas_equalTo(receiptView.mas_right).with.offset(-10.0f);
        make.top.mas_equalTo(copyBtn.mas_bottom).with.offset(15.0f);
        make.height.mas_equalTo(@20.0f);
    }];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)copyReceiptAddr:(id)sender
{
    
}

-(void)clickRight
{
    HBPaymentViewController *paymentVC = [[HBPaymentViewController alloc] init];
    [self.navigationController pushViewController:paymentVC animated:YES];
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
