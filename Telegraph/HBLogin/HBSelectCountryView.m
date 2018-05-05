//
//  HBSelectCountryView.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/20.
//  中国 >  点击此view进入国家选择

#import "HBSelectCountryView.h"
#import "UILabel+Utilities.h"

@interface HBSelectCountryView()

@property (nonatomic, strong) UIButton      *button;
@property (nonatomic, strong) UILabel       *textLabel;
@property (nonatomic, strong) UIImageView   *imgView;

@end


@implementation HBSelectCountryView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupUI];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    [self addSubview:self.button];
    [self.button addSubview:self.textLabel];
    [self.button addSubview:self.imgView];
}
- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button addTarget:self
                    action:@selector(buttonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(selectCountryView:selectCountry:)]) {
        [self.delegate selectCountryView:self selectCountry:_country];
    }
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HBColor(78, 78, 78);
        _textLabel.font = [UIFont systemFontOfSize:16];
        _country = _textLabel.text;
    }
    return _textLabel;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"Choose_attribution"];
        _imgView.contentMode = UIViewContentModeCenter;
    }
    return _imgView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGFloat h = bounds.size.height;
    CGFloat w = bounds.size.width;
    
    CGFloat textLabel_w = [_textLabel textWidthWithHeight:h];
    CGFloat gap = 5;//文本与图片间隔
    CGFloat imgView_x = textLabel_w + gap;
    CGFloat imgView_w = 7;
    CGFloat button_w = textLabel_w + imgView_w + gap;
//    CGFloat button_x = (w - button_w) / 2;
//    CGFloat button_x = self.left;//居中改为居左
    
    _button.frame = CGRectMake(0, 0, self.width, h);
    _textLabel.frame = CGRectMake(0, 0, textLabel_w, h);
    _imgView.frame = CGRectMake(imgView_x, 0, imgView_w, h);
}

#pragma mark - setter
- (void)setCountry:(NSString *)country
{
    _country = country;
    self.textLabel.text = country;
    //设置国家后根据文本重新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
}




@end
