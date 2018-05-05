//
//  TGCapitalListVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/5/2.
//

#import "TGCapitalListVC.h"
#import "TGCapitalCell.h"

@interface TGCapitalListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,strong)NSMutableArray *dataArray;

@end

@implementation TGCapitalListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =RGBACOLOR(235.0f, 235.0f, 240.0f, 1);
    self.tableview.delegate =self;
    self.tableview.backgroundColor =RGBACOLOR(235.0f, 235.0f, 240.0f, 1);
    self.tableview.dataSource =self;
    self.tableview.rowHeight =50;
    self.tableview.tableFooterView =[UIView new];
    self.dataArray =[NSMutableArray array];
    [self data];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}

- (void)data
{
    for (int i=0; i<3; i++) {
        NSObject *ob =[[NSObject alloc] init];
        [self.dataArray addObject:ob];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cid =@"TGCapitalCell";
    TGCapitalCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell =[TGCapitalCell initViewFromNib];
        [cell setRestorationIdentifier:cid];
    }
    
    
    return cell;
}




@end
