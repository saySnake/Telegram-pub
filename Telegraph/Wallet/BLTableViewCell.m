//
//  BLTableViewCell.m
//  自定义cell侧滑删除按钮2
//
//  Created by asd on 16/7/1.
//  Copyright © 2016年 liguoqing. All rights reserved.
//

#import "BLTableViewCell.h"

@interface BLTableViewCell()
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UILabel *showlabel;
@property (nonatomic, weak) UIButton *deleBtn;
@property (nonatomic, weak) UIView *underView;
@property (nonatomic, assign) BOOL isOpenLeft;

@end

@implementation BLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableview{
    
    static NSString *ID = @"cell";
    
    BLTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[BLTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID
                ];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    
    return self;
}
//初始化界面
- (void)createUI{
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:deleBtn];
    self.deleBtn = deleBtn;
    deleBtn.backgroundColor = [UIColor redColor];
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleBtn setTintColor:[UIColor blackColor]];
    [deleBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc]init];
    [self.contentView addSubview:containerView];
    self.containerView = containerView;
    self.containerView.backgroundColor = [UIColor greenColor];
    
    //分割线
    UIView *underView = [[UIView alloc]init];
    [self.containerView addSubview:underView];
    self.underView = underView;
    self.underView.backgroundColor = [UIColor purpleColor];
    
    //给容器视图半丁左右滑动的清扫手势
    UISwipeGestureRecognizer *leftswipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.containerView addGestureRecognizer:leftswipe];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.containerView addGestureRecognizer:rightSwipe];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置容器视图显示在最上层
    [self.contentView bringSubviewToFront:self.containerView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.containerView.frame = self.contentView.bounds;
    self.deleBtn.frame = CGRectMake(self.frame.size.width - 50, 0, 50, self.contentView.frame.size.height);
    self.underView.frame = CGRectMake(15, 59, self.frame.size.width - 15, 1);
}

- (void)deleteCell:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(deleteCell:)]) {
        [self.delegate deleteCell:self];
    }
}

- (void)swipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        if (self.isOpenLeft) return; //已经打开左滑，不再执行
        
        //开始左滑： 先调用代理关闭其他cell的左滑
        if ([self.delegate respondsToSelector:@selector(closeOtherCellLeftSwipe)])
            [self.delegate closeOtherCellLeftSwipe];
        
        [UIView animateWithDuration:0.5 animations:^{
//            swipe.view.center = CGPointMake(0, self.frame.size.height/2);
            self.containerView.frame=CGRectMake(-50, 0, self.frame.size.width, 60.0f);
        }];
        self.isOpenLeft = YES;
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        [self closeSwipe]; //关闭左滑
    }
}

-(void)closeSwipe
{
    if (!self.isOpenLeft) return; //还未打开左滑，不需要执行右滑
    
    [UIView animateWithDuration:0.5 animations:^{
        self.containerView.center = CGPointMake(self.frame.size.width/2 , self.frame.size.height/2 );
    }];
    self.isOpenLeft = NO;
}
@end
