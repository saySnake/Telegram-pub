//
//  TGAnotherViewController.m
//  Telegraph
//
//  Created by ztp on 2018/3/28.
//

#import "TGAnotherViewController.h"
#import "UIView+Addition.h"
#import "RTDeviceHardWare.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "CustBtn.h"
#import "TGApplication.h"
#import "WKWebViewController.h"

@interface TGAnotherViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic ,strong) SDCycleScrollView *sdScrollerView;

@property (nonatomic ,strong) UIScrollView *ContainerView;

@end

@implementation TGAnotherViewController


- (SDCycleScrollView *)sdScrollerView
{
    
    NSArray *imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg",
                            ];

    if (!_sdScrollerView) {
        CGFloat height =self.view.height;
        BOOL isIphonex =[RTDeviceHardWare iPhoneXDevice];
        CGFloat top =CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _sdScrollerView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, 150) imageNamesGroup:imageNames];
    }
    return _sdScrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self setTitleText:TGLocalized(@"Founds.Title")];
    
    [self CreateView];
//    self.navigationController.navigationBar.barTintColor=[UIColor redColor];
}

- (void)CreateView
{
    CGFloat top =CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat height =self.view.height;
    BOOL isIphonex =[RTDeviceHardWare iPhoneXDevice];
    
    self.ContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, self.view.width,isIphonex?height-66-top:height-49-top)];
    [self.view addSubview:self.ContainerView];
    
    self.sdScrollerView.delegate =self;
    self.sdScrollerView.pageControlStyle =SDCycleScrollViewPageContolStyleAnimated;
    [self.ContainerView addSubview:self.sdScrollerView];
    
    [self setUpUIView];
}

- (void)setUpUIView
{
    CGFloat padding =10;
    UIImageView *titleImg =[[UIImageView alloc] init];
    titleImg.frame =CGRectMake(padding, CGRectGetMaxY(self.sdScrollerView.frame)+10, 20, 20 );
    titleImg.image =[UIImage imageNamed:@"tuijian"];
    [self.ContainerView addSubview:titleImg];
    
    
    UILabel *titleLabel =[[UILabel alloc] init];
    titleLabel.text =@"推荐";
    titleLabel.font =[UIFont systemFontOfSize:15];
    titleLabel.frame =CGRectMake(CGRectGetMaxX(titleImg.frame)+5, CGRectGetMaxY(self.sdScrollerView.frame)+5, 40, 30);
    titleLabel.textColor =[UIColor blackColor];
    [self.ContainerView addSubview:titleLabel];
    
    UILabel *line =[[UILabel alloc] init];
    line.frame =CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+5, CGRectGetMaxX(self.view.frame), 0.5);
    line.backgroundColor =[UIColor lightGrayColor];
    [self.ContainerView addSubview:line];
    
    [self setupBtn:line];
}

- (void)setupBtn:(UILabel *)line
{
    CGFloat padding =10;
    CGFloat width =(CGRectGetWidth(self.view.frame) -6*5)/5;
    CGFloat h ;
    
    NSArray *imgs =@[@"shilitouxiang",
                     @"shilitouxiang",
                     @"shilitouxiangtwo",
                     @"shilitouxiangtwo",
                     @"shilitouxiangtwo",
                     @"gengduotuijian"
                     ];
    
    NSArray *titl =@[@"Dragonex",
                    @"CoinMeet",
                    @"火币官方群6",
                    @"火币官方群8",
                    @"火币官方群8"
                    ];

    for (int i =0;  i<5; i++) {
        CustBtn *btn =[CustBtn buttonWithType:UIButtonTypeCustom];
        btn.tag =i;
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        btn.frame =CGRectMake(5 +i*width+5*i, CGRectGetMaxY(line.frame)+5, width, width);
        NSString *nam =titl[i];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [btn setTitle:[NSString stringWithFormat:@"%@",nam] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment =1;
        [btn addTarget:self action:@selector(pushGroup:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        NSString * name =imgs[i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",name]] forState:UIControlStateNormal];
        [self.ContainerView addSubview:btn];
        if (i ==4) {
            h  =CGRectGetMaxY(btn.frame);
        }
        
    }
    CGFloat hh;
    
    NSArray *imgss =@[@"shilitouxiangtwo",
                     @"shilitouxiangtwo",
                     @"shilitouxiangtwo",
                     @"shilitouxiangtwo",
                     @"gengduotuijian"
                     ];
    
    NSArray *tit =@[@"Dragonex",
                    @"CoinMeet",
                    @"火币官方群6",
                    @"火币官方群8",
                    @"更多推荐群"
                    ];

    for (int i =0; i<5; i++) {
        CustBtn *btn =[CustBtn buttonWithType:UIButtonTypeCustom];
        btn.tag =10+i;
        
        NSString *nam =tit[i];
        [btn setTitle:[NSString stringWithFormat:@"%@",nam] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment =1;
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(pushGroup:) forControlEvents:UIControlEventTouchUpInside];

        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        NSString * name =imgss[i];
        btn.frame =CGRectMake(5 +i*width+5*i, h+5, width, width);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",name]] forState:UIControlStateNormal];
        if (i ==4) {
            hh =CGRectGetMaxY(btn.frame);
        }
        [self.ContainerView addSubview:btn];
    }
    
    UIView *backView =[[UIView alloc] init];
    backView.frame =CGRectMake(0, hh +padding, CGRectGetMaxX(self.view.frame), 15);
    backView.backgroundColor =UIColorRGB(0xF1F1F1);
    [self.ContainerView addSubview:backView];
    
    NSArray *arr =@[@"hangqing",
                     @"zixun",
                     @"toutiao",
                     @"xuetang",
                     ];
    
    NSArray *tites =@[@"火币行情",
                      @"火币资讯",
                      @"财经头条",
                      @"火币学堂"
                      ];
    CGFloat viewh =60;
    
    CGFloat hhh;
    
    for (int i =0; i<4; i++) {
        UIButton *view =[[UIButton alloc] init];
        view.tag =20+i;
        [view addTarget:self action:@selector(pushWebview:) forControlEvents:UIControlEventTouchUpInside];
        view.frame =CGRectMake(0, CGRectGetMaxY(backView.frame)+i*viewh, CGRectGetMaxX(self.view.frame), viewh);
        view.backgroundColor =[UIColor whiteColor];
        
        UIView *line =[[UIView alloc] init];
        line.frame =CGRectMake(padding, view.height-0.5, CGRectGetMaxX(self.view.frame) -20, 0.5);
        line.backgroundColor =[UIColor lightGrayColor];
        [view addSubview:line];
        
        UIImageView *img =[[UIImageView alloc] init];
        img.frame =CGRectMake(padding*1.5, 15, 30, 30);
        NSString *imgName =arr[i];
        img.contentMode =1;
        [view addSubview:img];
        img.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imgName]];
        
        UIImageView *jiantou =[[UIImageView alloc] init];
        jiantou.image =[UIImage imageNamed:@"jiantou"];
        jiantou.frame =CGRectMake(CGRectGetMaxX(self.view.frame) -50, 22, 20, 15);
        jiantou.contentMode =UIViewContentModeScaleAspectFit;
        [view addSubview:jiantou];

        UILabel *lab =[[UILabel alloc] init];
        lab.text =tites[i];
        lab.textColor =[UIColor lightGrayColor];
        lab.frame =CGRectMake(CGRectGetMaxX(img.frame)+2*padding, 10, 100, 40);
        [view addSubview:lab];
        [self.ContainerView addSubview:view];
        
        if (i ==3) {
            hhh =CGRectGetMaxY(view.frame);
        }
    }
    
    self.ContainerView.contentSize = CGSizeMake(self.view.frame.size.width, hhh+30);
}


#pragma mark-进群
- (void)pushGroup:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:{
            [(TGApplication *)[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/BinanceChinese"] forceNative:true];
        }
            break;
        case 1:{
            [(TGApplication *)[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/huobiofficial"] forceNative:true];
        }
            break;
        case 2:{
            [(TGApplication *)[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/ipmineio"] forceNative:true];

        }
            break;
        case 3:{
            [(TGApplication *)[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/B1_EX"] forceNative:true];
        }
            break;
        case 4:{
            [(TGApplication *)[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/huobiCN"] forceNative:true];
        }
        case 10:{
            [(TGApplication *)[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/huobiCN"] forceNative:true];
        }
        default:
            break;
    }
    [(TGApplication *)[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/huobiCN"] forceNative:true];
}

- (void)pushWebview:(UIButton *)sender
{
    WKWebViewController *web =[[WKWebViewController alloc] init];

    switch (sender.tag) {
        case 20:{
            [web loadWebURLSring:@"https://m.huobi.com/market/"];
        }
            break;
        case 21:
        {
            [web loadWebURLSring:@"https://m.huobi.cn/news/#/flash"];
        }
            break;
        case 22:{
            [web loadWebURLSring:@"https://m.huobi.com/market/"];
        }
            break;
        case 23:{
            [web loadWebURLSring:@"http://jingyan.baidu.com/zt/qukuailian/index.html?st=2&os=0&bd_page_type=1&net_type=3&ssid=&from=groupmessage&isappinstalled=0"];
        }
        default:
            break;
    }
    [self.navigationController pushViewController:web animated:YES];
}



#pragma mark -SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
//    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}



@end
