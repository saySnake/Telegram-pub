//
//  HBPhoneAttributionVC.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import "HBPhoneAttributionVC.h"
//#import "thirdparty/AFNetworking/AFNetworking.h"
#import <MtProtoKit_Legacy.h>
#import "HBCountry.h"
#import "HBPhoneAttributionCell.h"
#import "HBCountryTitle.h"
#import "HBSearchCountryView.h"//搜索结果的view
#import "HBPhoneAttributionHeaderView.h"
@interface HBPhoneAttributionVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,HBSearchCountryViewDelegate>

@property (nonatomic ,strong)UISearchBar            *searchBar;
@property (nonatomic ,strong)UITableView            *tableView;
@property (nonatomic ,strong) NSArray               *list;
@property (nonatomic ,strong)HBSearchCountryView    *searchCountryView;

@end

@implementation HBPhoneAttributionVC

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if (!_searchBar.isFirstResponder) {
//        [self.searchBar becomeFirstResponder];
//    }
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self getData];
}
-(void)setupUI{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,kStatuesHeight + IpXAdd , kScreenWidth, 63.5*HeightRation - kStatuesHeight)];
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    _searchBar.delegate = self;
    _searchBar.tintColor = HBColor(21, 180, 241);//光标
    _searchBar.placeholder = TGLocalized(@"search_country_hint");
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.showsCancelButton = YES;
//    [_searchBar setBackgroundImage:[UIImage new]];
//    [_searchBar setTranslucent:YES];
    //拿到searchBar的输入框
//    UITextField *searchTextField = [_searchBar valueForKey:@"_searchField"];
//    //字体大小
//    searchTextField.font = [UIFont systemFontOfSize:14];
//    //输入框背景颜色
//    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
//    //拿到取消按钮
//    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
//    //设置按钮上的文字
//    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//    //设置按钮上文字的颜色
//    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _searchBar.bottom, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    [self.view addSubview:_searchBar];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, lineView.bottom, kScreenWidth, kScreenHeight - _searchBar.bottom) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
-(void)getData{
//    WeakSelf(self)
    MBProgressHUD *hud = [MBProgressHUD showLoadingToView:self.view];
//     https://uc-cn.huobi.com/uc/open/country/list
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    [manager GET:@"https://uc-cn.huobi.com/uc/open/country/list" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
//    data =     (
//                {
//                    "area_code" = 00355;
//                    "country_id" = 3;
//                    "name_cn" = "\U963f\U5c14\U5df4\U5c3c\U4e9a";
//                    "name_en" = Albania;
//                },{
//                    "area_code" = 00355;
//                    "country_id" = 3;
//                    "name_cn" = "\U963f\U5c14\U5df4\U5c3c\U4e9a";
//                    "name_en" = Albania;
//                })
    
    [HBHttpHelper countriesWithSuccess:^(id responseObject) {
        [hud hideHUD:YES];
        NSLog(@"%@",responseObject);
        [self successObj:responseObject];
    } failure:^(HBErrorModel *error) {
        [hud hideHUD:YES];
        [self failureObj:error];
    }];
}
- (void)successObj:(id)obj
{
    NSArray *list = [NSArray yy_modelArrayWithClass:[HBCountry class] json:obj];
    _list = [HBCountryTitle reloadList:list];
    [_tableView reloadData];
//    [self hidePlaceholder];
}
- (void)failureObj:(HBErrorModel *)error
{
    [MBProgressHUD showText:error.message toView:self.view];
//    [self showPlaceholder];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _list.count;
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HBCountryTitle *t = _list[section];
    return t.list.count;
//    return _list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HBPhoneAttributionHeaderView *headerView = [[HBPhoneAttributionHeaderView alloc]init];
    HBCountryTitle *t = _list[section];
    [headerView setTitle:t.title];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HBPhoneAttributionCell *cell = [HBPhoneAttributionCell cellWithTableView:tableView];
//    HBCountryTitle *t = _list[indexPath.section];
//    HBCountry *c = t.list[indexPath.row];
//    [cell setCountry:c.countries code:c.showCode];
//    return cell;
    static NSString *cellID = @"MyCoutry";
    HBPhoneAttributionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HBPhoneAttributionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //先取出数组里面的model数据
//    HBCountry *model = _list[indexPath.row];
        HBCountryTitle *t = _list[indexPath.section];
        HBCountry *c = t.list[indexPath.row];
//    //将model传递给视图
    cell.CoutryMod = c;
    return cell;

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    HBCountryTitle *t = _list[indexPath.section];
    HBCountry *c = t.list[indexPath.row];
//    HBCountry *c = _list[indexPath.row];
    
    [self selectCountry:c];
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    if (searchText.length > 0) {
//    } else {
//        _searchCountryView.hidden = YES;
//    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *text = searchBar.text;
    [self.view endEditing:YES];
    if (text.length > 0) {
//        HBCountryTitle *t = _list[1];
//        NSArray *list = [HBCountry searchText:text list:t.list];
//        HBLog(@"%@", list);
//        _searchCountryView.list = list;
//        _searchCountryView.hidden = NO;
    }
}

#pragma mark - HBSearchCountryViewDelegate
//- (void)searchCountryView:(HBSearchCountryView *)searchCountryView selectCountry:(HBCountry *)country
//{
//    [self selectCountry:country];
//}

- (void)selectCountry:(HBCountry *)country
{
    if ([self.delegate respondsToSelector:@selector(phoneAttributionVC:selectCountry:)]) {
        [self.delegate phoneAttributionVC:self selectCountry:country];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
