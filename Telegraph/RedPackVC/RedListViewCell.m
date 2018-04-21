//
//  RedListViewCell.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/20.
//

#import "RedListViewCell.h"

@implementation RedListViewCell


- (void)setModel:(ReceRedModel *)model
{
    _model =model;
    self.name.text =model.name;
    self.time.text =model.time;
    self.money.text =model.money;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
