//
//  SendRedVC.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/20.
//

#import "BaseViewController.h"
#import "TGCoinTypeModel.h"

typedef NS_ENUM(NSInteger, sendType){
    SingeleType                     =   10,   //单个红包
    luckType                      =   11,   //拼手气红包
};
@class SendRedVC;

@protocol SendRedVCDelegate<NSObject>;

@optional
-(void)SendRedVC:(SendRedVC *)vc;

@end

@interface SendRedVC : BaseViewController

@property (nonatomic ,assign) id<SendRedVCDelegate>delegate;

@end



@interface CoinCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong)TGCoinTypeModel *model;

@end

@interface CoinCollectionViewLayout : UICollectionViewFlowLayout
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@end
