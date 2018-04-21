//
//  TGCoinListViewController.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/21.
//

#import "TGCoinListViewController.h"

@interface TGCoinListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TGCoinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    // Do any additional setup after loading the view.
}
-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorColor=RGBACOLOR(244, 244, 244, 1);
        _tableView.backgroundColor=[UIColor clearColor];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TGCoinListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=@"BTC";
    cell.detailTextLabel.text=@"10.0000002";

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
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
//    return proposedDestinationIndexPath;
//}
@end

@implementation TGCoinListViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier]) {
        self.showsReorderControl=NO;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(20, self.height/2-18.f/2, 18, 18);
    self.textLabel.frame=CGRectMake(self.imageView.maxX+5, self.height/2-self.textLabel.height/2, self.textLabel.width, self.textLabel.height);
    self.detailTextLabel.frame=CGRectMake(self.width-self.detailTextLabel.width-20, self.height/2-self.detailTextLabel.height/2, self.detailTextLabel.width, self.detailTextLabel.height);
}
@end
