//
//  PromoCodeViewController.m
//  DIRECT
//
//  Created by admin on 04/02/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "PromoCodeViewController.h"
#import "UIViewController+ENPopUp.h"

@interface PromoCodeViewController ()

@end

@implementation PromoCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickOKBtn:(id)sender {
    [self dismissPopUpViewController];
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
