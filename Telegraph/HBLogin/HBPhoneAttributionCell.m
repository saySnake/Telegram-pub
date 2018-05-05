//
//  HBPhoneAttributionCell.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import "HBPhoneAttributionCell.h"

@implementation HBPhoneAttributionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.coutryLab];
        [self.coutryLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(15*WIDTHRation);
            make.height.mas_equalTo(14 * HeightRation);
        }];
        [self.contentView addSubview:self.codeLbel];
        [self.codeLbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self.mas_right).offset(- 15*WIDTHRation);
            make.height.mas_equalTo(14 * HeightRation);
        }];
    }
    return self;
}
-(UILabel *)codeLbel{
    if (!_codeLbel) {
        //CGRectMake(326*WIDTHRation , 0, 34, 14)
        _codeLbel = [[UILabel alloc]initWithFrame:CGRectZero];
        _codeLbel.centerY = self.contentView.centerY;
//        _codeLbel.right = self.contentView.right ;
        _codeLbel.textAlignment = NSTextAlignmentRight;
        _codeLbel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _codeLbel.adjustsFontSizeToFitWidth = YES;
        _codeLbel.textColor = HBColor(163, 169, 172);
    }
    return _codeLbel;
}
-(UILabel *)coutryLab{
    if (!_coutryLab) {
        _coutryLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _coutryLab.centerY = self.contentView.centerY;
        _coutryLab.textAlignment = NSTextAlignmentLeft;
        _coutryLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _coutryLab.adjustsFontSizeToFitWidth = YES;
        _coutryLab.textColor = HBColor(78, 78, 78);
    }
    return _coutryLab;
}
-(void)setCoutryMod:(HBCountry *)CoutryMod{
    _CoutryMod = CoutryMod;
    _coutryLab.text = _CoutryMod.name_cn;
    _codeLbel.text = [NSString stringWithFormat:@"+%@", _CoutryMod.area_code];
}
@end
