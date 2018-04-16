//
//  HBKeyBoardView.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/13.
//

#import "HBKeyBoardView.h"
#import "HBMoreViewItem.h"
#import "UIView+Addition.h"

#define App_Frame_Width    [[UIScreen mainScreen] bounds].size.width
#define APP_Frame_Height   [[UIScreen mainScreen] bounds].size.height
#define IColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XZColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define topLineH  0.5
#define bottomH  18

#define margin 10

@interface HBKeyBoardView ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIView *topLine;
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIPageControl *pageControl;

@end


@implementation HBKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XZColor(237, 237, 246);
        
        [self.subviews[2] removeFromSuperview];
        [self.subviews[3] removeFromSuperview];
        for (UIView *v  in self.subviews) {
            if ([v isKindOfClass:[TGStickerKeyboardTabPanel class]]){
                [v removeFromSuperview];
            }
        }
        [self topLine];
        [self scrollView];
        [self pageControl];
      
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.scrollView setFrame:CGRectMake(0, topLineH, frame.size.width,frame.size.height-bottomH)];
    [self.pageControl setFrame:CGRectMake(0, frame.size.height-bottomH, frame.size.width, 8)];
}

#pragma mark - Public Methods

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
    self.pageControl.numberOfPages = items.count / 8 + 1;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * (items.count / 8 + 1), _scrollView.height);
    
    
#pragma mark- margin是为了视图
    
    double w = self.width * 20 / 21 / 4 * 0.8;
    double space = w / 4;
    double h = (self.height - 20 - space * 2) / 2;
    double x = space, y = space;
    int i = 0, page = 0;
    for (HBMoreViewItem * item in _items) {
        [self.scrollView addSubview:item];
        [item setFrame:CGRectMake(x, y+margin, w, h)];
        [item setTag:i];
        [item addTarget:self action:@selector(didSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
        i ++;
        page = i % 8 == 0 ? page + 1 : page;
        x = (i % 4 ? x + w : page * self.width) + space;
        y = (i % 8 < 4 ? space : h+margin + space * 1.5);
    }
}


// 点击了某个Item
- (void) didSelectedItem:(HBMoreViewItem *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxMoreView:didSelectItem:)]) {
        [_delegate chatBoxMoreView:self didSelectItem:(int)sender.tag];
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / self.width;
    [_pageControl setCurrentPage:page];
}


#pragma mark - Getter and Setter

- (UIScrollView *)scrollView
{
    if (nil == _scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setPagingEnabled:YES];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (nil == _pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIView *)topLine
{
    if (nil == _topLine) {
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width,topLineH)];
        [self addSubview:topLine];
        topLine.backgroundColor = IColor(188.0, 188.0, 188.0);
        _topLine = topLine;
    }
    return _topLine;
}


#pragma mark - Privite Method

- (void)pageControlClicked:(UIPageControl *)pageControl
{
    [self.scrollView scrollRectToVisible:CGRectMake(pageControl.currentPage * App_Frame_Width, 0, App_Frame_Width, self.scrollView.height) animated:YES];
}



@end
