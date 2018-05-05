//
//  TGHotPayCell.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/27.
//

#import "TGHotPayCell.h"

@implementation TGHotPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(PayListModel *)model
{
    _model =model;
    self.timeLabel.text =_model.time;
//    self.outLabel.text =_model.outMoney;
//    self.inLabel.text =_model.inMoney;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
