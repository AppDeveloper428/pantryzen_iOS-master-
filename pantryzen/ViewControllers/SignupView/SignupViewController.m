//
//  ProductPageViewController.m
//  pantryzen
//
//  Created by admin on 17/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "SignupViewController.h"
#import "MIBadgeButton.h"
#import "AppDelegate.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "PaymentDetailViewController.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressLine1;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressLine2;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.navigationController.navigationBar setBackIndicatorImage:
     [UIImage imageNamed:@"back_btn.png"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:
     [UIImage imageNamed:@"back_btn.png"]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.lblCity.text = [userDefaults objectForKey:@"SaveCity"];
    self.lblAddressLine1.text = [userDefaults objectForKey:@"SaveAddressLine1"];
    self.lblAddressLine2.text = [userDefaults objectForKey:@"SaveAddressLine2"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}



- (IBAction)onClickSignupBtn:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.txtEmail.text.length == 0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Email Address" message:@"Please enter your email address!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if(self.txtPassword.text.length == 0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password" message:@"Please enter your password!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if(self.txtFirstName.text.length == 0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid First Name" message:@"Please enter your first name!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if(self.txtLastName.text.length == 0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Last name" message:@"Please enter your last name!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
    
        //-------------------send request----------------------
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"sign_up"];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //    NSLog(@"CGH : %@", [userDefaults objectForKey:@"CustomerID"]);
        [manager POST:URL //post URL here
           parameters: @{@"email":   self.txtEmail.text,
                         @"password": self.txtPassword.text,
                         @"address_line1": [userDefaults objectForKey:@"SaveAddressLine1"],
                         @"address_line2": [userDefaults objectForKey:@"SaveAddressLine2"],
                         @"city": [userDefaults objectForKey:@"SaveCity"],
                         @"first_name": self.txtFirstName.text,
                         @"last_name": self.txtLastName.text
                         }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  if (![[responseObject valueForKey:@"message"]  isEqual: @"SIGNUPSUCCESS"]) {
                      
                      
                      //alert
                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Signup Failed!" message:@"Sorry, Your email address has already registered!" preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                      [alertController addAction:ok];
                      [self presentViewController:alertController animated:YES completion:nil];
                      
                      //alert-end
                      
                      
                  }else{
                      
                      [AppDelegate sharedInstance].createFlag = YES;
                      NSDictionary *user = [responseObject valueForKey:@"data"];
                      [userDefaults setObject:[user valueForKey:@"id"] forKey:@"CustomerID"];
                      
                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                      PaymentDetailViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
                      VC.isFromSignup = TRUE;
                      
                      [self presentViewController:VC animated:YES completion:nil];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  
                  NSLog(@"CGH Error: %@", error);
                  //alert
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"request error!" message:@"Sorry, request error!" preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [alertController addAction:ok];
                  [self presentViewController:alertController animated:YES completion:nil];
                  //alert-end
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  return;
              }
         ];
        //------------------end request---------------------------
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
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