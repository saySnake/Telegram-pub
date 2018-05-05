//
//  BLTableViewCell.h
//  自定义cell侧滑删除按钮2
//
//  Created by asd on 16/7/1.
//  Copyright © 2016年 liguoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLTableViewCell;
@protocol CellButtonEventViewDelegate <NSObject>

@optional
- (void)deleteCell:(BLTableViewCell *)cell;
- (void)closeOtherCellLeftSwipe;
@end

@interface BLTableViewCell : UITableViewCell

//静态构造方法
+ (instancetype)cellWithTableView:(UITableView *)tableview;
- (void)closeSwipe;
@property (nonatomic, assign)BOOL isSwipeMode;//是否滑动
//代理属性
@property (nonatomic,weak)id<CellButtonEventViewDelegate> delegate;

@end
