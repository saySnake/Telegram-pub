//
//  HBFindSectionView.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import "HBFindSectionView.h"

@implementation HBFindSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *iconLable = [[UILabel alloc] initWithFrame:CGRectMake(13, (48-16)/2, 6, 16)];
        iconLable.backgroundColor = UIColorFromRGB(51, 51, 51);
        iconLable.layer.cornerRadius = 1.4f;
        [self addSubview:iconLable];
        
        _namelab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconLable.frame)+8, (48-16)/2, 130.0f, 16.0f)];
        _namelab.backgroundColor = [UIColor clearColor];
        _namelab.textAlignment = NSTextAlignmentLeft;
        _namelab.textColor =UIColorFromRGB(47, 47, 47);
        _namelab.font = [UIFont systemFontOfSize:16.0f];
        _namelab.text = @"行情";
        [self addSubview:_namelab];
        
        _txtlab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-13-50, (48-12)/2, 50, 12.0f)];
        _txtlab.backgroundColor = [UIColor whiteColor];
        _txtlab.textAlignment = NSTextAlignmentLeft;
        _txtlab.text = @"查看行情";
        _txtlab.textColor =UIColorFromRGB(87, 87, 87);
        _txtlab.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_txtlab];
    }
    return self;
}

-(void)setTitle:(NSString *)title more:(NSString *)more
{
    _namelab.text = title;
    _txtlab.text = more;
    [self layoutIfNeeded];
}

@end
