//
//  HBFindViewController.m
//  Telegraph
//
//  Created by 段智林 on 2018/5/2.
//

#import "HBFindViewController.h"
#import "MJRefresh.h"
#import "SDCycleScrollView.h"
#import "HBPriceTableViewCell.h"
#import "HBMsgVoiceTableViewCell.h"
#import "HBPriceModel.h"
#import "HBVoiceMsgModel.h"
#import "NewPagedFlowView.h"
#import "HBFindAvatarScrollView.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "HBFlowLayout.h"
#import "HBFindGroupModel.h"
#import "HBFindGroupCollectionViewCell.h"
#import "HBFindNewsModel.h"
#import "HBFindNewsTableViewCell.h"
#import "HBFindSectionView.h"

@interface HBFindViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,
                                    UICollectionViewDataSource,UICollectionViewDelegate,
                                    NewPagedFlowViewDataSource,NewPagedFlowViewDelegate>
{
   UIScrollView * _scrollerView;
   UITableView  * _msgTableView;
   UITableView  *_findTableView;
   UICollectionView *_collectionView;
    
    //留言记录
    NSMutableArray *_msgArray;
    //行情
    NSMutableArray *_priceArray;
    
    //资讯
    NSMutableArray *_newsArray;

    //人头
    NSMutableArray *_avatarArray;
    //群组
    NSMutableArray *_groupArray;
    NSString *imageURL;
}
@end

@implementation HBFindViewController

-(instancetype)init
{
    if (self = [super init]) {
        _msgArray = [[NSMutableArray alloc] init];
        _priceArray = [[NSMutableArray alloc] init];
        _avatarArray = [[NSMutableArray alloc] init];
        _groupArray = [[NSMutableArray alloc] init];
        _newsArray = [[NSMutableArray alloc] init];
        
        for (int i=0;i<6; i++) {
            HBPriceModel *priceModel = [[HBPriceModel alloc] init];
            priceModel.name  = @"BTC";
            priceModel.platorm = @"USDT";
            priceModel.count = 100000;
            priceModel.price = 1000;
            priceModel.level = 0.20f;
            [_priceArray addObject:priceModel];
        }
        
        for (int j=0; j<5; j++) {
            HBVoiceMsgModel *msgModel = [[HBVoiceMsgModel alloc] init];
            msgModel.name = @"Test";
            msgModel.starLevel = 1234343;
            msgModel.duration = 100;
            msgModel.avatar = @"http://h.hiphotos.baidu.com/image/pic/item/908fa0ec08fa513d69018f80316d55fbb3fbd9c1.jpg";
            [_msgArray addObject:msgModel];
        }
        
        for (int g=0; g<2; g++) {
            [_avatarArray addObject:@"http://img.jf258.com/uploads/2015-02-21/001304931.jpg"];
            [_avatarArray addObject:@"http://img.jf258.com/uploads/2015-02-21/001304514.jpg"];
        }
        
        for (int j =0 ; j < 5; j++) {
            
            HBFindGroupModel *groupModel = [[HBFindGroupModel alloc] init];
            groupModel.groupName = @"OKCoin国际站交流群";
            groupModel.groupAvatar = @"http://img.jf258.com/uploads/2015-02-21/001304931.jpg";
            groupModel.desc = @"我们是全球领先的数字资产交易平台之一，从2014年起致力于为全球用户提供安全、快捷的BTC、LTC、ETH、ETC、BCH等数字资产货币的产品体验。";
            groupModel.persionCount = 100000;
            [_groupArray addObject:groupModel];
        }
        
        for (int k=0; k<4; k++) {
            HBFindNewsModel *newsModel = [[HBFindNewsModel alloc] init];
            newsModel.title = @"区块链“兄弟连”背后：女性创客正成为焦点";
            newsModel.viewCount =  13456;
            newsModel.newsType = 1;
            newsModel.date = @"2018-05-05";
            newsModel.iconUrl = @"http://h.hiphotos.baidu.com/image/pic/item/908fa0ec08fa513d69018f80316d55fbb3fbd9c1.jpg";
            [_newsArray addObject:newsModel];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loadView
{
    [super loadView];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)createUI
{
    __weak HBFindViewController *weakSelf = self;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_msg_bg"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.size.width, SCREEN_HEIGHT - HEIGHT_TAB_BAR ));
        make.top.mas_equalTo(weakSelf.view.mas_top ).with.offset(0);
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(0);
    }];
    
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.backgroundColor = [UIColor clearColor];
    _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT-HEIGHT_TAB_BAR)*2);
    //设置分页效果
    _scrollerView.pagingEnabled = YES;
    //禁用滚动
    _scrollerView.scrollEnabled = NO;
    _scrollerView.contentOffset = CGPointMake(0, SCREEN_HEIGHT-HEIGHT_TAB_BAR);
    _scrollerView.delegate = self;
    [self.view addSubview:_scrollerView];
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.size.width, SCREEN_HEIGHT - HEIGHT_TAB_BAR ));
        make.top.mas_equalTo(weakSelf.view.mas_top ).with.offset(0);
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(0);
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"find_nav_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(18, 17));
        make.leftMargin.equalTo(@14);
        make.top.equalTo(weakSelf.view).with.offset(29);
    }];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"find_nav_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(21, 20));
        make.rightMargin.equalTo(@-19);
        make.top.equalTo(self.view).with.offset(27);
    }];
    
    _msgTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _msgTableView.delegate = self;
    _msgTableView.showsVerticalScrollIndicator = NO;
    _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _msgTableView.contentInset = UIEdgeInsetsMake(HEIGHT_NAV_STATUS_BAR, 0, 0, 0);
    _msgTableView.backgroundColor = [UIColor clearColor];
    _msgTableView.dataSource = self;
    [_scrollerView addSubview:_msgTableView];
    [_msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.size.width, SCREEN_HEIGHT-HEIGHT_TAB_BAR-HEIGHT_NAV_STATUS_BAR));
        make.top.mas_equalTo(_scrollerView.mas_top).with.offset(HEIGHT_NAV_STATUS_BAR);
        make.left.mas_equalTo(_scrollerView.mas_left).with.offset(0);
    }];
    
    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 304)];
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(75, 0, SCREEN_WIDTH-60-60, 32)];
    pageFlowView.backgroundColor = [UIColor clearColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.minimumPageScale = 1.0;

    pageFlowView.orginPageCount = _avatarArray.count;
    pageFlowView.isOpenAutoScroll = YES;
    [headerView addSubview:pageFlowView];
    
    UIImageView *whiteBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height*2/5, SCREEN_WIDTH, headerView.frame.size.height*3/5-14)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:whiteBgView];
    
    HBFlowLayout *flowLayout= [[HBFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:15.0f];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pageFlowView.frame)+10, SCREEN_WIDTH, 326/2) collectionViewLayout:flowLayout];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[HBFindGroupCollectionViewCell class] forCellWithReuseIdentifier:@"HBFindGroupCollectionViewCell"];
    [headerView addSubview:_collectionView];
    
    UIImageView *grayBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(whiteBgView.frame), SCREEN_WIDTH, 14)];
    grayBgView.backgroundColor = UIColorFromRGB(244, 244, 244);
    [headerView addSubview:grayBgView];
    
    UIImageView *groupBgView = [[UIImageView alloc] initWithFrame:CGRectMake(32, CGRectGetMaxY(headerView.frame)- 14 - 14- 42, SCREEN_WIDTH-32-32, 42)];
    groupBgView.image = [UIImage imageNamed:@"bg_header_group"];
    [headerView addSubview:groupBgView];
    
    UIImage *bgImage = [UIImage imageNamed:@"find_group"];
    UIImageView *groupView = [[UIImageView alloc] initWithFrame:CGRectMake(11, (groupBgView.frame.size.height - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height)];
    groupView.image = bgImage;
    [groupBgView addSubview:groupView];
    
    UIImage *arrowImage = [UIImage imageNamed:@"Path2"];
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(groupBgView.frame.size.width -6 - 14.5  , (groupBgView.frame.size.height - 11)/2, 6, 11)];
    arrowView.image = arrowImage;
    [groupBgView addSubview:arrowView];
    
    UILabel *moreLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(groupView.frame)+8, (groupBgView.frame.size.height - 16)/2, 84, 16)];
    moreLable.textAlignment = NSTextAlignmentLeft;
    moreLable.textColor = UIColorFromRGB(51, 51, 51);
    moreLable.text = @"更多交流群";
    moreLable.font =  [UIFont systemFontOfSize:16.0f];
    moreLable.backgroundColor = [UIColor clearColor];
    [groupBgView addSubview:moreLable];
    
    _findTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _findTableView.delegate = self;
    _findTableView.showsVerticalScrollIndicator = NO;
    _findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _findTableView.backgroundColor = [UIColor clearColor];
    _findTableView.dataSource = self;
    
    _findTableView.tableHeaderView = headerView;
    [_scrollerView addSubview:_findTableView];
    [_findTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.size.width, SCREEN_HEIGHT-HEIGHT_TAB_BAR-HEIGHT_NAV_STATUS_BAR));
        make.top.mas_equalTo(_scrollerView.mas_top).with.offset(SCREEN_HEIGHT-HEIGHT_TAB_BAR + HEIGHT_NAV_STATUS_BAR);
        make.left.mas_equalTo(_scrollerView.mas_left).with.offset(0);
    }];

    _msgTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            _scrollerView.contentOffset = CGPointMake(0, SCREEN_HEIGHT-HEIGHT_TAB_BAR);
        } completion:^(BOOL finished) {
            
            [_msgTableView.mj_footer endRefreshing];
        }];
    }];

    _findTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:1.0f animations:^{
            _scrollerView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [_findTableView.mj_header endRefreshing];
        }];
        
    }];

}

- (void)localizationUpdated
{
}

#pragma -mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _findTableView) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _msgTableView) {
        return _msgArray.count;
    }else {
        if (section == 0) {
            return _priceArray.count;
        }else if(section == 1){
            return _newsArray.count;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _findTableView) {
        if (indexPath.section == 0) {
            static NSString *CellIdentifier = @"HBPriceTableViewCell";
            HBPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[HBPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            [cell setSeparator:NO middle:NO last:NO];
            [cell setInfo:[_priceArray objectAtIndex:indexPath.row]];
            cell.layer.masksToBounds = YES;
            return cell;
        }else if(indexPath.section == 1){
            static NSString *CellIdentifier = @"HBFindNewsTableViewCell";
            HBFindNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[HBFindNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setSeparator:indexPath.row==0 middle:(indexPath.row >0 && indexPath.row<_newsArray.count-1) last:indexPath.row == _newsArray.count-1];
            [cell setInfo:[_newsArray objectAtIndex:indexPath.row]];
            cell.layer.masksToBounds = YES;
            return cell;
        }
    }else{
        static NSString *CellIdentifier = @"HBMsgVoiceTableViewCell";
        HBMsgVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[HBMsgVoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setInfo:[_msgArray objectAtIndex:indexPath.row]];
        cell.layer.masksToBounds = YES;
        return cell;
    }
    
    return nil;
}

#pragma mark UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _findTableView) {
        if (section == 0){
            HBFindSectionView *sectionView = [[HBFindSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            [sectionView setTitle:@"行情" more:@"查看行情"];
            return sectionView;
            
        }else if(section == 1){
            HBFindSectionView *sectionView = [[HBFindSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            [sectionView setTitle:@"资讯" more:@"更多资讯"];
            return sectionView;
        }
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _findTableView) {
        if (indexPath.section ==0) {
            return 50.0f;
        }else if(indexPath.section == 1){
            return 108;
        }
    }
    return 130.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _findTableView) {
        if (section == 0 || section == 1) {
            return 50.0f;
        }else{
            return 0.01f;
        }
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    
    if (_findTableView == tableView) {
        return 14.0;
    }else{
        return 0.01f;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = UIColorFromRGB(244, 244, 244);
    return footerView;
}


#pragma mark - UICollectionViewDataSource Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _groupArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"HBFindGroupCollectionViewCell";
    HBFindGroupCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [collectionViewCell sizeToFit];
    [collectionViewCell setInfo:_groupArray[indexPath.row]];
    return collectionViewCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(309*0.9, 163*0.9);
}

//item间
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    if (section == 0) {
//        return UIEdgeInsetsMake(0, 0, 0, 0);
//    }else
//        return UIEdgeInsetsMake(14, 14, 14, 14);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0f;
}

#pragma mark - NewPagedFlowViewDataSource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView
{
    return _avatarArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    HBFindAvatarScrollView *adsScrollView = (HBFindAvatarScrollView *)[flowView dequeueReusableCell];
    
    if (!adsScrollView) {
        adsScrollView = [[HBFindAvatarScrollView alloc] initWithFrame:CGRectMake(0, 0, 32+10+10, 32)];
    }
    if (_avatarArray.count == 1) {
        imageURL = [_avatarArray objectAtIndex:0];
    }else
        imageURL = [_avatarArray objectAtIndex:index];
    
    NSString * imageUrl = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIImage *newImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    
    if (newImage) {
        adsScrollView.mainImageView.image = newImage;
    }else{
        [adsScrollView.mainImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@""]];
    }
    return adsScrollView;
    
}

#pragma mark -NewPagedFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView
{
    return CGSizeMake(32+10+10, 32);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView
{
    
}


- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    
}

-(void)search:(id)sender
{
    
}

-(void)left:(id)sender
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
