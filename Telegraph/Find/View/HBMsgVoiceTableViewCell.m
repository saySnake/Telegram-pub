//
//  HBMsgVoiceTableViewCell.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import "HBMsgVoiceTableViewCell.h"
#import "HBVoiceMsgModel.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation HBMsgVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        _starImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_level"]];
        [self addSubview:_starImageView];
        
        _starLable = [[UILabel alloc] init];
        _starLable.textAlignment = NSTextAlignmentLeft;
        _starLable.textColor = UIColorFromRGB(179, 179, 179);
        _starLable.font =  [UIFont systemFontOfSize:10.0f];
        _starLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_starLable];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_voice"]];
        [self addSubview:_bgImageView];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleToFill;
        _avatarImageView.layer.cornerRadius = 20.0f;
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        
        _nameLable = [[UILabel alloc] init];
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = [UIColor whiteColor];
        _nameLable.font =  [UIFont systemFontOfSize:12.0f];
        _nameLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLable];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    int radom = arc4random();
    CGFloat x = 50.0f;
    
    if (radom % 2 ==0) {
        
    }else{
        x = 19.0f;
    }
    
     _bgImageView.frame = CGRectMake(x, (size.height-51)/2, 275, 51);
    _avatarImageView.frame = CGRectMake(CGRectGetMinX(_bgImageView.frame)+4, CGRectGetMinY(_bgImageView.frame)+4, 42, 42);
    _nameLable.frame = CGRectMake(CGRectGetMinX(_avatarImageView.frame), CGRectGetMaxY(_avatarImageView.frame)+10, _avatarImageView.size.width, 14);
    _starImageView.frame = CGRectMake(CGRectGetMinX(_bgImageView.frame)+104, 20, 14.5, 14);
    _starLable.frame = CGRectMake(CGRectGetMaxX(_starImageView.frame)+5, CGRectGetMinY(_starImageView.frame), size.width/3, 14);
}

-(void)setInfo:(HBVoiceMsgModel *)model
{
    _nameLable.text = model.name;
    _starLable.text = [NSString stringWithFormat:@"+魅力值：%d",model.starLevel];
    
    NSString * imageURL = [model.avatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIImage *newImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageURL];
    
    if (newImage) {
        _avatarImageView.image = newImage;
    }else{
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@""]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
