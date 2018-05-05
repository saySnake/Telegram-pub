//
//  YJAlertView.m
//  DrLink_IOS
//
//  Created by liuwenjie on 15/5/22.
//  Copyright (c) 2015年 DrLink. All rights reserved.
//

#import "YJAlertView.h"
#import "DDButton.h"
#import "DRWindow.h"
@interface YJAlertView ()
{
    CompeletClick _cBlock;
    NSArray *_btnTitles;
    NSString *_placeholder;
    UITapGestureRecognizer *_tap;
    YJAlertViewStyle _style;
}
@end

@implementation YJAlertView
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray *)titles  click:(CompeletClick)cblock{
    if (self=[super init]) {
        _title=title;
        _message=message;
        _btnTitles=titles;
        _cBlock=[cblock copy];
        _style=YJAlertViewStyleNormal;
        [self initialzeSubView];
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message inputPlace:(NSString *)input btnTitles:(NSArray *)titles click:(CompeletClick)cblock{
    if (self=[super init]) {
        _title=title;
        _message=message;
        _btnTitles=titles;
        _placeholder=input;
        _cBlock=[cblock copy];
        _style=YJAlertViewStyleInput;
        [self initialzeSubView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}
-(void)initialzeSubView{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;

    self.frame=window.bounds;
    //_bgView=[[UIImageView alloc]initWithFrame:window.bounds];
    self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    CGRect msgrect=[_message boundingRectWithSize:CGSizeMake(self.width-60, kMsgMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontMiddle,NSParagraphStyleAttributeName:paragraphStyle1} context:nil];
    CGFloat alerh;
    if (_style==YJAlertViewStyleNormal) {
        alerh=kTitleHeight+kButtonHeight*2+msgrect.size.height+20+20;
    }else if(_style==YJAlertViewStyleInput){
        alerh=kTitleHeight+kButtonHeight*2+kInputHeight*2+msgrect.size.height+20;
    }
    _alertView=[[UIView alloc] init];
    _alertView.backgroundColor=kColorGray4;
    _alertView.center=CGPointMake(self.width/2, self.height/2);
    _alertView.bounds=CGRectMake(0, 0, self.width-40, alerh);
    _alertView.cornerRadius=8.f;
    _titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, kTitleHeight)];
    _titleLbl.font=kFontNormal;
    _titleLbl.textColor=kColorBlue;//[UIColor whiteColor];
    _titleLbl.textAlignment=NSTextAlignmentCenter;
    _titleLbl.numberOfLines=0;
    _titleLbl.text=_title;
    [_alertView addSubview:_titleLbl];
    
    CGFloat centerH;
    if (_style==YJAlertViewStyleNormal) {
        centerH= msgrect.size.height+20+20;
        
    }else if (_style==YJAlertViewStyleInput){
        centerH= kInputHeight*2+msgrect.size.height+20;
    }
    UIView *center=[[UIView alloc] initWithFrame:CGRectMake(0, _titleLbl.maxY,_alertView.width,centerH)];
//    center.backgroundColor=RGBACOLOR(21, 69, 149, 1);
    _msgLbl=[[UILabel alloc] initWithFrame:CGRectMake(30, 20, center.width-60, msgrect.size.height)];
    _msgLbl.font=kFontMiddle;
    _msgLbl.textColor=kColorGray1;//[UIColor whiteColor];
    _msgLbl.textAlignment=NSTextAlignmentCenter;
    _msgLbl.numberOfLines=0;
    
    _msgLbl.attributedText=[_message lineSpacing:5];
    [center addSubview:_msgLbl];
    if (_style==YJAlertViewStyleInput) {
        _inputField=[[UITextField alloc] initWithFrame:CGRectMake(30, _msgLbl.maxY+20, center.width-60, kInputHeight)];
        _inputField.borderColor=RGBACOLOR(65, 170, 242, 1);
        _inputField.rightViewMode=UITextFieldViewModeWhileEditing;
        _inputField.text=_placeholder;
        _inputField.textColor=kColorGray1;
        _inputField.font=kFontMiddle;
        [center addSubview:_inputField];
    }
    [_alertView addSubview:center];
    
    CGFloat btnW=(_alertView.width-40)/_btnTitles.count;

    for (int i=0; i<_btnTitles.count; i++) {
        UIButton *btn=[[UIButton alloc] init];
        btn.frame=CGRectMake(20+btnW*i+5, center.maxY+kButtonHeight/2, btnW-10, kButtonHeight);
        btn.cornerRadius=4.f;
        btn.titleLabel.font=kFontNormal;
        if (i==_btnTitles.count-1) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor=kColorBlue;

        }else{
            [btn setTitleColor:kColorGray forState:UIControlStateNormal];
            btn.backgroundColor=[UIColor whiteColor];

        }
        [btn setTag:i];
        [btn setTitle:_btnTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:btn];
    }
}

-(instancetype)initWithTitle:(NSString *)title customCenterView:(UIView *)cview customBottomView:(UIView *)bview{
    if (self=[super init]) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;

        self.frame=window.bounds;
        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
        CGFloat alerh;
        UIView *center;
        UIView *bottom;
        center=cview;
        bottom=bview;
        
        alerh=kTitleHeight+center.height+bottom.height;
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=kColorGray4;//RGBACOLOR(46, 107, 170, 0.9);
        _alertView.center=CGPointMake(self.width/2, self.height/2);
        _alertView.bounds=CGRectMake(0, 0, self.width-40, alerh);
        _alertView.cornerRadius=8.f;
        _titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, kTitleHeight)];
        _titleLbl.font=kFontNormal;
        _titleLbl.textColor=kColorBlue;//[UIColor whiteColor];
        _titleLbl.textAlignment=NSTextAlignmentCenter;
        _titleLbl.numberOfLines=0;
        _titleLbl.text=title;
        [_alertView addSubview:_titleLbl];
        
        center.frame=CGRectMake(0, _titleLbl.maxY, center.width, center.height);
//        center.backgroundColor=RGBACOLOR(21, 69, 149, 1);
        [_alertView addSubview:center];
        
        bottom.frame=CGRectMake(0, center.maxY, bottom.width, bottom.height);
        bottom.backgroundColor=[UIColor clearColor];
        [_alertView addSubview:bottom];
        _tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title customCenterView:(UIView *)cview customBottomView:(UIView *)bview withDuartion:(NSTimeInterval )time{
    
    if (self=[super init]) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        
        self.frame=window.bounds;
        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
        CGFloat alerh;
        UIView *center;
        UIView *bottom;
        center=cview;
        bottom=bview;
        
        alerh=kTitleHeight+center.height+bottom.height;
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=kColorGray4;//RGBACOLOR(46, 107, 170, 0.9);
        _alertView.center=CGPointMake(self.width/2, self.height/2);
        _alertView.bounds=CGRectMake(0, 0, self.width-40, alerh);
        _alertView.cornerRadius=8.f;

        _titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, kTitleHeight)];
        _titleLbl.font=kFontNormal;
        _titleLbl.textColor=kColorBlue;//[UIColor whiteColor];
        _titleLbl.textAlignment=NSTextAlignmentCenter;
        _titleLbl.numberOfLines=0;
        _titleLbl.text=title;
        [_alertView addSubview:_titleLbl];
        
        
        
//        center.backgroundColor=RGBACOLOR(21, 69, 149, 1);
//        [UIView animateWithDuration:time animations:^{
            center.frame=CGRectMake(0, _titleLbl.maxY, center.width, center.height);
                    [_alertView addSubview:center];
//        }];


        
        bottom.frame=CGRectMake(0, center.maxY, bottom.width, bottom.height);
        bottom.backgroundColor=[UIColor clearColor];
        [_alertView addSubview:bottom];
        _tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    }
    return self;

}

-(instancetype)initWithTitle:(NSString *)title customCenterView:(UIView *)cview click:(CompeletClick)cblock{
    if (self=[super init]) {
        _cBlock=[cblock copy];

        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        
        self.frame=window.bounds;
        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
        CGFloat alerh;
        UIView *center;
        center=cview;
        UIView *bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenW-40, 60)];
        UIButton *disagress=[[UIButton alloc] initWithFrame:CGRectMake(20, (bottom.height-35)/2, bottom.width/2-40, 35)];
        disagress.backgroundColor=kColorWhite;
        [disagress setTitle:@"取消" forState:UIControlStateNormal];
        [disagress setTitleColor:kColorGray2 forState:UIControlStateNormal];
        disagress.cornerRadius=4.f;
        disagress.tag=0;
        disagress.titleLabel.font=kFontNormal;
        [bottom addSubview:disagress];
        UIButton *agress=[[UIButton alloc] initWithFrame:CGRectMake(bottom.width/2+20, (bottom.height-35)/2, bottom.width/2-40, 35) ];
        agress.backgroundColor=kColorWhite;
        [agress setTitle:@"确定" forState:UIControlStateNormal];
        agress.tag=1;
        [agress setTitleColor:kColorBlue forState:UIControlStateNormal];
        agress.cornerRadius=4.f;
        agress.titleLabel.font=kFontNormal;
        [bottom addSubview:agress];
        [disagress addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [agress addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        

        alerh=kTitleHeight+center.height+bottom.height;
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=kColorGray4;//RGBACOLOR(46, 107, 170, 0.9);
        _alertView.center=CGPointMake(self.width/2, self.height/2);
        _alertView.bounds=CGRectMake(0, 0, self.width-40, alerh);
        _alertView.cornerRadius=8.f;

        _titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, kTitleHeight)];
        _titleLbl.font=kFontNormal;
        _titleLbl.textColor=kColorBlue;//[UIColor whiteColor];
        _titleLbl.textAlignment=NSTextAlignmentCenter;
        _titleLbl.numberOfLines=0;
        _titleLbl.text=title;
        [_alertView addSubview:_titleLbl];
        
        center.frame=CGRectMake(0, _titleLbl.maxY, center.width, center.height);
//        center.backgroundColor=RGBACOLOR(21, 69, 149, 1);
        
        [_alertView addSubview:center];
        
        bottom.frame=CGRectMake(0, center.maxY, bottom.width, bottom.height);
        bottom.backgroundColor=[UIColor clearColor];
        [_alertView addSubview:bottom];

    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title
            customCenterView:(UIView *)cview
                       click:(CompeletClick)cblock
                buttonTitles:(NSArray *)titles{
    if (self=[super init]) {
        _cBlock=[cblock copy];
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        
        self.frame=window.bounds;
        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
        CGFloat alerh;
        UIView *center;
        center=cview;
        
        
        CGFloat bottomh=0.0f;
        CGFloat btnH=35.f;
        if (titles.count>2) {
            bottomh=titles.count*(10+btnH);
        }else{
            bottomh=60;
        }
        UIView *bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenW, bottomh)];
        CGFloat btnW=(bottom.width-40)/titles.count;
        
        for (int i=0; i<titles.count; i++) {
            UIButton *disagress=[[UIButton alloc] init];
            if (titles.count>2) {
                disagress.frame=CGRectMake(20, 10+(btnH+10)*i, bottom.width-40, btnH);
            }else{
                disagress.frame=CGRectMake(20+btnW*i, (bottom.height-btnH)/2, btnW-10, btnH);
            }
            disagress.backgroundColor=[UIColor whiteColor];
            [disagress setTitle:titles[i] forState:UIControlStateNormal];
            [disagress setTitleColor:kColorBlue forState:UIControlStateNormal];
            disagress.cornerRadius=4.f;
            disagress.tag=i;
            disagress.titleLabel.font=kFontNormal;
            [bottom addSubview:disagress];
            [disagress addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bottom addSubview:disagress];
        }
        
        alerh=kTitleHeight+center.height+bottom.height;
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=kColorGray4;//RGBACOLOR(46, 107, 170, 0.9);
        _alertView.center=CGPointMake(self.width/2, self.height/2);
        _alertView.bounds=CGRectMake(0, 0, self.width-40, alerh);
        _alertView.cornerRadius=8.f;

        _titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, kTitleHeight)];
        _titleLbl.font=kFontNormal;
        _titleLbl.textColor=kColorBlue;//[UIColor whiteColor];
        _titleLbl.textAlignment=NSTextAlignmentCenter;
        _titleLbl.numberOfLines=0;
        _titleLbl.text=title;
        [_alertView addSubview:_titleLbl];
        
        center.frame=CGRectMake(0, _titleLbl.maxY, center.width, center.height);
//        center.backgroundColor=RGBACOLOR(21, 69, 149, 1);
        
        [_alertView addSubview:center];
        
        bottom.frame=CGRectMake(0, center.maxY, bottom.width, bottom.height);
        bottom.backgroundColor=[UIColor clearColor];
        [_alertView addSubview:bottom];
        
    }
    return self;

}
-(instancetype)initWithRegisterPhoto:(CompeletClick)cblock{
    if (self=[super init]) {
        _cBlock=[cblock copy];
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);

        self.frame=window.bounds;

        NSString *alertmsg=@"请您上传本人及工作证照片(照片格式不符合要求,将会在30分钟中断服务),工作人员将在2个工作日内进行审核,审核通过后方可使用全部功能.";
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        
        CGSize size=[alertmsg boundingRectWithSize:CGSizeMake(self.width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontMiddle,NSParagraphStyleAttributeName:paragraphStyle1} context:nil].size;

        CGFloat alerh=kTitleHeight+110+30+size.height;

        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=kColorWhite;
        _alertView.center=CGPointMake(self.width/2, self.height/2);
        _alertView.bounds=CGRectMake(0, 0, self.width, alerh);

        _alertView.cornerRadius=5.f;
        
        _titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, kTitleHeight)];
        _titleLbl.font=kFontNormal;
        _titleLbl.textColor=kColorBlue;
        _titleLbl.textAlignment=NSTextAlignmentCenter;
        _titleLbl.numberOfLines=0;
        _titleLbl.text=@"选取照片";
        [_alertView addSubview:_titleLbl];
        
        UIView *center=[[UIView alloc] initWithFrame:CGRectMake(0, _titleLbl.maxY, _alertView.width, 100)];
        center.backgroundColor=kColorBlue;
        [_alertView addSubview:center];
        
        CGFloat btnWH=60;
        DDButton *album=[[DDButton alloc] initWithImageFrame:CGRectMake(0, 0, btnWH, btnWH) withTitleFrame:CGRectMake(0, btnWH, btnWH, 30)];
        album.frame=CGRectMake(center.width/2-60-20, 10, btnWH, center.height-20);
        [album setImage:[UIImage imageNamed:@"album_icon"] forState:UIControlStateNormal];
        [album setTitle:@"相  册" forState:UIControlStateNormal];
        album.tag=0;
        [album addTarget:self action:@selector(albumAndTakePicture:) forControlEvents:UIControlEventTouchUpInside];

        [center addSubview:album];
        
        
        DDButton *takepic=[[DDButton alloc] initWithImageFrame:CGRectMake(0, 0, btnWH, btnWH) withTitleFrame:CGRectMake(0, btnWH, btnWH, 30)];
        takepic.frame=CGRectMake(center.width/2+20, 10, btnWH, center.height-20);
        [takepic setImage:[UIImage imageNamed:@"takepicture_icon"] forState:UIControlStateNormal];
        [takepic setTitle:@"拍  照" forState:UIControlStateNormal];
        takepic.tag=1;
        
        
        [takepic addTarget:self action:@selector(albumAndTakePicture:) forControlEvents:UIControlEventTouchUpInside];
        [center addSubview:takepic];
        
        UILabel *bottom=[[UILabel alloc] initWithFrame:CGRectMake(10, center.maxY+20, _alertView.width-20, size.height)];
        bottom.font=kFontMiddle;
        bottom.numberOfLines=0;
        bottom.textColor=kColorBlue;
        bottom.attributedText=[alertmsg lineSpacing:5];
        [_alertView addSubview:bottom];
        _isOpenTapClose=YES;
    }
    return self;
}
-(instancetype)initWithAlbumPhoto:(CompeletClick)cblock{
    if (self=[super init]) {
        _cBlock=[cblock copy];
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
        
        self.frame=window.bounds;
        
        CGFloat alerh=kTitleHeight+120+15;
        
        _alertView=[[UIView alloc] init];
        _alertView.backgroundColor=kColorGray4;//kColorBlue;
        _alertView.center=CGPointMake(self.width/2, self.height/2);
        _alertView.bounds=CGRectMake(0, 0, self.width-40, alerh);
        _alertView.cornerRadius=8.f;

        _alertView.cornerRadius=5.f;
        
        _titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, kTitleHeight-5)];
        _titleLbl.font=kFontNormal;
        _titleLbl.textColor=kColorBlue;//kColorWhite;
        _titleLbl.textAlignment=NSTextAlignmentCenter;
        _titleLbl.numberOfLines=0;
        _titleLbl.text=@"选取照片";
        [_alertView addSubview:_titleLbl];
        
        UIView *center=[[UIView alloc] initWithFrame:CGRectMake(0, _titleLbl.maxY, _alertView.width, 100)];
//        center.backgroundColor=RGBACOLOR(21, 69, 149, 1);
        
        [_alertView addSubview:center];
        
        CGFloat btnWH=60;
        DDButton *album=[[DDButton alloc] initWithImageFrame:CGRectMake(0, 0, btnWH, btnWH) withTitleFrame:CGRectMake(0, btnWH, btnWH, 30)];
        album.frame=CGRectMake(center.width/2-btnWH-20, 10, btnWH, center.height-20);
        [album setImage:[UIImage imageNamed:@"album_icon"] forState:UIControlStateNormal];
        [album setTitle:@"相  册" forState:UIControlStateNormal];
        [album setTitleColor:kColorBlue forState:UIControlStateNormal];
        album.tag=0;
        [album addTarget:self action:@selector(albumAndTakePicture:) forControlEvents:UIControlEventTouchUpInside];
        
        [center addSubview:album];
        
        
        DDButton *takepic=[[DDButton alloc] initWithImageFrame:CGRectMake(0, 0, btnWH, btnWH) withTitleFrame:CGRectMake(0, btnWH, btnWH, 30)];
        takepic.frame=CGRectMake(center.width/2+20, 10, btnWH, center.height-20);
        [takepic setImage:[UIImage imageNamed:@"takepicture_icon"] forState:UIControlStateNormal];
        [takepic setTitle:@"拍  照" forState:UIControlStateNormal];
        [takepic setTitleColor:kColorBlue forState:UIControlStateNormal];

        takepic.tag=1;
        [takepic addTarget:self action:@selector(albumAndTakePicture:) forControlEvents:UIControlEventTouchUpInside];
        [center addSubview:takepic];
        
        _isOpenTapClose=YES;
//        UIView *bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenW, 49)];
//        [_alertView addSubview:bottom];

    }
    return self;

}
-(instancetype)initWithCustomAlertView:(UIView *)alertView{
    if (self=[super init]) {
        _alertView=alertView;
        UIWindow *window=[UIApplication sharedApplication].keyWindow;

        self.backgroundColor=RGBACOLOR(50, 50, 50, 0.5);
        self.frame=window.bounds;
        self.isOpenTapClose=YES;
    }
    return self;
}
#pragma mark - action
-(void)albumAndTakePicture:(UIButton *)sender{
    
    DRWindow *window=(DRWindow *)[UIApplication sharedApplication].keyWindow;
    if (window.alertCount==0) {
        return;
    }else{
        window.alertCount-=1;
    }

    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _alertView.transform=CGAffineTransformMakeScale(0.6,
                                                                         0.6);
                         self.alpha=0;
                         _alertView.alpha=0;
                     }
                     completion:^(BOOL finished){
                         if (_cBlock) {
                             DLog(@"alertBtnIdx--%d",(int)sender.tag);
                             _cBlock(self,sender.tag);
                         }
                         [_alertView removeFromSuperview];
                         [self removeFromSuperview];
                         
                     }];
    

}
-(void)show{
    
    DRWindow *window=(DRWindow *)[UIApplication sharedApplication].keyWindow;
    if (window.alertCount>0) {
        return;
    }else{
        window.alertCount+=1;
    }
    [window addSubview:self];
    [self addSubview:_alertView];
    
    _alertView.transform=CGAffineTransformMakeScale(0.6,
                                              0.6);
    _alertView.alpha=0;
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.6f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _alertView.transform=CGAffineTransformMakeScale(1,
                                                                   1);
                         _alertView.alpha=1;
                     }
                     completion:^(BOOL finished){
                     }];
    
}
-(void)showInView:(UIView *)view{
    DRWindow *window=(DRWindow *)[UIApplication sharedApplication].keyWindow;
    if (window.alertCount>0) {
        return;
    }else{
        window.alertCount+=1;
    }

    
    [view addSubview:self];
    [self addSubview:_alertView];
    
    _alertView.transform=CGAffineTransformMakeScale(0.6,
                                                    0.6);
    _alertView.alpha=0;
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.6f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _alertView.transform=CGAffineTransformMakeScale(1,
                                                                         1);
                         _alertView.alpha=1;
                     }
                     completion:^(BOOL finished){
                     }];
    
}
-(void)buttonAction:(UIButton *)sender{
    DRWindow *window=(DRWindow *)[UIApplication sharedApplication].keyWindow;
    if (window.alertCount==0) {
        return;
    }else{
        window.alertCount-=1;
    }

    _inputText=[_inputField.text trim];
    [self endEditing:YES];
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _alertView.transform=CGAffineTransformMakeScale(0.6,
                                                                   0.6);
                         self.alpha=0;
                         _alertView.alpha=0;
                     }
                     completion:^(BOOL finished){
                         if (_cBlock) {
                             _cBlock(self,sender.tag);
                         }
                         [_alertView removeFromSuperview];
                         [self removeFromSuperview];
                         

            }];
    
    
}
-(void)close{
    
    DRWindow *window=(DRWindow *)[UIApplication sharedApplication].keyWindow;
    if (window.alertCount==0) {
        return;
    }else{
        window.alertCount-=1;
    }
    

    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _alertView.transform=CGAffineTransformMakeScale(0.6,
                                                                         0.6);
                         self.alpha=0;
                         _alertView.alpha=0;
                     }
                     completion:^(BOOL finished){
                         [_alertView removeFromSuperview];
                         [self removeFromSuperview];
                         
                     }];
}



/*
-(UIImage *)test{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, true, 1);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:screenshot];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}-
*/
//-(void)setIsOpenTapClose:(BOOL)isOpenTapClose{
//    _isOpenTapClose=isOpenTapClose;
//    if (isOpenTapClose) {
//        [self addGestureRecognizer:_tap];
//    }else{
//        [self removeGestureRecognizer:_tap];
//    }
//}
#pragma mark - keyboardFrameChange
-(void)keyboardFrameChange:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat fieldMaxY=_alertView.maxY-kButtonHeight*2;
    
    CGRect frame=self.frame;
    void(^animations)();
    if (endFrame.origin.y<fieldMaxY) {
      CGFloat  changeH=fieldMaxY-endFrame.origin.y;
        frame.origin.y-=changeH;
        animations= ^{
            self.frame=frame;
        };

    }else if (endFrame.origin.y>DScreenH-50){
        frame.origin.y=0;
        animations=^{
            self.frame=frame;
        };
    }
    
    [UIView animateWithDuration:duration delay:0.0f options:0 animations:animations completion:nil];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_isOpenTapClose) {
        [self close];
    }
    [self endEditing:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"YJAlertView");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


