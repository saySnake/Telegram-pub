//
//  CustNavBar.m
//  Drlink-IOS
//
//  Created by 张玮 on 15/3/17.
//  Copyright (c) 2015年 DrLink. All rights reserved.
//

#import "CustNavBar.h"
#import "DDButton.h"
//#import "CUSFlashLabel.h"
@interface CustNavBar()
//标题
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *shakeLabel;

@property (nonatomic ,strong) UILabel *flashLabel;

@property (nonatomic ,strong) UIView *views;
@end


@implementation CustNavBar
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=RGBACOLOR(35, 63, 139, 1);
        self.leftBtn=[[DDButton alloc] initWithImageFrame:CGRectMake(12, 12, 12, 20)];
        self.leftBtn.frame=CGRectMake(0, 20, 60, 44);
        self.leftBtn.tag=0;
        self.leftBtn.hidden=YES;
        [self.leftBtn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftBtn];
        
        self.rightBtn=[[DDButton alloc] initWithImageFrame:CGRectMake(10, 12, 22, 22)];
        self.rightBtn.frame=CGRectMake(frame.size.width-50, 20, 50, 44);
        self.rightBtn.tag=1;
        self.rightBtn.hidden=YES;
        [self.rightBtn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
        
        
        self.titleBtn=[[UIButton alloc]init];
        self.titleBtn.frame=CGRectMake(self.leftBtn.maxX, 20, self.width-self.leftBtn.maxX-60, 44);
        self.titleBtn.userInteractionEnabled=NO;
        [_titleBtn addTarget:self action:@selector(navTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        self.titleBtn.titleLabel.font=kFontLarge_1;
        [self addSubview:self.titleBtn];
    }
    return self;
}


- (instancetype)init
{
    NSAssert(0, @"请使用initWithFrame:方法初始化");
    return nil;
}

-(void)setLeftItemImage:(NSString *)image{
    if (image) {
        self.leftBtn.hidden=NO;
        [self.leftBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }else{
        self.leftBtn.hidden=YES;
    }
}
-(void)setRightItemImage:(NSString *)image{
    if (image) {
        self.rightBtn.hidden=NO;
        [self.rightBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setHidden:YES];
    }

}
-(void)setBarTitle:(NSString *)title{
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}


/**
 *  设置中心view
 *
 *  @param view view
 */
- (void)setCenterView:(UIView *)view
{
    _views =view;
    [self addSubview:_views];
}

//action
-(void)actionButton:(id)sender
{
    if (_itemClick) {
        self.itemClick([sender tag]);
    }
}
-(void)navTitleClick:(id)sender{
    if (_btnClick) {
        _btnClick(sender);
    }
}
/**
 *  晃动
 *
 *  @param str   str
 *  @param shake shake
 */
- (void)showAlertWithString:(NSString *)str isShaeke:(BOOL)shake
{
    CGFloat shakeX =100 *autoSizeScaleX;
    CGFloat shakeY =20*autoSizeScaleY;
    CGFloat shakeW =DScreenW -shakeX;
    CGFloat shakeH =40 *autoSizeScaleY;
    UILabel *alertLabel =[[UILabel alloc]initWithFrame:CGRectMake(shakeX,
                                                                  shakeY,
                                                                  shakeW,
                                                                  shakeH)];
    [self addSubview:alertLabel];
    alertLabel.text =str;
    alertLabel.textColor =[UIColor whiteColor];
    
    if (shake) {
        self.titleLabel.alpha =0;
        CAKeyframeAnimation *animation =[CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        CGFloat currentTx=alertLabel.transform.tx;
        animation.delegate =self;
        animation.duration =0.5;
        animation.values = @[ @(currentTx),
                              @(currentTx + 10),
                              @(currentTx-8),
                              @(currentTx + 8),
                              @(currentTx -5),
                              @(currentTx + 5),
                              @(currentTx) ];
        animation.keyTimes = @[ @(0),
                                @(0.225),
                                @(0.425),
                                @(0.6),
                                @(0.75),
                                @(0.875),
                                @(1) ];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [alertLabel.layer addAnimation:animation
                                forKey:@"shake"];
        
        [UIView animateKeyframesWithDuration:0.55
                                       delay:1.5
                                     options:0
                                  animations:^{
            alertLabel.alpha =0;
            self.titleLabel.alpha =1;
        } completion:^(BOOL finished) {
            [alertLabel removeFromSuperview];
        }];
        
    } else {
        alertLabel.alpha =0;
        [UIView animateKeyframesWithDuration:0.15
                                       delay:0
                                     options:0
                                  animations:^{
            alertLabel.alpha =1;
            self.titleLabel.alpha =0;
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:0.65
                                           delay:1.5
                                         options:0
                                      animations:^{
               
                alertLabel.alpha=0;
                self.titleLabel.alpha =1;
            } completion:^(BOOL finished) {
                [alertLabel removeFromSuperview];
            }];
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
