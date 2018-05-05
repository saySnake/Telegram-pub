//
//  TGSortView.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/28.
//

#import "TGSortView.h"
#import "TGPayListModel.h"

@interface TGSortView()

@property (nonatomic, weak) UIView *tgView;


@property (nonatomic, weak) UIView *containerView;

/** 上次选择的刷选按钮 */
@property (nonatomic, weak) UIButton *lastBtn;


@property (nonatomic ,weak) UIView *mask;

@end

@implementation TGSortView

- (UIView *)containerView
{
    if (!_containerView) {
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = EColorWithAlpha(0xFAFAFA, 1);
        [self addSubview:containerView];
        self.containerView = containerView;
        
        self.containerView.layer.shadowColor=[[UIColor blackColor] CGColor];
        self.containerView.layer.shadowOffset=CGSizeMake(0, 2);
        self.containerView.layer.shadowOpacity=0.24;
        self.containerView.layer.shadowRadius=2;
    }
    return _containerView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        [self setupBtns];
        [self setAnchorPoint:CGPointMake(0.3f, 0.03f) forView:self];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}




- (void)tap
{
    [self dismiss];
}


- (void)show:(UIViewController *)viewController
{
    UIView *m=[[UIView alloc]initWithFrame:viewController.view.frame];
    self.hidden = NO;
    self.alpha=0.1;
    __weak __typeof(self)Action = self;
    m.backgroundColor=[UIColor blackColor];
    m.alpha=0;
    self.mask =m;
    [viewController.view addSubview:self];
    self.transform=CGAffineTransformMakeScale(1, 1);
    self.alpha=0;

    [UIView animateWithDuration:0.1 delay:0  options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         Action.alpha=1;
                         Action.transform=CGAffineTransformMakeScale(1,1);
                         m.alpha =0.37;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)setupBtns
{
    for (NSInteger index = 0; index < 6; index ++)
    {
        UIButton *btn = [self createBtn:index];
        if (index == 1) {
            btn.backgroundColor = RGBACOLOR(250.0f, 225.0f, 0, 1); // 黄色
            self.lastBtn = btn;
        }
    }
}


- (UIButton *)createBtn:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:[TGPayListModel payListStr:tag] forState:UIControlStateNormal];
    btn.backgroundColor =RGBACOLOR(243.0f, 243.0f, 243.0f, 1);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:btn];
    return btn;
}


- (void)btnClicked:(UIButton *)btn
{
    btn.backgroundColor = RGBACOLOR(250.0f, 225.0f, 0, 1);
    self.lastBtn.backgroundColor = RGBACOLOR(243.0f, 243.0f, 243.0f, 1);
    self.lastBtn = btn;
    self.lastBtn = btn;
    self.budgetSortClicked(btn.tag);
    [self dismiss];
}


- (void)dismiss
{
//    [self removeFromSuperview];
    
    __weak __typeof(self)Action = self;
    Action.alpha=0;
    [UIView animateWithDuration:0.07 delay:0  options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         Action.transform=CGAffineTransformMakeScale(0.5,0.5);
                     }
                     completion:^(BOOL finished){
                         //[self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:self];
                         Action.hidden = YES;
            }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat containerViewX = 24;
    CGFloat containerViewY = 80;
    CGFloat containerViewW = DScreenW -2*containerViewX;
    CGFloat containerViewH = 150;
    self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
    
    NSInteger count = self.containerView.subviews.count;
    CGFloat btnW = (self.containerView.width -40-40)/3;
    NSLog(@"%f",btnW);
    CGFloat btnH = (containerViewH-80)/2;
    for (NSInteger index = 0; index < count; index ++) {
        NSInteger row =index/3;

        UIButton *btn = self.containerView.subviews[index];
        NSInteger col =index %3; //列
        CGFloat x =20 +col*(btnW +20);
        CGFloat y =row *(btnH +15)+30;
        btn.frame =CGRectMake(x, y , btnW, btnH);
        
    }
}


@end
