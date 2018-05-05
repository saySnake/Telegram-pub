//
//  TGTransVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/5/1.
//

#import "TGTransVC.h"
#import "TGSortCoinView.h"
#import "TGBudgeTitleBtn.h"
#import "TGPayListModel.h"

@interface TGTransVC ()

@property (weak, nonatomic) IBOutlet TGSortCoinView *navButton;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (nonatomic, strong) TGSortCoinView *sortView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UITextField *faTextField;//法
@property (weak, nonatomic) IBOutlet UITextField *biTextField;//法
@property (weak, nonatomic) IBOutlet UITextField *faCountFiel;

@property (weak, nonatomic) IBOutlet UIButton *toFaBtn;


@property (weak, nonatomic) IBOutlet UITextField *bTield;
@property (weak, nonatomic) IBOutlet UITextField *bibiTield;
@property (weak, nonatomic) IBOutlet UITextField *countField;

@property (weak, nonatomic) IBOutlet UIView *tapBi; //从法币交易站
@property (weak, nonatomic) IBOutlet UIView *tapFa; //从币币交易站
@property (nonatomic,assign) BOOL isShow;

@end

@implementation TGTransVC

- (TGSortCoinView *)sortView
{
    if (!_sortView) {
        TGSortCoinView *sortview =[[TGSortCoinView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:sortview];
        self.sortView =sortview;
    }
    return _sortView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tapBi.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.tapBi addGestureRecognizer:tap];

    
    UITapGestureRecognizer *tapp =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.tapFa addGestureRecognizer:tapp];

    
    
    self.viewTwo.userInteractionEnabled =YES;
    [self.toFaBtn addGestureRecognizer:tap];

    [self setUpView];
}



- (void)tap
{
    if (!self.isShow) {
        self.viewTwo.hidden =YES;
        self.isShow =YES;
    }else {
        self.viewTwo.hidden =NO;
        self.viewTwo.userInteractionEnabled =YES;
        self.isShow =NO;
    }
}


- (void)setUpView
{
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}


- (IBAction)navAction:(TGBudgeTitleBtn *)sender
{
    NSLog(@"筛选");
    [self.sortView show];
    self.sortView.budgetSortClicked = ^(NSInteger index) {
        [sender setTitle:[NSString stringWithFormat:@"划转%@",[TGPayListModel getCoinStr:index]] forState:UIControlStateNormal];
        
    };
    
}

//法币全部划转
- (IBAction)fabiAction:(id)sender
{
    
}

//法币确认划转
- (IBAction)faAction:(id)sender
{
    
}



#pragma mark -币币交易

//币币
- (IBAction)allBIAction:(id)sender {
    
}

//币币
- (IBAction)biOKACtion:(id)sender {
    
}

- (IBAction)backAaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
