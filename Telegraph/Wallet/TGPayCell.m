//
//  TGPayCell.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/26.
//

#import "TGPayCell.h"

@implementation TGPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews)
    {
        NSLog(@"%@",NSStringFromClass([subView class]));
        if ([NSStringFromClass([subView class]) isEqualToString:@"_UITableViewCellSeparatorView"]) {
            UIView *bgView=(UIView *)[subView.subviews firstObject];
            bgView.backgroundColor = [UIColor purpleColor];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
