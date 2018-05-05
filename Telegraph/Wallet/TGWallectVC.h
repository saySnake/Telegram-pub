//
//  TGWallectVC.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/24.
//

#import "BaseViewController.h"
#import "TGCoinTypeModel.h"

@interface TGWallectVC : BaseViewController


@end

@interface CoinCollectionViewCells : UICollectionViewCell
@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) UIImageView *titleIconView; 　　
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong)TGCoinTypeModel *model;

@end

@interface CoinCollectionViewLayouts : UICollectionViewFlowLayout

@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@end
