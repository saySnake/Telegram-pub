//
//  SendRedVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/20.
//

#import "SendRedVC.h"
#import "InfiniteScrollPicker.h"
#import "ETHModel.h"
#import "TGCoinListViewController.h"
@interface SendRedVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UITextField *redCountField;
@property (weak, nonatomic) IBOutlet UITextField *remarkField;
@property (weak, nonatomic) IBOutlet UIButton *sendMoneyBtn;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic ,strong)InfiniteScrollPicker *isp;

@end

@implementation SendRedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestView];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        CoinCollectionViewLayout *layout=[[CoinCollectionViewLayout alloc] init];
        layout.itemSize=CGSizeMake((DScreenW-80)/3, 70);
               layout.minimumLineSpacing=20;
        //        layout.minimumInteritemSpacing=40;
        layout.sectionInset=UIEdgeInsetsMake(0,20,0,20);
        layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DScreenW, self.typeView.height) collectionViewLayout:layout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor whiteColor];
        [_collectionView registerClass:[CoinCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
- (void)requestView
{
    [self.typeView addSubview:self.collectionView];

}

- (IBAction)fanhuiAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)lookMore:(id)sender {
    NSLog(@"查看更多");
    TGCoinListViewController *list=[[TGCoinListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}
- (IBAction)handPackAction:(id)sender {
    NSLog(@"改为拼手气红包");
}

- (IBAction)senAction:(id)sender {
    NSLog(@"塞进红包");
}


#pragma mark - UICollectionViewDelegate / dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CoinCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
@end


@implementation CoinCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.countLabel];
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5.f;
        self.layer.borderColor=RGBACOLOR(226, 226, 226, 1).CGColor;
        self.layer.borderWidth=0.2f;
        self.layer.shadowColor=RGBACOLOR(226, 226, 226, 1).CGColor;
        self.layer.shadowRadius=12.f;
        self.layer.shadowOpacity=0.8f;
        self.layer.shadowOffset=CGSizeMake(0, 5);
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@20);
            make.left.equalTo(@17);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.left.equalTo(self.iconView.mas_right).offset(5);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.bottom.equalTo(@(-11.5));
            make.width.lessThanOrEqualTo(self.contentView.mas_width);
        }];
    }
    return self;
}
- (UIImageView *)iconView{
    if (_iconView==nil) {
        _iconView=[[UIImageView alloc] init];
    }
    return _iconView;
}
- (UILabel *)nameLabel{
    if (_nameLabel==nil) {
        _nameLabel=[[UILabel alloc] init];
        _nameLabel.textColor=RGBACOLOR(56, 190, 84, 1);
        _nameLabel.font=[UIFont systemFontOfSize:18];
        _nameLabel.text=@"BTC";
    }
    return _nameLabel;
}
- (UILabel *)countLabel{
    if (_countLabel==nil) {
        _countLabel=[[UILabel alloc] init];
        _countLabel.textColor=RGBACOLOR(142, 142, 147, 1);
        _countLabel.font=[UIFont systemFontOfSize:15.7];
        _countLabel.text=@"10.0000002";
    }
    return _countLabel;
}
@end






@implementation CoinCollectionViewLayout

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
    //    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    //    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
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
