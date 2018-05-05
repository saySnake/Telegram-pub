//
//  RedListVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/4/20.
//

#import "RedListVC.h"
#import "RedListViewCell.h"
#import "ReceRedModel.h"
#import "QFDatePickerView.h"
#import "QFTimePickerView.h"


@interface RedListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation RedListVC

- (IBAction)fanhui:(id)sender {
    
    self.navigationController.navigationBar.hidden =YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBar setHidden:YES];
    
    self.dataSource =[NSMutableArray array];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self modelRequest];
}

- (void)modelRequest
{
    for (int i =0; i<10; i++) {
        ReceRedModel *model =[[ReceRedModel alloc] init];
        model.time =@"07-19";
        model.money =@"1.02BTC";
        model.name =@"李明";
        [self.dataSource addObject:model];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==_tableView) {
        return _dataSource.count ;
    }
    return 0;
}


- (IBAction)timePicker:(id)sender
{
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initYearPickerViewWithResponse:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
    }];
    [datePickerView show];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId =@"RedListCell";
    RedListViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[RedListViewCell initViewFromNib];
        [cell setRestorationIdentifier:cellId];
    }
    ReceRedModel *model =_dataSource[indexPath.row];
    cell.model =model;
    return cell;
}



@end
