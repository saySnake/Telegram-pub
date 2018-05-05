//
//  HTCodeAuthView.m
//  Telegraph
//
//  Created by Jiyu Jiyu on 2018/5/2.
/*
 5.对于登陆小窗口的封装建议
 5.1 所有的view基于一个基类view  : loginview  registerview
 5.2 注意所有的view 在点击下一步的时候,都有一个嵌套关系;即abc,c点返回,a需要由上往下弹出;以此类推
 
 
 
 6.验证码验证封装场景
 1.根据风控,弹出视图,点击确定完成输入
 2.如果输入错误,则需要再次弹出视图   此类事hidden还是nil+removefromsuperview后再创建
 
 3.是在初始化的时候,直接传入枚举,根据枚举创建对应的view  还是创建全部的view,  根据枚举修改height(可直接在初始化时,传入枚举,根据枚举直接创建对应的view ,三个view 可以采用懒加载即可)
 
 
 4.在init中给zero  在set中frame 给煤句 hidden  在layout中 给frame  懒加载三个view
 
 5.给点击再次获取图片验证码  一个公开方法,直接设置image
 
 
 ps: 封装的view 点击 确定 返回需要传 判断相关的类型判断出去  如找回密码页面
 1.如果用户risk时,如果需要图片验证,那么输入完图片验证码之后,需要去再次调用是resetVerifyCode验证的接口;
 2.这一步骤过了之后,  会返回 model ,根据model 来显示是否需要手机号验证和google验证;
 3.这时候再次弹出codeview,那么输入完成之后,肯定是不能去调resetVerifyCode,而应该调用resetVerifySafe
 4.这两个接口是不一样的,需要通过代理参数判断
 
 
 此种问题建议直接用blcok解决,最为方便,区分参数都不用
 
 实现多个view多种情况,实现blcok回调,便于处理各种业务之间的冲突
 */

#import "HTCodeAuthView.h"
#define CodeViewWidth (300 *WIDTHRation)
#define HEADViewHeight (63*HeightRation)
#define SmgViewHeight (88*HeightRation)
#define GoogleViewHeight (88*HeightRation)
#define ImageViewHeight (88*HeightRation)
#define ButtonViewHeight (44.1 *HeightRation)



@interface HTCodeAuthView ()

//整个子view
@property (nonatomic ,strong) UIView *HeadView;
@property (nonatomic ,strong) UIView *SmgView;
@property (nonatomic ,strong) UIView *GoogleView;
@property (nonatomic ,strong) UIView *ImageView;
@property (nonatomic ,strong) UIView *ButtonView;

@property (nonatomic ,strong) UIButton *sureBut;

@end

@implementation HTCodeAuthView

- (instancetype)init{
    self = [super init];
    if (self) {
        //固定子view
        self.backgroundColor = [UIColor blueColor];
//        直接在此处创建,添加,给定frame
        self.HeadView.frame = CGRectMake(0, 0, CodeViewWidth, HEADViewHeight);
        [self addSubview:self.HeadView];
//        self.ButtonView.frame = CGRectMake(0, self.bottom - ButtonViewHeight, CodeViewWidth, ButtonViewHeight);
        [self addSubview:self.ButtonView];
    }
    return self;
}
-(void)setType:(HTCodeViewType)type{
    _type = type;
//    CGFloat width = 300 *WIDTHRation;
    CGFloat height = HEADViewHeight ;//HEADViewHeight + ButtonViewHeight;
    switch (type) {
        case AllPhoneGoogleImage:{
            //懒加载
            //先 给 子view frame  再addsubview  //子view的宽度
//            self.HeadView.frame = CGRectMake(0, 0, CodeViewWidth, HEADViewHeight);
//            [self addSubview:self.HeadView];
            self.SmgView.frame = CGRectMake(0, height, CodeViewWidth, SmgViewHeight);
            [self addSubview:self.SmgView];
            height += SmgViewHeight;
            
            self.GoogleView.frame = CGRectMake(0, height, CodeViewWidth, GoogleViewHeight);
            [self addSubview:self.GoogleView];
            height += GoogleViewHeight;
            
            self.ImageView.frame = CGRectMake(0, height, CodeViewWidth,ImageViewHeight);
            [self addSubview:self.ImageView];
            height += ImageViewHeight;

            self.ButtonView.frame = CGRectMake(0, height, CodeViewWidth, ButtonViewHeight);
            height += ButtonViewHeight;
            //最后根据height 给整体self.frame 不需要在外面给,外面直接alloc init就成
            self.frame = CGRectMake(0, 0, CodeViewWidth, height);
        }
            break;
        case OnlyPhone:{
            self.SmgView.frame = CGRectMake(0, height, CodeViewWidth, SmgViewHeight);
            [self addSubview:self.SmgView];
            height += SmgViewHeight;

            self.ButtonView.frame = CGRectMake(0, height, CodeViewWidth, ButtonViewHeight);
            height += ButtonViewHeight;
            //最后根据height 给整体self.frame 不需要在外面给,外面直接alloc init就成
            self.frame = CGRectMake(0, 0, CodeViewWidth, height);
        }
            
            break;
        case OnlyGoogle:{
            self.GoogleView.frame = CGRectMake(0, height, CodeViewWidth, GoogleViewHeight);
            [self addSubview:self.GoogleView];
            height += GoogleViewHeight;

            self.ButtonView.frame = CGRectMake(0, height, CodeViewWidth, ButtonViewHeight);
            height += ButtonViewHeight;
            //最后根据height 给整体self.frame 不需要在外面给,外面直接alloc init就成
            self.frame = CGRectMake(0, 0, CodeViewWidth, height);
        }
            
            break;
        case OnlyImage:{
            self.ImageView.frame = CGRectMake(0, height, CodeViewWidth,ImageViewHeight);
            [self addSubview:self.ImageView];
            height += ImageViewHeight;
            
            self.ButtonView.frame = CGRectMake(0, height, CodeViewWidth, ButtonViewHeight);
            height += ButtonViewHeight;
            //最后根据height 给整体self.frame 不需要在外面给,外面直接alloc init就成
            self.frame = CGRectMake(0, 0, CodeViewWidth, height);
        }
            
            break;
        case BothPhoneGoogle:{
            self.SmgView.frame = CGRectMake(0, height, CodeViewWidth, SmgViewHeight);
            [self addSubview:self.SmgView];
            height += SmgViewHeight;
            
            self.GoogleView.frame = CGRectMake(0, height, CodeViewWidth, GoogleViewHeight);
            [self addSubview:self.GoogleView];
            height += GoogleViewHeight;

            self.ButtonView.frame = CGRectMake(0, height, CodeViewWidth, ButtonViewHeight);
            height += ButtonViewHeight;
            //最后根据height 给整体self.frame 不需要在外面给,外面直接alloc init就成
            self.frame = CGRectMake(0, 0, CodeViewWidth, height);
        }
            
            break;
        case BothImageGoogle:{
            self.GoogleView.frame = CGRectMake(0, height, CodeViewWidth, GoogleViewHeight);
            [self addSubview:self.GoogleView];
            height += GoogleViewHeight;
            
            self.ImageView.frame = CGRectMake(0, height, CodeViewWidth,ImageViewHeight);
            [self addSubview:self.ImageView];
            height += ImageViewHeight;
            
            self.ButtonView.frame = CGRectMake(0, height, CodeViewWidth, ButtonViewHeight);
            height += ButtonViewHeight;
            //最后根据height 给整体self.frame 不需要在外面给,外面直接alloc init就成
            self.frame = CGRectMake(0, 0, CodeViewWidth, height);
        }
            
            break;
        default:
            break;
    }
}

//头部
-(UIView *)HeadView{
    if (!_HeadView) {//CGRectMake(0, 0, self.width, HEADViewHeight)
        _HeadView = [[UIView alloc]initWithFrame:CGRectZero];
        _HeadView.backgroundColor = [UIColor redColor];//HBColor_alpha(255, 255, 255, .95)
        [self addHeadSubViews];
    }
    return _HeadView;
}
-(void)addHeadSubViews{
    UILabel *titleLab = [createLbaelButView createLabelFrame:CGRectZero font:16 text:@"安全验证" textColor:HBColor(34, 34, 34)];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_HeadView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_HeadView.mas_top).offset(25*HeightRation);
        make.left.mas_equalTo(_HeadView.mas_left).offset(30*WIDTHRation);
        make.height.mas_equalTo(15*HeightRation);
    }];
}
//尾部
-(UIView *)ButtonView{
    if (!_ButtonView) {
        _ButtonView = [[UIView alloc]initWithFrame:CGRectZero];
        _ButtonView.backgroundColor = [UIColor greenColor];//HBColor_alpha(255, 255, 255, .95)
        [self addButtonSubview];
    }
    return _ButtonView;
}
-(void)addButtonSubview{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CodeViewWidth, 1)];
    line.backgroundColor = HBColor(233, 233, 233);//HBColor(233, 233, 233)
    [_ButtonView addSubview:line];
    
    _sureBut = [createLbaelButView createButtonFrame:CGRectZero backImageName:nil title:@"确认" titleColor:HBColor(34, 34, 34) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] backColor:[UIColor clearColor]];
    [_ButtonView addSubview:_sureBut];
    [_sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.mas_equalTo(_ButtonView.mas_left);
        make.size.equalTo(_ButtonView).sizeOffset(CGSizeMake(0, -line.height));
    }];
}
//信息
-(UIView *)SmgView{
    if (!_SmgView) {
        _SmgView = [[UIView alloc]initWithFrame:CGRectZero];
        _SmgView.backgroundColor = [UIColor greenColor];//HBColor_alpha(255, 255, 255, .95)
        [self addSmgSubview];
    }
    return _ButtonView;
}
-(void)addSmgSubview{
    
}
//google
-(UIView *)GoogleView{
    if (!_GoogleView) {
        _GoogleView = [[UIView alloc]initWithFrame:CGRectZero];
        _GoogleView.backgroundColor = [UIColor cyanColor];//HBColor_alpha(255, 255, 255, .95)
                [self addGoogleSubview];
    }
    return _GoogleView;
}
-(void)addGoogleSubview{
    
}
//图片验证
-(UIView *)ImageView{
    if (!_ImageView) {
        _ImageView = [[UIView alloc]initWithFrame:CGRectZero];
        _ImageView.backgroundColor = [UIColor blackColor];//HBColor_alpha(255, 255, 255, .95)
                [self addImageSubview];
    }
    return _ImageView;
}
-(void)addImageSubview{
    
}



@end
