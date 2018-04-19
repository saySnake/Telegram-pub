//
//  BaseViewController.m
//  DrLink_IOS
//
//  Created by liuwenjie on 15/5/19.
//  Copyright (c) 2015年 DrLink. All rights reserved.
//

#import "BaseViewController.h"
#import "YJAlertView.h"

void *const isModelPresent="isModelPresent";

@interface BaseViewController ()<UIGestureRecognizerDelegate>
{
    BOOL _firstAppear;
}

@end

@implementation BaseViewController
-(void)dealloc{
    DLog(@"\n\n****************************************\n***销毁%@***\n****************************************\n",self);
}

-(BOOL)isPresent{
    return [objc_getAssociatedObject(self, isModelPresent) boolValue];
}
/**
 状态栏样式
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
/**
 百度统计
 */
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *vcClassName=NSStringFromClass([self class]);
    if (_firstAppear) {
        _firstAppear=NO;
        if (self.viewDidLoadAppear) {
            self.viewDidLoadAppear();
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSString *vcClassName=NSStringFromClass([self class]);
    
}

- (void)viewDidLoad {
    _firstAppear=YES;
    self.view.backgroundColor=RGBACOLOR(235, 235, 241, 1);
    self.navigationController.interactivePopGestureRecognizer.delegate =self;
    [super viewDidLoad];
}
-(CustNavBar *)navBar{
    if (_navBar==nil) {
        _navBar =[[CustNavBar alloc]initWithFrame:CGRectMake(0, 0, DScreenW, 0)];
        __weak typeof(self) weakself=self;
        _navBar.itemClick =^(NSInteger type){
            [weakself navBarButtonClick:type];
        };
        _navBar.btnClick =^(UIButton *btn){
            [weakself navBarTitleClick:btn];
        };
        [_navBar setLeftItemImage:@"back"];
        if (self==self.navigationController.viewControllers[0]) {
            self.leftBackItemHiden=YES;
        }
        [self.view addSubview:_navBar];
        _navBar.hidden=YES;
    }
    return _navBar;
}
-(void)setNavBarVisible:(NSString *)title{
    [self.navBar setBarTitle:title];
    self.navBar.hidden=NO;
}


- (void)setCustCenterView:(UIView *)custView
{
    _navBar =[[CustNavBar alloc]initWithFrame:CGRectMake(0, 0, DScreenW, 64)];
    [_navBar setCenterView:custView];
    [_navBar setLeftItemImage:@"back"];
    __weak typeof(self) weakself=self;
    _navBar.itemClick =^(NSInteger type){
        [weakself navBarButtonClick:type];
    };
    _navBar.btnClick =^(UIButton *btn){
        [weakself navBarTitleClick:btn];
    };
    
    [self.view addSubview:_navBar];
    
}


-(void)setLeftBackItemHiden:(BOOL)leftBackItemHiden{
    _leftBackItemHiden=leftBackItemHiden;
    self.navBar.leftBtn.hidden=leftBackItemHiden;
}

-(void)setLeftBtnImage:(NSString *)image{
    [self.navBar setLeftItemImage:image];
}
-(void)setRightBtnImage:(NSString *)image{
    [self.navBar setRightItemImage:image];
}

-(void)setRightBtnStyle:(NavBarBtnStyle)style{
    [_rightBtn removeFromSuperview];
    _rightBtn=nil;
    _rightBtn=[[UIButton alloc]init];
    _rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    _rightBtn.layer.borderWidth=1.f;
    _rightBtn.cornerRadius=2.f;
    _rightBtn.titleLabel.font=kFontSmall;
    CGSize size;
    NSString *title;
    switch (style) {
        case NavBarBtnStyleDone://"完成"
        {
            title=@"完成";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleEdit://"编辑"
        {
            title=@"编辑";
            size=CGSizeMake(40, 20);
            
        }
            break;
        case NavBarBtnStyleCancle://"取消"
        {
            title=@"取消";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleApplyAdmin://"申请管理员"
        {
            title=@"申请管理员";
            size=CGSizeMake(70, 20);
            
        }
            break;
        case NavBarBtnStyleNextStep://"下一步"
        {
            title=@"下一步";
            size=CGSizeMake(50, 20);
            
        }
            break;
        case NavBarBtnStylePublicNotice://"发布公告"
        {
            title=@"发布公告";
            size=CGSizeMake(60, 20);
            
        }
            break;
        case NavBarBtnStyleSure://"确定"
        {
            title=@"确定";
            size=CGSizeMake(40, 20);
            
        }
            break;
        case NavBarBtnStyleAdd:{
            title=@"添加";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleNone:{
            _rightBtn=nil;
        }
            break;
        case NavBarBtnStyleSave:{
            title=@"保存";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleSend:{
            title=@"发送";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleInvitate:{
            title=@"邀请";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleSearch:{
            title =@"查找";
            size =CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleSort:{
            title =@"排班";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleClear:{
            title=@"清空";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleContactAdmin:{
            title=@"联系管理员";
            size=CGSizeMake(60, 20);
        }
            break;
        case NavBarBtnStyleApplyRelease:{
            title=@"申请发布";
            size=CGSizeMake(60, 20);
        }
            break;
        case NavBarBtnStyleApplyColumn: {
            title = @"申请";
            size = CGSizeMake(40.f, 20.f);
        };
            break;
        case NavBarBtnStyleMyColumn: {
            title = @"我的专栏";
            size = CGSizeMake(60.f, 20.f);
        }
            break;
        case NavBarBtnStyleAlbum:{
            title=@"相册";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStylePost: {
            title =@"发起";
            size =CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleDelete: {
            title = @"删除";
            size = CGSizeMake(40.f, 20.f);
        }
            break;
        case NavBarBtnStyleModify: {
            title = @"修改";
            size = CGSizeMake(40.f, 20.f);
        }
            break;
        default:
            break;
    }
    _rightBtn.bounds=CGRectMake(0, 0, size.width, size.height);
    _rightBtn.center=CGPointMake(self.navBar.width-10-size.width/2, 44);
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:_rightBtn];
}

-(void)setLeftBtnStyle:(NavBarBtnStyle)style{
    [_leftBtn removeFromSuperview];
    _leftBtn=nil;
    _leftBtn=[[UIButton alloc]init];
    _leftBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    _leftBtn.layer.borderWidth=1.f;
    _leftBtn.cornerRadius=2.f;
    _leftBtn.titleLabel.font=kFontSmall;
    CGSize size;
    NSString *title;
    switch (style) {
        case NavBarBtnStyleDone://"完成"
        {
            title=@"完成";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleEdit://"编辑"
        {
            title=@"编辑";
            size=CGSizeMake(40, 20);
            
        }
            break;
        case NavBarBtnStyleCancle://"取消"
        {
            title=@"取消";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleApplyAdmin://"申请管理员"
        {
            title=@"申请管理员";
            size=CGSizeMake(70, 20);
            
        }
            break;
        case NavBarBtnStyleNextStep://"下一步"
        {
            title=@"下一步";
            size=CGSizeMake(50, 20);
            
        }
            break;
        case NavBarBtnStylePublicNotice://"发布公告"
        {
            title=@"发布公告";
            size=CGSizeMake(60, 20);
            
        }
            break;
        case NavBarBtnStyleSure://"确定"
        {
            title=@"确定";
            size=CGSizeMake(40, 20);
            
        }
            break;
        case NavBarBtnStyleAdd:{
            title=@"添加";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleNone:{
            _rightBtn=nil;
        }
            break;
        case NavBarBtnStyleSave:{
            title=@"保存";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleSend:{
            title=@"发送";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleInvitate:{
            title=@"邀请";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleSearch:{
            title =@"查找";
            size =CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleSort:{
            title =@"排班";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleClear:{
            title=@"清空";
            size=CGSizeMake(40, 20);
        }
            break;
        case NavBarBtnStyleContactAdmin:{
            title=@"联系管理员";
            size=CGSizeMake(60, 20);
        }
            break;
        case NavBarBtnStyleApplyRelease:{
            title=@"申请发布";
            size=CGSizeMake(60, 20);
        }
            break;
        default:
            break;
    }
    _leftBtn.bounds=CGRectMake(0, 0, size.width, size.height);
    _leftBtn.center=CGPointMake(10+size.width/2, 44);
    [_leftBtn setTitle:title forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:_leftBtn];
    
}

//导航栏标题
-(void)setNavBarTitle:(NSString *)title{
    [self.navBar setBarTitle:title];
}


-(void)rightBtnClick:(UIButton *)sender{
    [self navBarButtonClick:1];
}
//导航栏按钮点击时间
-(void)navBarButtonClick:(NSInteger )idx{
    switch (idx) {
        case 0:{
            if ([objc_getAssociatedObject(self, isModelPresent) boolValue]) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else
                [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
    
}


/**
 *  标题按钮点击方法
 *
 *  @param button button
 */
-(void)navBarTitleClick:(UIButton *)button{
    /*
     supper code
     */
}


-(void)showNotData:(NSString *)label{
    UILabel *labl=[[UILabel alloc] init];
    labl.bounds=CGRectMake(0, 0, self.view.width, 120);
    labl.center=self.view.center;
    labl.font=[UIFont systemFontOfSize:30];
    labl.textColor=kColorGray3;
    labl.textAlignment=NSTextAlignmentCenter;
    labl.text=label;
    labl.tag=9876;
    [self.view addSubview:labl];
}
-(void)removeNotData{
    UILabel *lbl=(UILabel *)[self.view viewWithTag:9876];
    [lbl removeFromSuperview];
}
-(void)showYJAlert:(NSString *)msg{
    YJAlertView *alert=[[YJAlertView alloc] initWithTitle:@"提示" message:msg btnTitles:@[@"确定"] click:^(YJAlertView *alert, NSInteger index) {
    }];
    [alert show];
}

#pragma mark - ovrride super present method
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    UIViewController *vc=viewControllerToPresent;
    if ([viewControllerToPresent isKindOfClass:[UINavigationController class]]) {
        vc=((UINavigationController *)viewControllerToPresent).viewControllers.firstObject;
    }
    
    if ([vc isKindOfClass:[BaseViewController class]]) {
        objc_setAssociatedObject(vc, isModelPresent, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
void showNormalAlert(NSString *msg){
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
/**
 jobtitle
 */

NSArray * allJobTitle(){
    return @[@"主任医师",@"副主任医师",@"主治医师",@"医师",@"住院医师",@"医士",@"研究生",@"实习生",@"主任药师",@"副主任药师",@"药师",@"其他"];
}

#pragma mark - banner


#pragma mark storyboard

- (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)storyboardId
                                           withStoryboardName:(NSString *)name {
    if (name.length == 0 || storyboardId.length == 0) {
        return nil;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    return controller;
}

#pragma mark tableView

- (void)hideOtherCellLine:(UITableView *)tableView {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)reloadTableView:(UITableView *)tableView indexPathForRow:(NSInteger)row inSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
}


@end
