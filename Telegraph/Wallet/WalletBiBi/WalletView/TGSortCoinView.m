//
//  TGSortCoinView.m
//  Telegraph
//
//  Created by 张玮 on 2018/5/1.
//

#import "TGSortCoinView.h"
#import "TGPayListModel.h"
@interface TGSortCoinView()

@property (nonatomic, weak) UIView *containerView;

/** 上次选择的刷选按钮 */
@property (nonatomic, weak) UIButton *lastBtn;

@end


@implementation TGSortCoinView

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
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
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



- (void)show
{
    self.hidden = NO;
    self.alpha=0.1;
    //self.transform=CGAffineTransformMakeScale(1,1);
    self.transform=CGAffineTransformMakeScale(0.5,0.5);
    __weak __typeof(self)Action = self;
    [UIView animateWithDuration:0.1 delay:0  options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         Action.alpha=1;
                         Action.transform=CGAffineTransformMakeScale(1,1);
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
//- (void)showFromView:(UIView *)view
//{
//    self.frame = view.bounds;
//    [view addSubview:self];
//
//    [self setupBtns];
//}

- (void)setupBtns
{
    for (NSInteger index = 0; index < 3; index ++)
    {
        UIButton *btn = [self createBtn:index];
        if (index == 1) {
            [btn setBackgroundColor: EColorWithAlpha(0xeaeaea, 1)];
            self.lastBtn = btn;
        }
    }
}

- (UIButton *)createBtn:(NSInteger)tag
{
    CoinBtn *btn = [[CoinBtn alloc] init];
    [btn setTitle:[TGPayListModel getCoinStr:tag] forState:UIControlStateNormal];
    NSString *name =[NSString stringWithFormat:@"%ld.png",tag+64];
    
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:btn];
    return btn;
}

- (void)btnClicked:(UIButton *)btn
{    
    btn.backgroundColor = EColorWithAlpha(0xeaeaea, 1);
    self.lastBtn.backgroundColor = [UIColor clearColor];
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
    
    CGFloat containerViewX = DScreenW/2-20;
    CGFloat containerViewY = 50;
    CGFloat containerViewW = 120;
    CGFloat containerViewH = 120;
    self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
    
    NSInteger count = self.containerView.subviews.count;
    CGFloat btnW = containerViewW;
    CGFloat btnH = containerViewH/count;
    
    for (NSInteger index = 0; index < count; index ++) {
        UIButton *btn = self.containerView.subviews[index];
        CGFloat btnY = index * btnH;
        btn.frame = CGRectMake(0, btnY, btnW, btnH);
    }
}


@end

@implementation CoinBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x =self.width -90;
    return CGRectMake(x, 10, 20, 20);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat w =self.width -10;
    return CGRectMake(self.width/2, 5, 40, 30);
}

@end
