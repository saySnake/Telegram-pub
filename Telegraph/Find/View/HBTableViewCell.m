//
//  HBTableViewCell.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import "HBTableViewCell.h"

@implementation HBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        sepTop = [[UILabel alloc] init];
        sepTop.hidden = YES;
        sepTop.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:sepTop];
        
        sepBottom = [[UILabel alloc] init];
        sepBottom.hidden = YES;
        sepBottom.backgroundColor =  UIColorFromRGB(244, 244, 244);
        [self addSubview:sepBottom];
        
        sepBottom2 = [[UILabel alloc] init];
        sepBottom2.hidden = YES;
        sepBottom2.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:sepBottom2];
        
        _arrow = [[UIImageView alloc] init];
        _arrow.hidden = YES;
        _arrow.image = [UIImage imageNamed:@"icon_right.png"];
        [self addSubview:_arrow];
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    
    sepTop.frame = CGRectMake(0, 0, size.width, 0.5);
    sepBottom.frame = CGRectMake(10, size.height-0.5, size.width-10, 0.5);
    sepBottom2.frame = CGRectMake(0, size.height-0.5, size.width, 0.5);
    _arrow.frame = CGRectMake(size.width-10-16, (size.height-16)/2, 16, 16);
}

- (void)setSeparator:(BOOL)first middle:(BOOL)middle last:(BOOL)last
{
    sepTop.hidden = !first;
    sepBottom.hidden = !middle;
    sepBottom2.hidden = !last;
    
    [self bringSubviewToFront:sepTop];
    [self bringSubviewToFront:sepBottom];
    [self bringSubviewToFront:sepBottom2];
}

- (void)setArrow:(BOOL)arrow
{
    _arrow.hidden = !arrow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
