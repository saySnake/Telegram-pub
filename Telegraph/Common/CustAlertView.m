
//
//  CustAlertView.m
//  MemberLoan
//
//  Created by 张玮 on 2017/1/9.
//  Copyright © 2017年 张玮. All rights reserved.
//

#import "CustAlertView.h"
@interface CustAlertView ()<UITextFieldDelegate ,UITextViewDelegate>
{
    CGFloat orgY;
}

@property (nonatomic ,weak) UIView *mask;

@property (nonatomic, weak) UIButton *mainBtn;

@property (nonatomic, weak) UITextField *inputField;

@property (nonatomic, weak) UITextView *inputView;

@end
@implementation CustAlertView


+(CustAlertView *)creatWithMainButton:(NSString *)mainButton OptionButton:(NSString *)optionButton Title:(NSString *)title Content:(NSString *)content{
    
    CustAlertView *alert=[[CustAlertView alloc]init];
    [UIImage imageNamed:@"clear_back"];
    alert.userInteractionEnabled=YES;
    
    //添加标题
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 30, alert.width-72, 21)];
    titleLabel.text=title;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor =[UIColor blackColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [alert addSubview:titleLabel];
    
    
    //添加正文
    if (content&&![content isEqual:@""]) {
        
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 63, alert.width-72, 16)];
        contentLabel.text=content;
        contentLabel.font=[UIFont systemFontOfSize:14];
        contentLabel.textColor=HEXCOLOR(0x717476);
        contentLabel.textAlignment=NSTextAlignmentCenter;
        [alert addSubview:contentLabel];
        contentLabel.numberOfLines=0;
        // [contentLabel sizeToFit];
        
        contentLabel.height=[contentLabel sizeThatFits:contentLabel.size].height;
        int delta=contentLabel.height-16;
        if (delta>0) {
            alert.height+=delta;
            alert.centreY-=delta/2;
        }
        
    }else{
        titleLabel.centreY+=4;
        alert.height-=28;
        alert.centreY+=14;
    }
    
    
    //添加按钮
    UIButton *mainBtn=[[UIButton alloc]initWithFrame:CGRectMake(174, alert.height-39-35, 113, 35)];
    [mainBtn setBackgroundColor:HEXCOLOR(0xfe7541)];
    [mainBtn setTitleColor:HEXCOLOR(0x7EA2A9) forState:UIControlStateHighlighted];
    [mainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mainBtn setTitle:mainButton forState:UIControlStateNormal];
    mainBtn.cornerRadius =3;
    [alert addSubview:mainBtn];
    [mainBtn addTarget:alert action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    mainBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    mainBtn.tag=0;
    
    if (optionButton&&![optionButton isEqual:@""]) {
        UIButton *optBtn=[[UIButton alloc]initWithFrame:CGRectMake(39, alert.height-39-35, 113, 35)];
        [optBtn setTitleColor:HEXCOLOR(0x7EA2A9) forState:UIControlStateHighlighted];
        [optBtn setTitleColor:KBaseColor forState:UIControlStateNormal];
        [optBtn setTitle:optionButton forState:UIControlStateNormal];
        [alert addSubview:optBtn];
        [optBtn addTarget:alert action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        optBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        optBtn.tag=1;
    }else{
        mainBtn.centreX=alert.width/2;
    }
    
    return alert;
}

+(CustAlertView *)creatNoNetworkAlert
{
    CustAlertView *alert=[[CustAlertView alloc]init];
    alert.userInteractionEnabled=YES;
    [UIImage imageNamed:@"clear_back"];
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 36, alert.width-72, 16)];
    contentLabel.text =@"网络不给力，请检查网络";
    contentLabel.font=kFontLarge_1;
    contentLabel.textColor=[UIColor blackColor];
    contentLabel.textAlignment=NSTextAlignmentCenter;
    [alert addSubview:contentLabel];
    contentLabel.height=[contentLabel sizeThatFits:contentLabel.size].height;
    int delta=MAX(0,contentLabel.height-16);
    contentLabel.numberOfLines=0;
    alert.height+=delta;
    alert.centreY-=delta/2;
    UILabel *line =[[UILabel alloc] init];
    
    CGFloat centerx =alert.frame.size.width *0.5;
    CGFloat centery =alert.frame.size.height *0.5;

    line.frame =(CGRect){centerx,centery,alert.width-40,0.7};
    line.center =CGPointMake(centerx, centery);
    line.backgroundColor =[UIColor lightGrayColor];
    [alert addSubview:line];
    
    UIButton *mainBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, alert.height-39-35, alert.width-60, 35)];
    mainBtn.tag =1;
    [mainBtn setTitleColor:RGBACOLOR(246.0f, 36.f, 0, 1) forState:UIControlStateNormal];
    [mainBtn setTitle:@"确 定" forState:UIControlStateNormal];
    mainBtn.titleLabel.font =kFontLarge;
    [mainBtn addTarget:alert action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    [alert addSubview:mainBtn];
    return alert;
}




/**
 *  驳回报销单
 *
 */
+(CustAlertView *)creatRejectAlert{
    CustAlertView *alert=[[CustAlertView alloc]init];
    alert.userInteractionEnabled=YES;
    
    //添加标题
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 30, alert.width-72, 21)];
    titleLabel.text=@"驳回报销";
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor=HEXCOLOR(0x546979);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [alert addSubview:titleLabel];
    
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 57, alert.width-72, 16)];
    contentLabel.text=@"请填写该报销被驳回的原因";
    contentLabel.font=[UIFont systemFontOfSize:13];
    contentLabel.textColor=HEXCOLOR(0xA8AEAF);
    contentLabel.textAlignment=NSTextAlignmentCenter;
    [alert addSubview:contentLabel];
    contentLabel.numberOfLines=1;
    
    
    int delta=70;
    alert.height+=delta;
    alert.centreY-=delta/2;
    
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(32, 86, alert.width-64, 68)];
    [alert addSubview:textView];
    
    textView.backgroundColor=HEXCOLOR(0xF7F7F7);
    textView.tintColor=HEXCOLOR(0x4D4D4D);
    textView.textColor=HEXCOLOR(0x4D4D4D);
    textView.font=[UIFont systemFontOfSize:14];
    textView.layer.borderWidth=0.5;
    textView.layer.borderColor=HEXCOLOR(0xB5C4C9).CGColor;
    textView.returnKeyType=UIReturnKeyDone;
    textView.delegate=alert;
    alert.inputView=textView;
    [[NSNotificationCenter defaultCenter] addObserver:alert selector:@selector(startEdit:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:alert selector:@selector(endEdit:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:alert selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:alert.inputView];
    
    
    //添加按钮
    UIButton *mainBtn=[[UIButton alloc]initWithFrame:CGRectMake(174, alert.height-39-35, 113, 35)];
    [mainBtn setTitleColor:HEXCOLOR(0x7EA2A9) forState:UIControlStateHighlighted];
    [mainBtn setTitleColor:HEXCOLOR(0xB5C4C9) forState:UIControlStateDisabled];
    [mainBtn setTitleColor:KBaseColor forState:UIControlStateNormal];
    [mainBtn setTitle:@"驳回" forState:UIControlStateNormal];
    [alert addSubview:mainBtn];
    [mainBtn addTarget:alert action:@selector(rejectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    mainBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    mainBtn.tag=0;
    mainBtn.enabled=NO;
    alert.mainBtn=mainBtn;
    
    UIButton *optBtn=[[UIButton alloc]initWithFrame:CGRectMake(39, alert.height-39-35, 113, 35)];
    [optBtn setTitleColor:HEXCOLOR(0x7EA2A9) forState:UIControlStateHighlighted];
    [optBtn setTitleColor:KBaseColor forState:UIControlStateNormal];
    [optBtn setTitle:@"取消" forState:UIControlStateNormal];
    [alert addSubview:optBtn];
    [optBtn addTarget:alert action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    optBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    optBtn.tag=1;
    
    return alert;
}



+(CustAlertView *)creatApproveAlertWithContent:(NSString *)content{
    
    CustAlertView *alert=[[CustAlertView alloc]init];
    alert.userInteractionEnabled=YES;
    
    //添加标题
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 30, alert.width-72, 21)];
    titleLabel.text=@"同意并转发给";
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor=HEXCOLOR(0x546979);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [alert addSubview:titleLabel];
    
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 57, alert.width-72, 16)];
    contentLabel.text=content;
    contentLabel.font=[UIFont systemFontOfSize:13];
    contentLabel.textColor=HEXCOLOR(0x717476);
    contentLabel.textAlignment=NSTextAlignmentCenter;
    [alert addSubview:contentLabel];
    contentLabel.numberOfLines=0;
    contentLabel.height=[contentLabel sizeThatFits:contentLabel.size].height;
    int delta=MAX(0,contentLabel.height-16);
    alert.height+=delta;
    alert.centreY-=delta/2;
    
    
    
    
    UITextField *textView=[[UITextField alloc]initWithFrame:CGRectMake(32, 86+delta, alert.width-64, 41)];
    [alert addSubview:textView];
    
    delta=42;
    alert.height+=delta;
    alert.centreY-=delta/2;
    
    textView.backgroundColor=HEXCOLOR(0xF7F7F7);
    textView.tintColor=HEXCOLOR(0x4D4D4D);
    textView.textColor=HEXCOLOR(0x4D4D4D);
    textView.font=[UIFont systemFontOfSize:14];
    textView.layer.borderWidth=0.5;
    textView.layer.borderColor=HEXCOLOR(0xB5C4C9).CGColor;
    textView.returnKeyType=UIReturnKeyDone;
    textView.delegate=alert;
    textView.placeholder=@"添加批注(选填)";
    [textView setValue:HEXCOLOR(0xB5C4C9) forKeyPath:@"_placeholderLabel.textColor"];
    [textView setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    CGRect frame = textView.frame;
    frame.size.width = 10.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textView.leftViewMode = UITextFieldViewModeAlways;
    textView.leftView = leftview;
    alert.inputField=textView;
    [[NSNotificationCenter defaultCenter] addObserver:alert selector:@selector(startEdit:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:alert selector:@selector(endEdit:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:alert selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:alert.inputField];
    
    //添加按钮
    UIButton *mainBtn=[[UIButton alloc]initWithFrame:CGRectMake(174, alert.height-39-35, 113, 35)];
    [mainBtn setTitleColor:HEXCOLOR(0x7EA2A9) forState:UIControlStateHighlighted];
    [mainBtn setTitleColor:HEXCOLOR(0xB5C4C9) forState:UIControlStateDisabled];
    [mainBtn setTitleColor:KBaseColor forState:UIControlStateNormal];
    [mainBtn setTitle:@"发送" forState:UIControlStateNormal];
    [alert addSubview:mainBtn];
    [mainBtn addTarget:alert action:@selector(approveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    mainBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    mainBtn.tag=0;
    alert.mainBtn=mainBtn;
    
    UIButton *optBtn=[[UIButton alloc]initWithFrame:CGRectMake(39, alert.height-39-35, 113, 35)];
    [optBtn setTitleColor:HEXCOLOR(0x7EA2A9) forState:UIControlStateHighlighted];
    [optBtn setTitleColor:KBaseColor forState:UIControlStateNormal];
    [optBtn setTitle:@"取消" forState:UIControlStateNormal];
    [alert addSubview:optBtn];
    [optBtn addTarget:alert action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    optBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    optBtn.tag=1;
    
    return alert;
    
}
- (void)showAlerViewWithVC:(UIViewController *)viewController
{
    UIView *m=[[UIView alloc]initWithFrame:viewController.view.frame];
    [viewController.view addSubview:m];
    m.backgroundColor=[UIColor blackColor];
    m.alpha=0;
    self.mask=m;
    [viewController.view addSubview:self];
    self.transform=CGAffineTransformMakeScale(0.6, 0.6);
    self.alpha=0;
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform=CGAffineTransformMakeScale(1, 1);
                         self.alpha=1;
                         m.alpha=0.37;
                     }
                     completion:^(BOOL finished){
                         if (self.inputView) {
                             [self.inputView becomeFirstResponder];
                         }
                     }];
}

-(void)showAlertInViewController:(UIWindow *)vc{
    UIView *m=[[UIView alloc]initWithFrame:vc.frame];
    [vc addSubview:m];
    m.backgroundColor=[UIColor blackColor];
    m.alpha=0;
    self.mask=m;
    
    [[[[UIApplication sharedApplication] delegate] window ] addSubview:self];
    self.transform=CGAffineTransformMakeScale(0.6, 0.6);
    self.alpha=0;
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform=CGAffineTransformMakeScale(1, 1);
                         self.alpha=1;
                         m.alpha=0.47;
                     }
                     completion:^(BOOL finished){
                         if (self.inputView) {
                             [self.inputView becomeFirstResponder];
                         }
                     }];
}

-(id)init{
    int y=0.44*DScreenH-90;
    
    int x =(DScreenW -320) /2;
    int w =320;
    int h =166;
    self=[super initWithFrame:CGRectMake(x, y,w , h)];
    
    self.image=[UIImage resizeWithName:@"clear_back"];
    
    
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dismissAlert{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform=CGAffineTransformMakeScale(0.6, 0.6);
                         self.alpha=0;
                         self.mask.alpha=0;
                         [self removeFromSuperview];

                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [[NSNotificationCenter defaultCenter] removeObserver:self];
                     }];
}

-(void)actionButton:(id)sender{
    if (self.itemClicked) {
        self.itemClicked([sender tag]);
    }
    
    [self dismissAlert];
}

-(void)cancelButtonClicked{
    [self dismissAlert];
}

-(void)rejectButtonClicked{
    [self dismissAlert];
    if (self.rejectClicked) {
        self.rejectClicked(self.inputView.text);
    }
}

-(void)approveButtonClicked{
    [self dismissAlert];
    if (self.approveClicked) {
        self.approveClicked(self.inputField.text);
    }
    
}
#pragma mark -处理键盘
-(void)startEdit:(NSNotification *)noti{
    NSLog(@"显示键盘%@",noti.userInfo);
    NSValue *value = [[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardY = DScreenH-[value CGRectValue].size.height;
    CGFloat maxY=CGRectGetMaxY(self.frame);
    if (maxY>keyboardY) {
        orgY=self.centreY;
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:3.0f options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.centreY= self.centreY -(maxY-keyboardY);
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    
}
-(void)endEdit:(NSNotification *)noti{
    if (orgY!=0&&orgY) {
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:3.0f options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.centreY=orgY;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -处理驳回文本框

-(void)textChange{
    [self characterLimit:140 inTextView:self.inputView];
    if (self.inputView.text.length==0) {
        self.mainBtn.enabled=NO;
    }else{
        self.mainBtn.enabled=YES;
    }
}

-(void)characterLimit:(int)max inTextView:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    NSString * newText = [textView textInRange:selectedRange];
    
    
    int count=(int)[self unicodeLengthOfString:textView.text]-(int)[self unicodeLengthOfString:newText];
    
    if (count>max) {
        textView.text = [textView.text substringToIndex:max+1];
        if ([self unicodeLengthOfString:textView.text]>max) {
            textView.text = [textView.text substringToIndex:max];
        }
    }
}



-(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}

#pragma mark -处理同意文本框
-(void)textFieldChange{
    [self characterLimit:140 inTextView:self.inputField];
}


@end
