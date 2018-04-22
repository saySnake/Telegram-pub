//
//  TGCoinListViewController.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/21.
//

#import "TGCoinListViewController.h"
#import "TGCoinTypeModel.h"
#import "RTDragCellTableView.h"
#define RTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RTRandomColor RTColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface TGCoinListViewController ()<UITableViewDelegate,UITableViewDataSource,RTDragCellTableViewDataSource,RTDragCellTableViewDelegate>
@property (nonatomic, strong) RTDragCellTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArr;
@end

@implementation TGCoinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
//        NSMutableArray *arr =[NSMutableArray array];
        _dataArr =[NSMutableArray array];
        for (int i =0; i<20; i++) {
            UIColor *color = RTRandomColor;
            RTDragModel *model =[[RTDragModel alloc] init];
            model.name =@"BTC";
            model.money =@"10.0000002";
            model.img =@"";
            model.imgColor =RTRandomColor;
            model.titlebackgroundColor =color;
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}


-(RTDragCellTableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[RTDragCellTableView alloc] init];
        _tableView.allowsSelection = YES;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorColor=RGBACOLOR(244, 244, 244, 1);
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.tableHeaderView =[[UIView  alloc] initWithFrame:CGRectMake(0, 0, DScreenW, 0.01)];
        _tableView.tableFooterView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenW, 0.01)];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
        [_tableView registerClass:[TGCoinListViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


- (void)setupSubViews{
    UIView *navBar=[[UIView alloc] init];
    navBar.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:navBar];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@64);
    }];
    UILabel *titleLabel=[[UILabel alloc] init];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text=@"更多货币";
    [navBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(navBar.mas_centerY).offset(10);
    }];
    UIButton *btn=[[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"shape"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(navBar.mas_centerY).offset(10);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(@0);
        make.top.equalTo(navBar.mas_bottom);
    }];

}
#pragma mark - action
- (void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate/dataSource

- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView
{
    if (tableView) {
        return _dataArr;
    }
    return nil;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray
{
    _dataArr = (NSMutableArray *)newArray;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TGCoinListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell =[[TGCoinListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    RTDragModel *model =_dataArr[indexPath.item];
    cell.model =model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
@end


@implementation TGCoinListViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier]) {
        self.showsReorderControl=NO;
        self.img =[[UIImageView alloc]init];
        self.img.cornerRadius=9;
        [self.contentView addSubview:self.img];
        
        self.name =[[UILabel alloc]init];
        [self.contentView addSubview:self.name];
        
        self.money =[[UILabel alloc]init];
        self.money.textAlignment =2;
        self.money.textColor =RGBACOLOR(142.0f, 142.0f, 147.0f, 1);
        [self.contentView addSubview:self.money];

    }
    return self;
}

- (void)setModel:(RTDragModel *)model
{
    _model =model;
    self.name.text =_model.name;
    self.money.text =_model.money;
    self.name.textColor =_model.titlebackgroundColor;
    self.img.backgroundColor =_model.imgColor;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.img.frame=CGRectMake(20, self.height/2-18.f/2, 18, 18);
//    self.img.backgroundColor =[UIColor orangeColor];
    
    self.name.frame=CGRectMake(self.img.maxX+5, self.height/2-18.f/2, 200, 18);

    self.money.frame=CGRectMake(self.width-200-20, self.height/2-18.f/2, 200, 18);
}

@end

@implementation RTDragModel

@end

