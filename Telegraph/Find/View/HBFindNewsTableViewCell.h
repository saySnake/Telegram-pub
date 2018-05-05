//
//  HBFindNewsTableViewCell.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import "HBTableViewCell.h"
@class HBFindNewsModel;

@interface HBFindNewsTableViewCell : HBTableViewCell
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UIImageView *hotView;
@property (nonatomic,strong) UILabel *viewCountLable;
@property (nonatomic,strong) UILabel *dateLable;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *videoDurationLable;
@property (nonatomic,strong) UIImageView *viedeoMarkView;

-(void)setInfo:(HBFindNewsModel *)model;
@end
