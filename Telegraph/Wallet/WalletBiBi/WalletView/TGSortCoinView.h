//
//  TGSortCoinView.h
//  Telegraph
//
//  Created by 张玮 on 2018/5/1.
//

#import <UIKit/UIKit.h>
typedef void(^BudgetSortBlock)(NSInteger index);

@interface TGSortCoinView : UIImageView
/** 点击事件的block */
@property (nonatomic, copy) BudgetSortBlock budgetSortClicked;

- (void)show;

@end


@interface CoinBtn :UIButton

@end
