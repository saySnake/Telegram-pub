//
//  HBMsgVoiceTableViewCell.h
//  Telegraph
//
//  Created by 段智林 on 2018/5/3.
//

#import "HBTableViewCell.h"
@class HBVoiceMsgModel;

@interface HBMsgVoiceTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *starImageView;
@property (nonatomic,strong) UILabel *starLable;

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UILabel *nameLable;

@property (nonatomic,strong) UIImageView *voiceImageView;
@property (nonatomic,strong) UIImageView *voiceLineImageView;

-(void)setInfo:(HBVoiceMsgModel *)model;
@end
