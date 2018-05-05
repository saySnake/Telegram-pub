//
//  TGPayStyleCell.m
//  Telegraph
//
//  Created by 张玮 on 2018/5/3.
//

#import "TGPayStyleCellOne.h"

@implementation TGPayStyleCellOne

- (void)awakeFromNib {
    [super awakeFromNib];
    self.img.cornerRadius =self.img.width/2;
    self.img.backgroundColor =[UIColor orangeColor];
    
    self.timeImg.image =[UIImage imageNamed:@"wallectTime.png"];
    self.coin.textColor =[UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
