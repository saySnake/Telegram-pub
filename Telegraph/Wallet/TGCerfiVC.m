//
//  TGCerfiVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/5/4.
//  实名认证

#import "TGCerfiVC.h"
#import "TGCerCell.h"
#import "TGTrustVC.h"

@interface TGCerfiVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TGCerfiVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.navView];
//    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(HEIGHT_STATUS_BAR);
//    }];
    self.tableView.delegate=self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView =[UIView new];
    self.tableView.backgroundColor =RGBACOLOR(247.0f, 247.0f, 247.0f, 1);
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(HEIGHT_STATUS_BAR);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.bottom);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).offset(-HEIGHT_STATUS_BAR);
    }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *inden =@"TGCerCell";
    TGCerCell *cell =[tableView dequeueReusableCellWithIdentifier:inden];
    if (!cell) {
        cell =[TGCerCell initViewFromNib];
        [cell setRestorationIdentifier:inden];
    }
    cell.cerLabel.hidden =NO;
    if (indexPath.row!=0) {
        cell.cerLabel.hidden =YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            {
                NSLog(@"实名认证");
                TGTrustVC *trust =[[TGTrustVC alloc] init];
                [self.navigationController pushViewController:trust animated:YES];
            }
            break;
        case 1:{
                NSLog(@"设置支付密码");
            
        }
            break;
        case 2:{
                NSLog(@"修改支付密码");
            
        }
        default:
            break;
    }
}



@end
