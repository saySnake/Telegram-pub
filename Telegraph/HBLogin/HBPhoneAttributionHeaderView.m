//
//  HBPhoneAttributionHeaderView.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/5/2.
//

#import "HBPhoneAttributionHeaderView.h"


@interface HBPhoneAttributionHeaderView()

@property (nonatomic ,strong)UILabel *titleLabel;

@end

@implementation HBPhoneAttributionHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor_alpha(255, 255, 255, .8);
        _titleLabel = [createLbaelButView createLabelFrame:CGRectZero font:10 text:@"常用" textColor:[UIColor blackColor]];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(15*WIDTHRation);
            make.height.mas_equalTo(14 * HeightRation);
        }];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
