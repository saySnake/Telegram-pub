//
//  HBPriceTableViewCell.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import "HBPriceTableViewCell.h"
#import "HBPriceModel.h"
#import "HBTextUtil.h"

@implementation HBPriceTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLable =[[UILabel alloc] init];
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = UIColorFromRGB(31, 62, 86);
        _nameLable.font =  [UIFont systemFontOfSize:16.0f];
        _nameLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLable];
        
       _platormLable =[[UILabel alloc] init];
        _platormLable.textAlignment = NSTextAlignmentLeft;
        _platormLable.textColor = [UIColor lightGrayColor];
        _platormLable.font =  [UIFont systemFontOfSize:12.0f];
        _platormLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_platormLable];
        
        _countLable =[[UILabel alloc] init];
        _countLable.textAlignment = NSTextAlignmentLeft;
        _countLable.textColor = [UIColor darkGrayColor];
        _countLable.font =  [UIFont systemFontOfSize:12.0f];
        _countLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_countLable];
        
        _priceLable =[[UILabel alloc] init];
        _priceLable.textAlignment = NSTextAlignmentCenter;
        _priceLable.textColor = [UIColor darkGrayColor];
        _priceLable.font =  [UIFont systemFontOfSize:16.0f];
        _priceLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_priceLable];
        
        _dollarLable =[[UILabel alloc] init];
        _dollarLable.textAlignment = NSTextAlignmentCenter;
        _dollarLable.textColor = [UIColor lightGrayColor];
        _dollarLable.font =  [UIFont systemFontOfSize:12.0f];
        _dollarLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_dollarLable];
        
        _levelLable =[[UILabel alloc] init];
        _levelLable.textAlignment = NSTextAlignmentCenter;
        _levelLable.textColor = [UIColor whiteColor];
        _levelLable.font =  [UIFont systemFontOfSize:12.0f];
        _levelLable.backgroundColor = UIColorFromRGB(31, 191, 136);
        [self addSubview:_levelLable];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    _nameLable.frame = CGRectMake(10, 10,[HBTextUtil getTxtSize:_nameLable.text font:_nameLable.font].width , 18);
    _platormLable.frame = CGRectMake(CGRectGetMaxX(_nameLable.frame), CGRectGetMinY(_nameLable.frame)+2, size.width/6, 14.0f);
    _countLable.frame = CGRectMake(CGRectGetMinX(_nameLable.frame), CGRectGetMaxY(_nameLable.frame)+10, size.width/3, 14);
    
    _dollarLable.frame = CGRectMake(size.width/3, 10, size.width/3, 18);
    _priceLable.frame = CGRectMake(CGRectGetMinX(_dollarLable.frame), size.height/2+10, size.width/3,14);
    
    _levelLable.frame = CGRectMake(size.width*2/3+10, (size.height-30)/2, size.width/3-10-10, 30);
}

-(void)setInfo:(HBPriceModel *)model
{
    _nameLable.text = model.name;
    _platormLable.text = model.platorm;
    _countLable.text = [NSString stringWithFormat:@"24h量 %lld",model.count];
    _priceLable.text = [NSString stringWithFormat:@"¥%.2f",model.price];
    _dollarLable.text = [NSString stringWithFormat:@"%.2f",model.price/6];
    _levelLable.text = [NSString stringWithFormat:@"%.2f",model.level * 100];
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
