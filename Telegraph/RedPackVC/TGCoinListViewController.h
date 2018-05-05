//
//  TGCoinListViewController.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/21.
//

#import "BaseViewController.h"

@interface TGCoinListViewController : BaseViewController

@end

@class  RTDragModel;

@interface TGCoinListViewCell : UITableViewCell

@property (nonatomic ,strong)UIImageView *img;
@property (nonatomic ,strong)UILabel *name;
@property (nonatomic ,strong)UILabel *money;
@property (nonatomic ,strong)RTDragModel *model;

@end

@interface RTDragModel :NSObject
@property (nonatomic, strong) UIColor *imgColor;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, strong) UIColor *titlebackgroundColor;

@end
