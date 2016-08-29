
//  CreditViewController.m
//  DIRECT
//
//  Created by admin on 04/02/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CreditViewController.h"

@interface CreditViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@end

@implementation CreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //imageview shape from rectangle to circle
    [self.profilePicture.layer setCornerRadius:self.profilePicture.frame.size.width/2];
    [self.profilePicture.layer setMasksToBounds:YES];
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePicture.layer.borderWidth=2;
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
