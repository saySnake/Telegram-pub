//
//  BaseNoNavViewController.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/26.
//

#import "BaseNoNavViewController.h"

@interface BaseNoNavViewController ()

@end

@implementation BaseNoNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCommonUI];
    // Do any additional setup after loading the view.
}
- (void)setupCommonUI
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _backButton = [createLbaelButView createButtonFrame:CGRectMake(15*WIDTHRation, 34*HeightRation, 16*WIDTHRation, 16*WIDTHRation) backImageName:@"HBBackBut" title:nil titleColor:nil font:nil backColor:[UIColor clearColor]];
    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
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
