//
//  HBFindGroupCollectionViewCell.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import "HBFindGroupCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HBFindGroupModel.h"
#import "SDImageCache.h"
#import "HBTextUtil.h"

@implementation HBFindGroupCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size =  self.frame.size;
        self.backgroundColor = [UIColor clearColor];
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _bgView.layer.cornerRadius = 6.0f;
        _bgView.backgroundColor = UIColorFromRGB(75, 75, 75);;
        [self addSubview:_bgView];
        
        _groupAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(21.5, 17, 42, 42)];
        _groupAvatarView.contentMode = UIViewContentModeScaleToFill;
        _groupAvatarView.layer.cornerRadius = 20.0f;
        _groupAvatarView.layer.masksToBounds = YES;
        [self addSubview:_groupAvatarView];
        
        _groupNameLable =[[UILabel alloc] init];
        _groupNameLable.textAlignment = NSTextAlignmentLeft;
        _groupNameLable.textColor = [UIColor whiteColor];
        _groupNameLable.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
        _groupNameLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_groupNameLable];
        
        _groupTypeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_group_type"]];
        [self addSubview:_groupTypeView];
        
        _descLable =[[UILabel alloc] init];
        _descLable.textAlignment = NSTextAlignmentLeft;
        _descLable.textColor = [UIColor whiteColor];
        _descLable.font =  [UIFont systemFontOfSize:10.0f];
        _descLable.backgroundColor = [UIColor clearColor];
        _descLable.numberOfLines = 0;
        [self addSubview:_descLable];
        
        _countImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_group_person_count"]];
        [self addSubview:_countImageView];
        
        _countLable =[[UILabel alloc] init];
        _countLable.textAlignment = NSTextAlignmentLeft;
        _countLable.textColor = UIColorFromRGB(250, 225, 0);
        _countLable.font =  [UIFont systemFontOfSize:10.0f];
        _countLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_countLable];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"find_group_add"] forState:UIControlStateNormal];
//        [_addButton addTarget:self action:@selector(copyReceiptAddr:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
    }
    return self;
}


-(void)layoutSubviews
{
    
    [super layoutSubviews];
    CGSize size = self.frame.size;
    _bgView.frame = CGRectMake(0, 0, size.width, size.height);
    _groupAvatarView.frame = CGRectMake(21.5, 17, 42, 42);
    _groupNameLable.frame = CGRectMake(CGRectGetMaxX(_groupAvatarView.frame)+13, 29, [HBTextUtil getTxtSize:_groupNameLable.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:18.0f]].width, 18);
    _groupTypeView.frame = CGRectMake(CGRectGetMaxX(_groupNameLable.frame)+12, 31.5f, 11.0f, 13.0f);
    
    CGFloat height = [HBTextUtil getTextHeight:_descLable.text font:[UIFont fontWithName:@"PingFangSC-Regular" size:10.0f] width:size.width-21.5-23 maxHeight:MAXFLOAT].height;
    
    _descLable.frame = CGRectMake(21.5f, CGRectGetMaxY(_groupAvatarView.frame)+13.0f, size.width-21.5-23,height);
    _countImageView.frame = CGRectMake(21, size.height-18-11, 10, 11);
    _countLable.frame = CGRectMake(CGRectGetMaxX(_countImageView.frame)+6, CGRectGetMinY(_countImageView.frame), 80, _countImageView.frame.size.height);
    _addButton.frame = CGRectMake(size.width-22-55, size.height-12.5-22, 55, 22);
}

-(void)setInfo:(HBFindGroupModel *)model
{
    NSString * imageURL = [model.groupAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIImage *newImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageURL];
    
    if (newImage) {
        _groupAvatarView.image = newImage;
    }else{
        [_groupAvatarView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@""]];
    }
    _groupNameLable.text =model.groupName;
    _descLable.text = model.desc;
    _countLable.text = [NSString stringWithFormat:@"%d人",model.persionCount];
    [self layoutIfNeeded];
}
@end
