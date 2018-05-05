//
//  HBMoreViewItem.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/16.
//

#import "HBMoreViewItem.h"
#import "UIView+Addition.h"

@interface HBMoreViewItem ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation HBMoreViewItem

/**
 *  创建一个ICChatBoxMoreViewItem
 *
 *  @param title     item的标题
 *  @param imageName item的图片
 *
 *  @return item
 */
+ (HBMoreViewItem *)createChatBoxMoreItemWithTitle:(NSString *)title imageName:(NSString *)imageName{
    HBMoreViewItem *item = [[HBMoreViewItem alloc] init];
    item.title = title;
    item.imageName = imageName;
    return item;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.button];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    float w = 59;
    [self.button setFrame:CGRectMake((self.width - w) / 2, 14, w, w)];
    [self.titleLabel setFrame:CGRectMake(-5, self.button.height + 17, self.width + 10, 15)];
}

#pragma mark - Public Method

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    [self.button setTag:tag];
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.titleLabel setText:title];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
#pragma mark - Getter

- (UIButton *)button
{
    if (_button == nil) {
        _button = [[UIButton alloc] init];
        [_button.layer setMasksToBounds:YES];
        [_button.layer setCornerRadius:4.0f];
        [_button.layer setBorderWidth:0.5f];
        [_button.layer setBorderColor:[UIColor grayColor].CGColor];
    }
    return _button;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

@end
