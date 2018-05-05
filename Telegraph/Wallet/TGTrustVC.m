//
//  TGTrustVC.m
//  Telegraph
//
//  Created by 张玮 on 2018/5/4.
//

#import "TGTrustVC.h"

@interface TGTrustVC ()
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIImageView *ImgView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;

@end

@implementation TGTrustVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IWNotificationCenter addObserver:self selector:@selector(checkTextChange) name:UITextFieldTextDidChangeNotification object:self.nameTextField];

    [IWNotificationCenter addObserver:self selector:@selector(checkTextChange) name:UITextFieldTextDidChangeNotification object:self.cardTextField];

}

- (void)checkTextChange
{
    if (self.cardTextField.text.length ==18 && self.nameTextField.text) {
        [self.okBtn setEnabled:YES];
        [self.okBtn setImage:[UIImage imageNamed:@"33.png"] forState:UIControlStateNormal];
    }else {
        [self.okBtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)okAction:(id)sender
{
    NSLog(@"确认实名认证");
}


@end
