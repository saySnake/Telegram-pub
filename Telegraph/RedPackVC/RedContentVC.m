//
//  RedContentVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/19.
//

#import "RedContentVC.h"
#import "DDButton.h"
#import "NSObject+Util.h"
#import "RedListVC.h"


@interface RedContentVC ()

//@property (nonatomic ,strong)UIButton *leftB;

@property (nonatomic ,strong)UIImageView *titleImg;

@property (nonatomic ,strong)UILabel *nameTitleLabel;

@property (nonatomic ,strong)UILabel *contenLabel;



@end

@implementation RedContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof (self) action = self;
    self.navigationController.navigationBar.hidden =YES;

    UILabel *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenW, 64)];
    view.backgroundColor =RGBACOLOR(235.0f, 95.0f, 72.0f, 1);
    
    UIButton *leftB=[UIButton buttonWithType:UIButtonTypeCustom];
    leftB.frame =CGRectMake(12, 20, 40, 40);
    [leftB setTitle:@"关闭" forState:UIControlStateNormal];
    [leftB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftB addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    leftB.backgroundColor =[UIColor clearColor];
    
    
    
    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"红包记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font =kFont13;
    rightBtn.frame =CGRectMake(DScreenW -70, 20, 70, 40);
    [rightBtn addTarget: self action:@selector(loadmore:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    //Tap给imageView 用
    self.view.backgroundColor =[UIColor whiteColor];
//    [leftB addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftB];
    view.backgroundColor =HEXCOLOR(0xF42C27);
    [self.view addSubview:view];
    
    [self setUpViews:view];
}


- (void)loadmore:(UIButton *)sender
{
    NSLog(@"红包记录");
    RedListVC *list =[[RedListVC alloc] init];
    [self presentViewController:list animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)tapAction:(UIButton *)tap
{
    NSLog(@"返回");
    self.navigationController.navigationBar.hidden =NO;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setUpViews:(UIView *)view
{
    UIImageView *backImg =[[UIImageView alloc]init];
    backImg.frame =CGRectMake(0, CGRectGetMaxY(view.frame), DScreenW, 90);
    [backImg setImage:[UIImage imageNamed:@"Redtop"]];
    [self.view addSubview:backImg];
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backImg.frame), DScreenW, 160)];
    backView.backgroundColor =HEXCOLOR(0xF1F1F1);
    [self.view addSubview:backView];
    
    CGFloat centerx =DScreenW*0.5;
    CGFloat centery =CGRectGetMaxY(backImg.frame);
    
    UIImageView *titleImg =[[UIImageView alloc] initWithFrame:CGRectMake(centerx, centery, 40, 40)];
    titleImg.backgroundColor =[UIColor blueColor];
    titleImg.cornerRadius =20;
    titleImg.center =CGPointMake(centerx, centery);
    [self.view addSubview:titleImg];
    
    UILabel *titleLabel =[[UILabel alloc] init];
    titleLabel.text =@"文杰柳的HT红包";
    titleLabel.font =kFont13;
    titleLabel.textColor =[UIColor blackColor];
    CGFloat titley =CGRectGetMaxY(titleImg.frame);
    titleLabel.frame =CGRectMake(centerx, titley, 100, 30);
    titleLabel.textAlignment =1;
    titleLabel.center =CGPointMake(centerx, titley+20);
    [self.view addSubview:titleLabel];
    
    UILabel *contLabel =[[UILabel alloc] init];
    contLabel.textAlignment =1;
    contLabel.text =@"拆包有惊喜";
    contLabel.font =kFontMini;
    contLabel.frame =CGRectMake(centerx, CGRectGetMaxY(titleLabel.frame)+5, 100, 30);
    contLabel.textColor =[UIColor blackColor];
    contLabel.center =CGPointMake(centerx, CGRectGetMaxY(titleLabel.frame)+20);
    [self.view addSubview:contLabel];
    
    UILabel *countLabel =[[UILabel alloc] init];
    countLabel.text =@"0.01";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    NSString *str = countLabel.text;
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    countLabel.frame =CGRectMake(centerx, CGRectGetMaxY(contLabel.frame)+20, textSize.width, textSize.height);
    countLabel.textColor =[UIColor blackColor];
    countLabel.center =CGPointMake(centerx-20, CGRectGetMaxY(contLabel.frame)+20);
    [self.view addSubview:countLabel];
    
    
    
    UILabel *typeLabel =[[UILabel alloc] init];
    typeLabel.text =@"HAND";
    typeLabel.textAlignment =0;
    typeLabel.font =kFontSmall;
    typeLabel.frame =CGRectMake(CGRectGetMaxX(countLabel.frame), CGRectGetMinY(countLabel.frame)+2, 50, 20);

    typeLabel.textColor =[UIColor blackColor];
    [self.view addSubview:typeLabel];
    
    
    UILabel *redLabel =[[UILabel alloc] init];
    redLabel.textColor =[UIColor blueColor];
    redLabel.frame =CGRectMake(centerx, CGRectGetMaxY(countLabel.frame)+30, 150, 20);
    redLabel.font =kFontSmall;
    redLabel.text =@"已存入钱包中,可直接消费";
    redLabel.center =CGPointMake(centerx, CGRectGetMaxY(typeLabel.frame)+20);
    [self.view addSubview:redLabel];
    
    
    UIButton *look =[UIButton buttonWithType:UIButtonTypeCustom];
    [look setTitle:@"留言" forState:UIControlStateNormal];
    look.titleLabel.font =kFontBig;
    [look setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    look.frame =CGRectMake(0,0, 150, 20);
    look.center =CGPointMake(centerx, CGRectGetMaxY(backView.frame)+30);
    [look addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:look];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(look.frame)+10, DScreenW-40, 0.5)];
    line.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:line];
    
}

- (void)lookAction:(UIButton *)sender
{
    NSLog(@"留言");
}




@end
