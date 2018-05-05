//
//  NewPagedFlowView.h
//  dianshang
//
//  Created by sskh on 16/7/13.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import <UIKit/UIKit.h>

@protocol NewPagedFlowViewDataSource;
@protocol NewPagedFlowViewDelegate;


typedef enum{
    NewPagedFlowViewOrientationHorizontal = 0,
    NewPagedFlowViewOrientationVertical
}NewPagedFlowViewOrientation;

@interface NewPagedFlowView : UIView<UIScrollViewDelegate>

@property (nonatomic,assign) NewPagedFlowViewOrientation orientation;//默认为横向

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,assign) BOOL needsReload;
@property (nonatomic,assign) CGSize pageSize; //一页的尺寸
@property (nonatomic,assign) NSInteger pageCount;  //总页数

@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,assign) NSRange visibleRange;
@property (nonatomic,strong) NSMutableArray *reusableCells;//如果以后需要支持reuseIdentifier，这边就得使用字典类型了

@property (nonatomic,assign)   id <NewPagedFlowViewDataSource> dataSource;
@property (nonatomic,assign)   id <NewPagedFlowViewDelegate>   delegate;

/**
 *  指示器
 */
@property (nonatomic,retain)  UIPageControl *pageControl;

/**
 *  非当前页的透明比例
 */
@property (nonatomic, assign) CGFloat minimumPageAlpha;

/**
 *  非当前页的缩放比例
 */
@property (nonatomic, assign) CGFloat minimumPageScale;

/**
 *  是否开启自动滚动,默认为开启
 */
@property (nonatomic, assign) BOOL isOpenAutoScroll;

/**
 *  当前是第几页
 */
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

/**
 *  定时器
 */
@property (nonatomic, weak) NSTimer *timer;

/**
 *  自动切换视图的时间,默认是5.0
 */
@property (nonatomic, assign) CGFloat autoTime;

/**
 *  原始页数
 */
@property (nonatomic, assign) NSInteger orginPageCount;

/**
 *  刷新视图
 */
- (void)reloadData;

/**
 *  获取可重复使用的Cell
 *
 *  @return <#return value description#>
 */
- (UIView *)dequeueReusableCell;

/**
 *  滚动到指定的页面
 *
 *  @param pageNumber <#pageNumber description#>
 */
- (void)scrollToPage:(NSUInteger)pageNumber;

/**
 *  开启定时器,废弃
 */
//- (void)startTimer;

/**
 *  关闭定时器,关闭自动滚动
 */
- (void)stopTimer;

@end


@protocol  NewPagedFlowViewDelegate<NSObject>

/**
 *  单个子控件的Size
 *
 *  @param flowView <#flowView description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView;

@optional
/**
 *  滚动到了某一列
 *
 *  @param pageNumber <#pageNumber description#>
 *  @param flowView   <#flowView description#>
 */
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView;

/**
 *  点击了第几个cell
 *
 *  @param subView 点击的控件
 *  @param subIndex    点击控件的index
 *
 *  @return <#return value description#>
 */
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex;

@end


@protocol NewPagedFlowViewDataSource <NSObject>

/**
 *  返回显示View的个数
 *
 *  @param flowView <#flowView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView;

/**
 *  给某一列设置属性
 *
 *  @param flowView <#flowView description#>
 *  @param index    <#index description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end
