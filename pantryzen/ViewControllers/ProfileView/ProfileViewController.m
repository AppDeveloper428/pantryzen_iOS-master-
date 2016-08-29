//
//  ProfileViewController.m
//  DIRECT
//
//  Created by admin on 29/01/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWrevealViewController.h"
#import "UIViewController+ENPopUp.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // SWRevealViewController activity
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // navigation button customize
    self.navigationItem.title = @"";
    
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor redColor],
//       NSFontAttributeName:[UIFont fontWithName:@"lato" size:12]}];
    
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
- (IBAction)showPromoCodePopup:(id)sender {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PromoCodePopUp"];
    vc.view.frame = CGRectMake(0, 0, 270.0f, 169.0f);
    [self presentPopUpViewController:vc];
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
