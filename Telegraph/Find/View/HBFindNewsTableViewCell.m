//
//  HBFindNewsTableViewCell.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import "HBFindNewsTableViewCell.h"
#import "HBTextUtil.h"
#import "HBFindNewsModel.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation HBFindNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLable =[[UILabel alloc] init];
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = UIColorFromRGB(47, 47, 47);
        _nameLable.font =  [UIFont systemFontOfSize:15.0f];
        _nameLable.numberOfLines = 0;
        _nameLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLable];
        
        _hotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_group_type"]];
        [self addSubview:_hotView];
        
        _viewCountLable = [[UILabel alloc] init];
        _viewCountLable.textAlignment = NSTextAlignmentLeft;
        _viewCountLable.textColor = UIColorFromRGB(145, 145, 145);
        _viewCountLable.font =  [UIFont systemFontOfSize:12.0f];
        _viewCountLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_viewCountLable];
        
        _dateLable = [[UILabel alloc] init];
        _dateLable.textAlignment = NSTextAlignmentRight;
        _dateLable.textColor = UIColorFromRGB(145, 145, 145);
        _dateLable.font =  [UIFont systemFontOfSize:12.0f];
        _dateLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_dateLable];
        
        _iconView = [[UIImageView alloc] init];
        [self addSubview:_iconView];
        
        _videoDurationLable = [[UILabel alloc] init];
        _videoDurationLable.textAlignment = NSTextAlignmentRight;
        _videoDurationLable.textColor = [UIColor whiteColor];
        _videoDurationLable.font =  [UIFont systemFontOfSize:11.0f];
        _videoDurationLable.backgroundColor = [UIColor clearColor];
        [_iconView addSubview:_videoDurationLable];
        
        _viedeoMarkView = [[UIImageView alloc] init];
        [_iconView addSubview:_viedeoMarkView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    _nameLable.frame = CGRectMake(13, 15, 208, [HBTextUtil getTextHeight:_nameLable.text font:_nameLable.font width:208 maxHeight:MAXFLOAT].height);
    _hotView.frame = CGRectMake(CGRectGetMinX(_nameLable.frame),size.height - 15 -23 , 11, 13);
    _viewCountLable.frame = CGRectMake(CGRectGetMaxX(_hotView.frame)+2.5f,CGRectGetMinY(_hotView.frame) , [HBTextUtil getTxtSize:_viewCountLable.text font:_viewCountLable.font].width, 13);
    _dateLable.frame = CGRectMake(CGRectGetMaxX(_viewCountLable.frame)+10, _viewCountLable.frame.origin.y, CGRectGetMaxX(_nameLable.frame) - CGRectGetMaxX(_viewCountLable.frame), 13);
  
    _iconView.frame = CGRectMake(size.width-13-112, (size.height - 81)/2, 112, 81);
    _viedeoMarkView.frame = CGRectMake((_iconView.size.width-36.5)/2, (_iconView.size.height-36.5)/2, 36.5, 36.5);
    _videoDurationLable.frame = CGRectMake(_iconView.frame.size.width/2,_iconView.frame.size.height - 6 -12 ,_iconView.frame.size.width/2-6 , 12);
}

-(void)setInfo:(HBFindNewsModel *)model
{
    _nameLable.text = model.title;
    _viewCountLable.text = [NSString stringWithFormat:@"%d",model.viewCount];
    _dateLable.text = model.date;
    
    if (model.newsType == 2) {
        _viedeoMarkView.hidden = YES;
        _videoDurationLable.text = [NSString stringWithFormat:@"%d",model.duration];
    }else{
        _videoDurationLable.text = @"";
        _viedeoMarkView.hidden = NO;
    }
    
    NSString * imageURL = [model.iconUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIImage *newImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageURL];
    
    if (newImage) {
        _iconView.image = newImage;
    }else{
        [_iconView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@""]];
    }
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
