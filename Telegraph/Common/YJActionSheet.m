//
//  YJActionSheet.m
//  DrLink_IOS
//
//  Created by liuwenjie on 15/7/2.
//  Copyright (c) 2015年 DrLink. All rights reserved.
//

#import "YJActionSheet.h"

@implementation YJActionSheet
-(instancetype)initWithTitle:(NSString *)title delegate:(id<YJActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles{
    
    if (self=[super initWithFrame:CGRectMake(0, 0, DScreenW, DScreenH)]) {
        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
        _yjDelegate=delegate;
        _buttons=[NSMutableArray array];
        [_buttons addObjectsFromArray:otherButtonTitles];
        
        if (cancelButtonTitle) {
            [_buttons addObject:cancelButtonTitle];
        }else{
            [_buttons addObject:@""];
        }

        [self initializeView];
    }
    return self;
}
-(instancetype)initWithLiteActionBtns:(NSArray *)buttons clickedIndex:(ActionSheetClicked)block{
    if (self=[super initWithFrame:CGRectMake(0, 0, DScreenW, DScreenH)]) {
        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
        _buttons=[NSMutableArray array];
        [_buttons addObjectsFromArray:buttons];
        [_buttons addObject:@"取消"];
        _block=block;
        [self initializeView];

    }
    return self;
}
-(void)setActionTitle:(NSString *)actionTitle{
    _actionTitle=[actionTitle copy];
    
}

-(void)initializeView{
    CGFloat btnHeight=49;
    CGFloat btnWidth=DScreenW;
    CGFloat maxy=0.0f;
    _actionView=[[UIView alloc] init];
    _actionView.backgroundColor=kColorGray5;
    for (int i=0; i<_buttons.count; i++) {
        UIButton *btn=[[UIButton alloc] init];
        if (i==_buttons.count-1) {
            btn.frame=CGRectMake(0, i*btnHeight+5, btnWidth, btnHeight);
            
        }else{
            btn.frame=CGRectMake(0, i*btnHeight+0.5, btnWidth, btnHeight-0.5);
            UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, btn.minY, btnWidth, 0.5)];
            line.backgroundColor=kLine_Color;
            [_actionView addSubview:line];

        }
        
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitle:_buttons[i] forState:UIControlStateNormal];
        [btn setTitleColor:kColorGray1 forState:UIControlStateNormal];
        btn.titleLabel.font=kFontNormal;
        maxy=btn.maxY;
        [_actionView addSubview:btn];
        btn.tag=i;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    _actionView.frame=CGRectMake(0, DScreenH-maxy, DScreenW, maxy);
    
}



-(void)show{
    UIWindow *window= [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    CGRect frame=_actionView.frame;
    _actionView.frame=CGRectMake(0, DScreenH, DScreenW, 0);
    [self addSubview:_actionView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _actionView.frame=frame;
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)close{
    CGRect frame=_actionView.frame;
    frame.origin.y=DScreenH;
    [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _actionView.frame=frame;
        self.alpha=0;
    } completion:^(BOOL finished) {
        
        [_actionView removeFromSuperview];
        [self removeFromSuperview];
    }];

}
-(void)buttonAction:(UIButton *)sender
{
    NSInteger tag=sender.tag;
    CGRect frame=_actionView.frame;
    frame.origin.y=DScreenH;
    [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _actionView.frame=frame;
        self.alpha=0;
    } completion:^(BOOL finished) {
        
        [_actionView removeFromSuperview];
        [self removeFromSuperview];
        if (self.yjDelegate && [self.yjDelegate respondsToSelector:@selector(actionSheet:clickedBtnAtIndex:)]) {
            [self.yjDelegate actionSheet:self clickedBtnAtIndex:tag];
        }
        
        if (self.block) {
            self.block(tag);
        }
    }];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self close];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
