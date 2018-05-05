//
//  HBPayResultViewController.m
//  Telegraph
//
//  Created by 段智林 on 2018/4/25.
//

#import "HBPayResultViewController.h"

@interface HBPayResultViewController ()
{
    UIScrollView *_scrollView;
    UIButton *_backButton;
    UIImageView *_logoImageView;
    UILabel    *statusLable;
    UILabel    *whoLable;
    UILabel    *priceLable;
    UIButton   *typeButton;
    UIButton   *noticeButton;
}
@end

@implementation HBPayResultViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


-(void)createUI{
    
    __weak typeof(self) weakSelf = self;
   
    //重写导航栏
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = UIColorFromRGB(247, 247, 247);
    [self.view addSubview:navView];
    if (iPhoneX) {
        
        [navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view);
            make.leading.equalTo(weakSelf.view.mas_leading);
            make.trailing.equalTo(weakSelf.view.mas_trailing);
            make.height.equalTo(@84);
        }];
    }else{
        [navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view);
            make.leading.equalTo(weakSelf.view.mas_leading);
            make.trailing.equalTo(weakSelf.view.mas_trailing);
            make.height.equalTo(@64);
        }];
    }
    
    
    if (iPhoneX) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 52, 18, 18)];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"nav_bar_close"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:_backButton];
    }else{
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 32, 18, 18)];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"nav_bar_close"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:_backButton];
    }
    
    if (iPhoneX) {
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH  - 100) / 2, 47, 100, 30)];
        codeLabel.text = @"付款成功";
        codeLabel.textAlignment = NSTextAlignmentCenter;
        codeLabel.textColor = [UIColor blackColor];
        codeLabel.font = [UIFont systemFontOfSize:18.0f];
        [navView addSubview:codeLabel];
    }else{
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH  - 100) / 2, 27, 100, 30)];
        codeLabel.text = @"付款成功";
        codeLabel.textAlignment = NSTextAlignmentCenter;
        codeLabel.textColor = [UIColor blackColor];
        codeLabel.font = [UIFont systemFontOfSize:18.0f];
        [navView addSubview:codeLabel];
        
        
    }
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.scrollEnabled = YES;//控制控件是否能滚动
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _scrollView.bounces = YES;//控制控件遇到边框是否反弹
    _scrollView.alwaysBounceVertical = NO;//控制垂直方向遇到边框是否反弹
    _scrollView.alwaysBounceHorizontal = NO;//控制水平遇到边框是否反弹
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 540.0f);
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(navView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_NAV_STATUS_BAR));
    }];

    _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_result_logo"]];
    [_scrollView addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(_scrollView);
        make.top.equalTo(_scrollView.mas_top).with.offset(44);
        make.width.equalTo(@100);
        make.height.equalTo(@54);
    }];
    
    statusLable = [[UILabel alloc] init];
    statusLable.backgroundColor = [UIColor clearColor];
    statusLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
    statusLable.text = @"付款成功!";
    statusLable.textAlignment = NSTextAlignmentCenter;
    statusLable.textColor = UIColorFromRGB(142, 142, 147);
    [_scrollView addSubview:statusLable];
    [statusLable mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(_scrollView);
        make.top.equalTo(_logoImageView.mas_bottom).with.offset(15);
        make.leading.equalTo(_scrollView);
        make.trailing.equalTo(_scrollView);
        make.height.equalTo(@18);
    }];
    
    whoLable = [[UILabel alloc] init];
    whoLable.backgroundColor = [UIColor clearColor];
    whoLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
    whoLable.text = @"向火币商家支付";
    whoLable.textAlignment = NSTextAlignmentCenter;
    whoLable.textColor = UIColorFromRGB(142, 142, 147);
    [_scrollView addSubview:whoLable];
    [whoLable mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(_scrollView);
        make.top.equalTo(statusLable.mas_bottom).with.offset(44);
        make.leading.equalTo(_scrollView);
        make.trailing.equalTo(_scrollView);
        make.height.equalTo(@18);
    }];
    
    priceLable = [[UILabel alloc] init];
    priceLable.backgroundColor = [UIColor clearColor];
    priceLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0f];
    priceLable.text = @"3000BTC";
    priceLable.textAlignment = NSTextAlignmentCenter;
    priceLable.textColor = [UIColor blackColor];
    [_scrollView addSubview:priceLable];
    [priceLable mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(_scrollView);
        make.top.equalTo(whoLable.mas_bottom).with.offset(14);
        make.leading.equalTo(_scrollView);
        make.trailing.equalTo(_scrollView);
        make.height.equalTo(@38);
    }];
}


-(void)back
{
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
