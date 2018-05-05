//
//  HBPriceTableViewCell.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import "HBTableViewCell.h"
@class HBPriceModel;

@interface HBPriceTableViewCell : HBTableViewCell

@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UILabel *platormLable;
@property (nonatomic,strong) UILabel *countLable;
@property (nonatomic,strong) UILabel *priceLable;
@property (nonatomic,strong) UILabel *dollarLable;
@property (nonatomic,strong) UILabel *levelLable;

-(void)setInfo:(HBPriceModel *)model;
@end
