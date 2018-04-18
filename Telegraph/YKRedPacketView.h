//
//  YKRedPacketView.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/17.
//

#import <UIKit/UIKit.h>

@interface YKRedPacketView : UIView
@property (nonatomic , strong)UIImageView *backgroundView;

@property (nonatomic , strong)UILabel *redTitle; //恭喜发财

@property (nonatomic , strong)UILabel *redProfile;//领取红包

@property (nonatomic , strong)UILabel *redSource;//来源



@property (nonatomic , strong)NSString *photoUrl;//头像来源

@property (nonatomic , strong)NSString *photoTitle;//名字来源







@end
