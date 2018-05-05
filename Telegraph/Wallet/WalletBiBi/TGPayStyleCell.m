//
//  TGPayStyleCell.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/27.
//

#import "TGPayStyleCell.h"

@implementation TGPayStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.img.cornerRadius =self.img.width/2;
    
    // Initialization code
}

- (void)setModel:(PayStyleModel *)model
{
    _model =model;
    self.time.text =_model.time;
    self.img.backgroundColor =_model.imgColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
