//
//  TGSortView.h
//  Telegraph
//
//  Created by 张玮 on 2018/4/28.
//

#import <UIKit/UIKit.h>
typedef void(^BudgetSortBlock)(NSInteger index);

@interface TGSortView : UIView

@property (nonatomic, copy) BudgetSortBlock budgetSortClicked;

- (void)show:(UIViewController *)viewController;

@end
