//
//  HBSearchCountryView.m
//  Telegraph
//
//  Created by 陈俊儒 on 2018/4/19.
//

#import "HBSearchCountryView.h"
#import "HBPhoneAttributionCell.h"
#import "HBCountry.h"

@interface HBSearchCountryView()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;

@end

@implementation HBSearchCountryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tableView.frame = self.bounds;
}

#pragma mark - setter
- (void)setList:(NSArray *)list
{
    _list = list;
    [_tableView reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyCoutry";
    HBPhoneAttributionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HBPhoneAttributionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    HBCountry *CoutryMod = _list[indexPath.row];
    //    [cell setCountry:c.countries code:c.showCode];
    cell.CoutryMod = CoutryMod;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(searchCountryView:selectCountry:)]) {
        [self.delegate searchCountryView:self selectCountry:_list[indexPath.row]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(searchCountryView:scrollViewDidScroll:)]) {
        [self.delegate searchCountryView:self scrollViewDidScroll:scrollView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
