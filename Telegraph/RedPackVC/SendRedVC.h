//
//  SendRedVC.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/20.
//

#import "BaseViewController.h"

@interface SendRedVC : BaseViewController

@end
@interface CoinCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@interface CoinCollectionViewLayout : UICollectionViewFlowLayout
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@end
