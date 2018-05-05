//
//  TGWallectVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/24.
//

#import "TGWallectVC.h"
#import "SPPageMenu.h"
#import "TGHotPayVC.h"
#import "TGFaPayVC.h"
#import "TGBiPayVC.h"
#import "TGHuoPayVC.h"
#import "TGCoinTypeModel.h"
#import <FSChartView/FSChartView.h>
#import "ZFNumberRollLabel.h"
#import "TGCapitalListVC.h"





#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define pageMenuH 40
#define NaviH (screenH == 812 ? 88 : 64) // 812是iPhoneX的高度
#define scrollViewHeight (screenH-88-pageMenuH)

@interface TGWallectVC ()<SPPageMenuDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,FSPieChartViewDelegate, FSPieChartViewDataSource>
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (weak, nonatomic) IBOutlet  UILabel*totoalMoney; //总资产（BTC）
@property (weak, nonatomic) IBOutlet UIButton *lookBtn; //观看
@property (weak, nonatomic) IBOutlet UIButton *unlook;  //隐藏观看
@property (weak, nonatomic) IBOutlet UIButton *moneySelect; //选择btc
@property (weak, nonatomic) IBOutlet ZFNumberRollLabel *detaileLabel; //详细钱
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel; //大约多少钱
@property (weak, nonatomic) IBOutlet UIView *shanView; //扇形图
@property (weak, nonatomic) IBOutlet UILabel *oneMoney; //hotpay
@property (weak, nonatomic) IBOutlet UILabel *twoMoney; //pro
@property (weak, nonatomic) IBOutlet UILabel *thrMoney; //otc
@property (weak, nonatomic) IBOutlet UIButton *moreBtn; //更多开放服务
@property (weak, nonatomic) IBOutlet UIView *contentView; //内容view

@property (nonatomic, strong) UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic ,strong) NSArray *dataArr;
@property (nonatomic ,strong) NSMutableArray *dataArrs;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableArray *myChildViewControllers;



@property (nonatomic ,strong)NSMutableArray *charArray;
@property (nonatomic ,strong)NSMutableArray *charTitleArray;


@property (nonatomic, strong) FSPieChartView *chartView1;

@end


@implementation TGWallectVC

- (void)data
{
    for (int i =0; i<6; i++) {
        TGCoinTypeModel *model =[[TGCoinTypeModel alloc] init];
        model.CoinName =@"B";
        model.CoinMoney =@"10.0000002";
        [self.dataArrs addObject:model];
    }
    
//    TGCoinTypeModel *bo =[[TGCoinTypeModel alloc] init];
//    [self.dataArrs insertObject:bo atIndex:0];
//    [self.dataArrs insertObject:bo atIndex:self.dataArr.count];
    [_collectionView reloadData];
}

-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        CoinCollectionViewLayouts *layout=[[CoinCollectionViewLayouts alloc] init];
        layout.itemSize=CGSizeMake((DScreenW-80)/7, 50);
        layout.minimumLineSpacing=20;
        //        layout.minimumInteritemSpacing=40;
        layout.sectionInset=UIEdgeInsetsMake(2,20,2,20);
        layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DScreenW, self.footerView.height) collectionViewLayout:layout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor whiteColor];
        [_collectionView registerClass:[CoinCollectionViewCells class] forCellWithReuseIdentifier:@"cells"];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"aa"];
//        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    return _collectionView;
}

- (NSMutableArray *)myChildViewControllers
{
    if (!_myChildViewControllers) {
        _myChildViewControllers =[NSMutableArray array];
    }
    return _myChildViewControllers;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBarHidden =YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden =NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArrs =[NSMutableArray array];
    self.navigationController.navigationBarHidden =YES;
    
    [self.footerView addSubview:self.collectionView];
    [self data];
    
    self.charTitleArray =[NSMutableArray arrayWithCapacity:0];
    [self.charTitleArray addObjectsFromArray:@[@"",@"",@""]];
    self.charArray =[NSMutableArray arrayWithCapacity:0];
    
    for (int i =0; i<3; i++) {
        int rand =arc4random()%101;
        [self.charArray addObject:@(rand)];
    }
    
    self.shanView.backgroundColor =[UIColor clearColor];
    CGFloat height = self.shanView.height;
    FSPieChartView *pieChartView1 = [[FSPieChartView alloc] initWithFrame:CGRectMake(0, 0, self.shanView.width, height)];
    pieChartView1.backgroundColor =[UIColor clearColor];
    pieChartView1.delegate = self;
    pieChartView1.dataSource = self;
    pieChartView1.allowMultiSelected = YES;
    [self.shanView addSubview:pieChartView1];
    self.chartView1 = pieChartView1;
    
    
    [self setUpHeadView];

//    [self animationLabel];
}

- (void)animationLabel
{
    [self.detaileLabel rollNumberWithDuration:3.0 fromNumber:0 toNumber:86.975021200];

}

- (NSInteger)numberOfSectionForChartView:(FSPieChartView *)chartView {
    return self.charArray.count;
}

- (CGFloat)pieChartView:(FSPieChartView *)chartView percentageDataForSection:(NSInteger)section {
    return [self.charArray[section] floatValue] / [[self.charArray valueForKeyPath:@"@sum.floatValue"] floatValue];
}

- (UIColor *)pieChartView:(FSPieChartView *)chartView colorForSection:(NSInteger)section {
    switch (section) {
        case 0:
            return RGBACOLOR(82.0f, 82.0f, 82.0f, 1);
        case 1:
            return RGBACOLOR(250.0f, 225.0f, 0, 1);
        case 2:
            return RGBACOLOR(254.0f, 162.0f, 53.0f, 1);
        default:
            return [UIColor redColor];
    }
}

- (void)pieChartView:(FSPieChartView *)chartView didSelectItemForSection:(NSInteger)section
{
    TGCapitalListVC *lis =[[TGCapitalListVC alloc] init];

    [self.navigationController pushViewController:lis animated:YES];
}

- (UIColor *)innerCircleBackgroundColorForChartView:(FSPieChartView *)chartView
{
    if ([chartView isEqual:self.chartView1]) {
        return [UIColor whiteColor];
    }
    return [UIColor clearColor];
}

- (UILabel *)pieChartView:(FSPieChartView *)chartView dataLabelForSection:(NSInteger)section {
    UILabel *label = [UILabel new];
    label.font =[UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%.2f%%\n%@", [self.charArray[section] floatValue] / [[self.charArray valueForKeyPath:@"@sum.floatValue"] floatValue] * 100, self.charTitleArray[section]];
    return label;
}

- (CGFloat)startAngleForChartView:(FSPieChartView *)chartView {
    if ([chartView isEqual:self.chartView1]) {
        return 0;
    }
    return M_PI * 2 / 3;
}




#pragma mark - UICollectionViewDelegate / dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.dataArrs.count);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.item ==0) {
//        UICollectionViewCell *ce =[collectionView dequeueReusableCellWithReuseIdentifier:@"aa" forIndexPath:indexPath];
//        return ce;
//    }
//    if (indexPath.item ==(long)[self.dataArrs count]-1) {
//        UICollectionViewCell *ce =[collectionView dequeueReusableCellWithReuseIdentifier:@"aa" forIndexPath:indexPath];
//        return ce;
//    }
//    if (indexPath.item !=0 && indexPath.item!=(long)[self.dataArrs count]-1) {
//        TGCoinTypeModel *model =self.dataArrs[indexPath.item];
//        CoinCollectionViewCells *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cells" forIndexPath:indexPath];
//        cell.model =model;
//        return cell;
//    }
    
    TGCoinTypeModel *model =self.dataArrs[indexPath.item];
    CoinCollectionViewCells *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cells" forIndexPath:indexPath];
    cell.model =model;
    return cell;
//    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CoinCollectionViewCells * cell = (CoinCollectionViewCells *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%ld",indexPath.item);
}


- (void)reloadData
{
    
}


- (void)setUpHeadView
{
    self.dataArr =@[@"HotPay交易",@"法币交易",@"币币交易",@"火腿记录"];
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0,0, DScreenW, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
    pageMenu.selectedItemTitleColor =RGBACOLOR(51.0f, 51.0f, 51.0f, 1);
    pageMenu.unSelectedItemTitleColor =RGBACOLOR(51.0f, 51.0f, 51.0f, 1);
    pageMenu.translatesAutoresizingMaskIntoConstraints = NO;
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.dataArr selectedItemIndex:0];
    
    // 设置代理
    pageMenu.delegate = self;
    [self.contentView addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    NSArray *controllerClassName =[NSArray arrayWithObjects:@"TGHotPayVC",@"TGFaPayVC",@"TGBiPayVC",@"TGHuoPayVC", nil];
    for (int i =0; i<self.dataArr.count; i++) {
        if (controllerClassName.count >i) {
            BaseViewController *baseVc = [[NSClassFromString(controllerClassName[i]) alloc] init];
            NSString *text =[self.pageMenu titleForItemAtIndex:i];
            [self addChildViewController:baseVc];
            [self.myChildViewControllers addObject:baseVc];
        }
    }
    
    UIScrollView *scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, pageMenuH, DScreenW,self.contentView.height+30 )];
    scrollView.delegate =self;
    scrollView.pagingEnabled =YES;
    scrollView.showsHorizontalScrollIndicator =NO;
    [self.contentView addSubview:scrollView];
    _scrollView =scrollView;
    self.pageMenu.bridgeScrollView =self.scrollView;
    
    if (self.pageMenu.selectedItemIndex <self.myChildViewControllers.count) {
        if (self.pageMenu.selectedItemIndex ==0) {
            TGHotPayVC *pay =self.myChildViewControllers[self.pageMenu.selectedItemIndex];
            pay.view.frame =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
            pay.frames =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
            [scrollView addSubview:pay.view];
        }else if (self.pageMenu.selectedItemIndex ==1){
            TGFaPayVC *pay =self.myChildViewControllers[self.pageMenu.selectedItemIndex];
            pay.view.frame =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
            pay.frames =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
            [scrollView addSubview:pay.view];
        }else if (self.pageMenu.selectedItemIndex ==2){
            TGBiPayVC *pay =self.myChildViewControllers[self.pageMenu.selectedItemIndex];
            pay.view.frame =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
            pay.frames =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
            [scrollView addSubview:pay.view];

        }else if (self.pageMenu.selectedItemIndex ==3){
            TGHuoPayVC *pay =self.myChildViewControllers[self.pageMenu.selectedItemIndex];
            pay.view.frame =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
            pay.frames =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
            [scrollView addSubview:pay.view];
        }
//        BaseViewController *baseVC =self.myChildViewControllers[self.pageMenu.selectedItemIndex];
//        baseVC.view.frame =CGRectMake(DScreenW *self.pageMenu.selectedItemIndex, 0, DScreenW, self.contentView.height+30);
//        [scrollView addSubview:baseVC.view];
        scrollView.contentOffset =CGPointMake(DScreenW *self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize =CGSizeMake(self.dataArr.count *DScreenW, 0);
        scrollView.scrollEnabled =NO;
    }
}





#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index
{
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}

    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;

    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}



- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)moreAction:(id)sender
{
    NSLog(@"更多开放服务")
}

@end


@implementation CoinCollectionViewCells

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.countLabel];
        [self.iconView addSubview:self.titleIconView];
        
        self.iconView.layer.cornerRadius=5.f;
        self.iconView.layer.borderColor=RGBACOLOR(226, 226, 226, 1).CGColor;
        self.iconView.layer.borderWidth=0.2f;
        self.iconView.layer.shadowColor=RGBACOLOR(226, 226, 226, 1).CGColor;
        self.iconView.layer.shadowRadius=12.f;
        self.iconView.layer.shadowOpacity=1.0f;
        self.iconView.layer.shadowOffset=CGSizeMake(0, 5);
        
        
        self.contentView.backgroundColor =[UIColor clearColor];
        self.titleIconView.backgroundColor =[UIColor clearColor];
        self.titleIconView.cornerRadius =15;
        self.titleIconView.image =[UIImage imageNamed:@"otCicon.png"];
        

//        self.layer.cornerRadius=5.f;
//        self.layer.borderColor=RGBACOLOR(226, 226, 226, 1).CGColor;
//        self.layer.borderWidth=0.2f;
//        self.layer.shadowColor=RGBACOLOR(226, 226, 226, 1).CGColor;
//        self.layer.shadowRadius=12.f;
//        self.layer.shadowOpacity=0.8f;
//        self.layer.shadowOffset=CGSizeMake(0, 5);
        
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.bottom.equalTo(@(-14));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.left.equalTo(self.iconView.mas_right).offset(5);
        }];
        
        [self.titleIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconView.mas_centerX);
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.width.height.equalTo(@(30));
        }];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.bottom.equalTo(@(0));
            make.width.lessThanOrEqualTo(self.contentView.mas_width);
            make.height.equalTo(@(12));
        }];
    }
    return self;
}

- (void)setModel:(TGCoinTypeModel *)model
{
    _model =model;
//    _nameLabel.text =model.CoinName;
//    _countLabel.text =model.CoinMoney;
}


- (UIImageView *)titleIconView
{
    if (_titleIconView==nil) {
        _titleIconView =[[UIImageView alloc] init];
        _titleIconView.backgroundColor =[UIColor blueColor];
    }
    return _titleIconView;
}

- (UIView *)iconView{
    if (_iconView==nil) {
        _iconView=[[UIView alloc] init];
    }
    return _iconView;
}

- (UILabel *)nameLabel{
    if (_nameLabel==nil) {
        _nameLabel=[[UILabel alloc] init];
        _nameLabel.textColor=RGBACOLOR(56, 190, 84, 1);
        _nameLabel.font=[UIFont systemFontOfSize:18];
        _nameLabel.text=@"";
    }
    return _nameLabel;
}

- (UILabel *)countLabel{
    if (_countLabel==nil) {
        _countLabel=[[UILabel alloc] init];
        _countLabel.textColor=RGBACOLOR(142, 142, 147, 1);
        _countLabel.font=[UIFont systemFontOfSize:15.7];
        _countLabel.text=@"红包";
    }
    return _countLabel;
}
@end

@implementation CoinCollectionViewLayouts

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置内边距
        CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        DLog(@"%f",delta);
        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1 - (delta / self.collectionView.frame.size.width-0.2);
        //        scale=scale>1?1:scale;
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return array;
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

@end
