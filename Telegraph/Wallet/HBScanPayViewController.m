//
//  HBScanPayViewController.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/2.
//

#import "HBScanPayViewController.h"
#import "HBCodeScan.h"

@interface HBScanPayViewController ()
{
    UIButton *_backButton;
    
    HBCodeScan *_codeScan;
    
    UIView *_shadowView;
    
    UIImageView *_boardImageView;
    
    UIImageView *_lineImageView;
}
@property (nonatomic, assign) BOOL isLineAnimate;
@end

@implementation HBScanPayViewController

#pragma mark
#pragma mark **1.视图生命周期***

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_codeScan startScan];
    
    [UIView animateWithDuration:1 animations:^{
        _codeScan.alpha = 1;
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [_codeScan stopScan];
}


-(void)createUI{
    
    _codeScan = [[HBCodeScan alloc] init];
    _codeScan.alpha = 0;
    [self.view addSubview:_codeScan];
    [_codeScan mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        
    }];
    
    __weak typeof(self) weakSelf = self;
    [_codeScan setDenyHandler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_codeScan setResultHandler:^(NSString *result) {
        weakSelf.result = result;
        weakSelf.isLineAnimate = NO;
        [weakSelf actionAfterScan];
    }];
    
    _shadowView = [[UIView alloc] init];
    _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //重写导航栏
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = UIColorFromRGB(247, 247, 247);
    [self.view addSubview:navView];
    if (iPhoneX) {
        
        [navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.height.equalTo(@84);
        }];
    }else{
        [navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.height.equalTo(@64);
        }];
    }
    
    
    if (iPhoneX) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 52, 18, 21)];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:_backButton];
    }else{
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 32, 18, 21)];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:_backButton];
    }
    
    if (iPhoneX) {
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH  - 100) / 2, 47, 100, 30)];
        codeLabel.text = @"扫码付款";
        codeLabel.textAlignment = NSTextAlignmentCenter;
        codeLabel.textColor = [UIColor blackColor];
        codeLabel.font = [UIFont systemFontOfSize:18.0f];
        [navView addSubview:codeLabel];
    }else{
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH  - 100) / 2, 27, 100, 30)];
        codeLabel.text = @"扫码付款";
        codeLabel.textAlignment = NSTextAlignmentCenter;
        codeLabel.textColor = [UIColor blackColor];
        codeLabel.font = [UIFont systemFontOfSize:18.0f];
        [navView addSubview:codeLabel];
        
        
    }
    
    
    
    _boardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zbar_scanle"]];
    [self.view addSubview:_boardImageView];
    [_boardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zbar_line"]];
    [self.view addSubview:_lineImageView];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_boardImageView.mas_top).offset(2);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"将二维码/条码放入框内，即可自动扫描";
    tipLabel.font = [UIFont systemFontOfSize:15.0f];
    tipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_boardImageView.mas_bottom).offset(23);
    }];
    
    self.isLineAnimate = YES;
}


- (void)viewDidLayoutSubviews
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_shadowView.bounds];
    UIBezierPath *boardPath = [UIBezierPath bezierPathWithRect:_boardImageView.frame];
    [path appendPath:boardPath.bezierPathByReversingPath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    
    _shadowView.layer.mask = maskLayer;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setIsLineAnimate:(BOOL)isLineAnimate
{
    _isLineAnimate = isLineAnimate;
    if (_isLineAnimate) {
        [self lineAnimate];
    }
}

- (void)lineAnimate
{
    if (!self.isLineAnimate) {
        return;
    }
    [UIView animateWithDuration:5 animations:^{
        _lineImageView.transform = CGAffineTransformMakeTranslation(0, _boardImageView.frame.size.height - 6);
    } completion:^(BOOL finished) {
        [self bottomLineAnimate];
    }];
}

- (void)bottomLineAnimate
{
    typeof(self) __weak weakSelf = self;
    
    if(!weakSelf.isLineAnimate) {
        return;
    }
    [UIView animateWithDuration:5 animations:^{
        _lineImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [weakSelf lineAnimate];
    }];
}

//扫描后的处理
- (void)actionAfterScan{
    
    
    if (!isEmpty(_result)) {
        
        NSLog(@"扫描后的处理--%@",_result);
        NSError* error = nil;
        id   result = [NSJSONSerialization JSONObjectWithData:[_result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            
            //TODO:@"不支持该二维码"
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *     NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        }else{
            
            
            if (result) {
                
                //TODO:支付
                
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
                return;
                
            }
            
        }
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
        
    }
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
