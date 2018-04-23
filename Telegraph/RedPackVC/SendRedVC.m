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
#import "DCPaymentView.h"
#import "TGCoinTypeModel.h"
@interface SendRedVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UITextField *redCountField;
@property (weak, nonatomic) IBOutlet UITextField *remarkField;
@property (weak, nonatomic) IBOutlet UIButton *sendMoneyBtn;
@property (weak, nonatomic) IBOutlet UIView *typeView;//滚动视图子视图
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *signleBtn;//拼手气红包或者单个红包
@property (weak, nonatomic) IBOutlet UILabel *singleLabel;

@property (nonatomic ,strong)InfiniteScrollPicker *isp;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//单个金额或者总额

@property (nonatomic ,strong) NSMutableArray *dataArr;


@property (weak, nonatomic) IBOutlet UIView *backView;


@property (nonatomic ,strong) UILabel *usdtLabel;
@end

@implementation SendRedVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArr =[NSMutableArray array];
    [self data];
    [self requestView];
    
    [self.moneyField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.redCountField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.moneyField.backgroundColor =[UIColor clearColor];
    self.moneyField.adjustsFontSizeToFitWidth =YES;
    self.moneyField.delegate =self;
    
    self.redCountField.delegate =self;
    self.remarkField.delegate =self;
    self.usdtLabel =[[UILabel alloc] init];
    self.usdtLabel.hidden =YES;
    self.signleBtn.tag =SingeleType;
    self.signleBtn.titleLabel.text =@"改为拼手气红包";
    self.sendMoneyBtn.enabled =NO;
    
    [self.sendMoneyBtn setBackgroundColor:RGBACOLOR(255.0f, 197.0f, 199.0f, 0.6)];
    self.sendMoneyBtn.enabled =NO;
}


- (IBAction)singleBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"改为拼手气红包"]) {
        [self.totalLabel setText:@"总额"];
        [sender setTitle:@"改为普通红包" forState:UIControlStateNormal];
        sender.frame =CGRectMake(CGRectGetMaxX(self.singleLabel.frame), CGRectGetMinY(self.singleLabel.frame)-5, [self buutonText:sender.titleLabel.text], 30);
        sender.tag =luckType;
        return;
    }
    
    if ([sender.titleLabel.text isEqualToString:@"改为普通红包"]) {
        [self.totalLabel setText:@"单个金额"];
        [sender setTitle:@"改为拼手气红包" forState:UIControlStateNormal];
        sender.frame =CGRectMake(CGRectGetMaxX(self.singleLabel.frame), CGRectGetMinY(self.singleLabel.frame)-5, [self buutonText:sender.titleLabel.text], 30);
        sender.tag =SingeleType;
        return;
    }
}

-(CGFloat)buutonText:(NSString *)text
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGFloat length = [text boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width; //为button赋值
    return length;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        return [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.moneyField.text.length!=0 && self.redCountField.text.length!=0) {
        self.sendMoneyBtn.enabled =YES;
        [self.sendMoneyBtn setBackgroundColor:[UIColor redColor]];
    }
    
    if (textField ==self.moneyField) {
        self.usdtLabel.hidden =textField.text.length?NO:YES;
        self.usdtLabel.text =@"≈169 USD";
        self.usdtLabel.textColor =[UIColor lightGrayColor];
        CGSize size =[self.usdtLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        self.usdtLabel.frame =CGRectMake(CGRectGetMaxX(self.moneyField.frame) +10, CGRectGetMinY(self.moneyField.frame), size.width+10, 30);
        [self.backView addSubview:self.usdtLabel];
    }
}


- (void) textFieldDidChange:(UITextField *) TextField
{
    
    self.usdtLabel.hidden =YES;
    if (TextField.text.length>15 && TextField.text.length <30) {
        CGSize size =[TextField.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        TextField.frame =CGRectMake(20, CGRectGetMaxY(self.totalLabel.frame)+10, size.width+10, 30);
    }
    else if (TextField.text.length ==0 ){

    }
}


- (void)data
{
    for (int i =0; i<3; i++) {
        TGCoinTypeModel *model =[[TGCoinTypeModel alloc] init];
        model.CoinName =@"BTC";
        model.CoinMoney =@"10.0000002";
        [self.dataArr addObject:model];
    }
    
    TGCoinTypeModel *bo =[[TGCoinTypeModel alloc] init];
    [self.dataArr insertObject:bo atIndex:0];
    [self.dataArr insertObject:bo atIndex:self.dataArr.count];
    [_collectionView reloadData];
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
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"a"];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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
    DCPaymentView *payAlert =[[DCPaymentView alloc] init];
    payAlert.title =@"支付";
    payAlert.detail =@"群红包";
    payAlert.amount =@"0.02BTC";
    [payAlert show:self];
    payAlert.completeHandle = ^(NSString *inputPwd) {
        if ([self.delegate respondsToSelector:@selector(SendRedVC:url:)]) {
            [self.delegate SendRedVC:self url:@"https://www.biyong.info/redpacket.html"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        NSLog(@"密码是%@",inputPwd);
        
    };
}


#pragma mark - UICollectionViewDelegate / dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.dataArr.count);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item ==0) {
        UICollectionViewCell *ce =[collectionView dequeueReusableCellWithReuseIdentifier:@"a" forIndexPath:indexPath];
        return ce;
    }
    if (indexPath.item ==(long)[self.dataArr count]-1) {
        UICollectionViewCell *ce =[collectionView dequeueReusableCellWithReuseIdentifier:@"a" forIndexPath:indexPath];
        return ce;
        }
    if (indexPath.item !=0 && indexPath.item!=(long)[self.dataArr count]-1) {
        TGCoinTypeModel *model =self.dataArr[indexPath.item];
        CoinCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.model =model;
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CoinCollectionViewCell * cell = (CoinCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%ld",indexPath.item);
}

@end


@implementation CoinCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
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

- (void)setModel:(TGCoinTypeModel *)model
{
    _model =model;
    _nameLabel.text =model.CoinName;
    _countLabel.text =model.CoinMoney;
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
