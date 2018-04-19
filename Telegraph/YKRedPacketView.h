//
//  YKRedPacketView.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/17.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, RedPackType){
    RedPackOutTime                     =   0,   //过期
    RedPackAccive                      =   1,   //已经领取
};


typedef void(^PackEventBlock)(RedPackType tag);

@interface YKRedPacketView : UIView

@property (nonatomic , copy)PackEventBlock block;

@property (nonatomic , strong)UIImageView *backgroundView;

@property (nonatomic , strong)UILabel *redTitle; //恭喜发财

@property (nonatomic , strong)UILabel *redProfile;//领取红包

@property (nonatomic , strong)UILabel *redSource;//来源

@property (nonatomic , strong)NSString *photoUrl;//头像来源

@property (nonatomic , strong)NSString *photoTitle;//名字来源

@end
