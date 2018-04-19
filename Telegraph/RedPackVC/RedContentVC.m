//
//  RedContentVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/19.
//

#import "RedContentVC.h"
#import "DDButton.h"


@interface RedContentVC ()

@property (nonatomic ,strong)DDButton *leftBtn;

@property (nonatomic ,strong)UIImageView *titleImg;

@property (nonatomic ,strong)UILabel *nameTitleLabel;

@property (nonatomic ,strong)UILabel *contenLabel;


@interface RedContentVC ()

@end

@implementation RedContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar setHidden:YES];
    UIView *viewS =self.navigationController.navigationBar;
    [viewS setHidden:YES];
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenW, 64)];
    view.backgroundColor =[UIColor redColor];
    [self.view addSubview:view];
    
    self.leftBtn=[[DDButton alloc] initWithImageFrame:CGRectMake(12, 12, 20, 20)];
    self.leftBtn.frame=CGRectMake(0, 20, 60, 44);
    self.leftBtn.tag=0;
    self.leftBtn.hidden=YES;
    [self.leftBtn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftBtn];
}


- (void)actionButton:(UIButton *)sender
{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)setUpViews
{
    
}
@end
