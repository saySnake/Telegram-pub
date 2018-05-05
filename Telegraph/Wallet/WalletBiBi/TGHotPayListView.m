//
//  TGHotPayListView.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/27.
//

#import "TGHotPayListView.h"
#import "TGHotPayCell.h"
#import "TGPayStyleCell.h"
#import "PayListModel.h"
#import "PayStyleModel.h"
#import "PayListModel.h"
#import "TGHotPayListView.h"
#import "TGSortView.h"
#define RTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RTRandomColor RTColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


@interface TGHotPayListView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) NSMutableArray *totalArr;
@property (nonatomic, strong) PayListModel *sectionModel;
@property (nonatomic, strong) PayStyleModel *styleModel;
@property (nonatomic, strong) TGSortView *sortView;

@end

@implementation TGHotPayListView

- (TGSortView *)sortView
{
    if (!_sortView) {
        TGSortView *sortview =[[TGSortView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:sortview];
        self.sortView =sortview;
    }
    return _sortView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView =[UIView new];
    [self data];
}

- (void)data
{
    self.totalArr =[NSMutableArray array];    
    
    for (int i =0 ; i<2; i++) {
        for (int j =0; j<5; j++) {
            if (j ==0) {
                self.sectionArr =[NSMutableArray array];
                PayListModel *sec =[[PayListModel alloc] init];
                sec.time =@"2018.4";
                [self.sectionArr addObject:sec];
            }
            PayStyleModel *style =[[PayStyleModel alloc] init];
            style.time =@"0407 21:00";
            style.imgColor =RTRandomColor;
            [self.sectionArr addObject:style];
        }
        [self.totalArr addObject:self.sectionArr];
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden =YES;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row ==0) {
            return 60;
        }else{
            return 50;
        }
}

- (IBAction)fanhui:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)seleAction:(id)sender
{
    NSLog(@"筛选");
    [self.sortView show:self];
    self.sortView.budgetSortClicked = ^(NSInteger index) {
        NSLog(@"%ld",index);

    };
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.totalArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sec =self.totalArr[section];
    return sec.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId =@"TGHotPayCell";
    static NSString *cellid =@"TGPayStyleCell";
    
    
    TGHotPayCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    TGPayStyleCell *cel =[tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (indexPath.row==0) {
        PayListModel *m =self.totalArr[indexPath.section][0];
        if (!cell) {
            cell =[TGHotPayCell initViewFromNib];
            [cell setRestorationIdentifier:cellId];
        }
        cell.model =m;
        return cell;
    }else{
        PayStyleModel *model =self.totalArr[indexPath.section][indexPath.row];

        if (!cel) {
            cel =[TGPayStyleCell initViewFromNib];
            [cel setRestorationIdentifier:cellid];
        }
        cel.model =model;
        return cel;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
    }
}



@end
