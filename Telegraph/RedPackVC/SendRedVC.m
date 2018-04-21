//
//  SendRedVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/20.
//

#import "SendRedVC.h"
#import "InfiniteScrollPicker.h"
#import "ETHModel.h"
@interface SendRedVC ()
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UITextField *redCountField;
@property (weak, nonatomic) IBOutlet UITextField *remarkField;
@property (weak, nonatomic) IBOutlet UIButton *sendMoneyBtn;
@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (nonatomic ,strong)InfiniteScrollPicker *isp;

@end

@implementation SendRedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestView];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void)requestView
{
    

}

- (IBAction)fanhuiAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)lookMore:(id)sender {
    NSLog(@"查看更多");
}
- (IBAction)handPackAction:(id)sender {
    NSLog(@"改为拼手气红包");
}

- (IBAction)senAction:(id)sender {
    NSLog(@"塞进红包");
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
