//
//  HBFindGroupCollectionViewCell.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/4.
//

#import <UIKit/UIKit.h>
@class HBFindGroupModel;

@interface HBFindGroupCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *bgView;
@property(nonatomic,strong) UIImageView  *groupAvatarView;
@property(nonatomic,strong) UIImageView  *groupTypeView;
@property(nonatomic,strong) UILabel *groupNameLable;
@property(nonatomic,strong) UILabel *descLable;

@property(nonatomic,strong) UIImageView  *countImageView;
@property(nonatomic,strong) UILabel *countLable;
@property(nonatomic,strong) UIButton *addButton;

-(void)setInfo:(HBFindGroupModel *)model;
@end
