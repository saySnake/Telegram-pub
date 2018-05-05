//
//  ViewController.m
//  CellSlideDelete
//
//  Created by SunnyZhang on 16/11/8.
//  Copyright © 2016年 Sunny. All rights reserved.
//

#import "TGHotPayVC.h"
#import "TGPayCell.h"
#import "UIView+Common.h"
#import "TGHotPayListView.h"
#import "TGTransVC.h"
#import "TGPayStyleCellOne.h"

@interface TGHotPayVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableTest;

@property(nonatomic,strong) NSMutableArray *arr;

@end

@implementation TGHotPayVC

//pragma mark 懒加载初始化table
#pragma mark 系统方法-didload
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _tableTest = [[UITableView alloc]initWithFrame:self.frames style:UITableViewStylePlain];
    
    _tableTest.delegate = self;
    
    _tableTest.dataSource =self;
    
    //    self.view.backgroundColor = [UIColor orangeColor];
    
    _tableTest.tableFooterView = [[UIView alloc]init];
    
    self.arr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *arrtemp = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    
    [self.arr addObjectsFromArray:arrtemp];
    
    [self.view addSubview:self.tableTest];
    

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)update
{
    _tableTest.frame =self.view.frame;
}

//2.完成table的代理方法
//
//3.删除操作

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr count];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"TGPayStyleCellOne";

    static NSString *cellId =@"TGPayCell";
    TGPayStyleCellOne *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    TGPayCell *cl =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (indexPath.row ==0) {
        if (!cl) {
            cl =[TGPayCell initViewFromNib];
            [cl setRestorationIdentifier:cellId];
        }
        return cl;
    }else {
    if (!cell) {
        cell =[TGPayStyleCellOne initViewFromNib];
        [cell setRestorationIdentifier:identify];
    }
//    cell.textLabel.text =[NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
    }
    return nil;
}



#pragma mark 删除行

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (!indexPath.row ==0) {
        // 先删除模型
        [self.arr removeObjectAtIndex:indexPath.row];
        
        // 再刷新数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

    }
}

//4.根据需要 修改默认的delete

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return @"删除";
}

//5.当有多个操作按钮时候，类似于QQ上的向左滑动操作
- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        return nil;
    }else{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"划转" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
//        [self.arr removeObjectAtIndex:indexPath.row];
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"划转");
        TGTransVC *trans =[[TGTransVC alloc] init];
        [self.navigationController pushViewController:trans animated:YES];
        
    }];
    
    // 改变滑动的背景色 （根据需要修改颜色）
    action0.backgroundColor = RGBACOLOR(38.0f, 38.0f, 38.0f, 1);
    return @[action0];
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        TGHotPayListView *vi =[[TGHotPayListView alloc] init];
        [self.navigationController pushViewController:vi animated:YES];
    }
}

- (void)viewDidLayoutSubviews

{
    [super viewDidLayoutSubviews];
    _tableTest = [[UITableView alloc]initWithFrame:self.frames];

    
}

@end



