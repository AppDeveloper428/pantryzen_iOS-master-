//
//  CheckAddressViewController.m
//  pantryzen
//
//  Created by admin on 16/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CheckAddressViewController.h"
#import "LoginViewController.h"
#import "NoDeliveryViewController.h"
#import "SignupViewController.h"
#import "AppDelegate.h"
#import "ULNavigationController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "Global.h"
#import "MBProgressHUD.h"


@interface CheckAddressViewController ()<UITextFieldDelegate>

{
    
}

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *welcomeLabel2TopConstraint;
@property (weak, nonatomic) IBOutlet UITextField *lblAddress;
@end

@implementation CheckAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.lblAddress setDelegate:self];
    
    if (self.view.frame.size.height == 480) {
        UIFont* font = self.welcomeLabel.font;
        font = [UIFont fontWithName:font.fontName size:25];
        self.welcomeLabel.font = font;
        self.welcomeLabel2.font = font;
        self.welcomeLabel2TopConstraint.constant = -5;
    }
    
//    [AppDelegate sharedInstance].loginFlag = NO;
    [AppDelegate sharedInstance].createFlag = NO;
    
    // navigationbar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    BOOL shouldShowWelcomeScreen = ![[NSUserDefaults standardUserDefaults] boolForKey:@"shouldShowWelcomeScreen"];
    
    NSString *customerid = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomerID"];
    
    NSLog(@"%@",customerid);
    if (shouldShowWelcomeScreen) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldShowWelcomeScreen"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIViewController* tutorialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialController"];
        [self presentViewController:tutorialVC animated:NO completion:nil];
    }
    else if (customerid)
    {
        if (![customerid  isEqual: @""]) {
            
            NSMutableArray *totalArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"cartlist"];
            
            [[AppDelegate sharedInstance].arrMyCart addObjectsFromArray:totalArray];
            
            ULNavigationController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
            
            [self presentViewController:swVC animated:YES completion:nil];
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickSigninBtn:(id)sender {
    NSString *city = @"Auckland";
    NSString *addressLine1 = @"Takanini";
    NSString *addressLine2 = self.lblAddress.text;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:city forKey:@"SaveCity"];
    [userDefaults setObject:addressLine1 forKey:@"SaveAddressLine1"];
    [userDefaults setObject:addressLine2 forKey:@"SaveAddressLine2"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:VC animated:YES completion:nil];
    
//    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onClickCheckBtn:(id)sender {
    
    
    // Checking address
    NSString *city = @"Auckland";
    NSString *addressLine1 = @"Takanini";
    NSString *addressLine2 = self.lblAddress.text;
    
    NSString *district = @"Takanini";
    NSString *street = self.lblAddress.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= Check_Address;
    
    if (addressLine2.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delivery Address" message:@"Please enter your address!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [manager POST:URL //post URL here
           parameters: @{@"city":city,
                         @"district":district,
                         @"street":street
                         
                         }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  NSLog(@"============ responseobject ======== %@", responseObject);
                  
                  if ([[responseObject objectForKey:@"message"] isEqualToString:@"SUCCESS"]) {
                      
                      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                      
                      [userDefaults setObject:city forKey:@"SaveCity"];
                      [userDefaults setObject:addressLine1 forKey:@"SaveAddressLine1"];
                      [userDefaults setObject:addressLine2 forKey:@"SaveAddressLine2"];
                      
                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                      BOOL isPossible = TRUE;
                      if(isPossible){ // if delivery possible, go to sign up page
                          
                          SignupViewController *suVC = [storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
                          
                          [self presentViewController:suVC animated:YES completion:nil];
                          //        [self.navigationController pushViewController:suVC animated:YES];
                      }else{ // if delivery impossible, go to no delivery page
                          
                          NoDeliveryViewController *ndVC = [storyboard instantiateViewControllerWithIdentifier:@"NoDeliveryViewController"];
                          [self presentViewController:ndVC animated:YES completion:nil];
                          
                          
                          //        [self.navigationController pushViewController:ndVC animated:YES];
                      }

                      
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
        
    }
   
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    
//    [userDefaults setObject:city forKey:@"SaveCity"];
//    [userDefaults setObject:addressLine1 forKey:@"SaveAddressLine1"];
//    [userDefaults setObject:addressLine2 forKey:@"SaveAddressLine2"];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    BOOL isPossible = TRUE;
//    if(isPossible){ // if delivery possible, go to sign up page
//        
//        SignupViewController *suVC = [storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
//        
//        [self presentViewController:suVC animated:YES completion:nil];
//        //        [self.navigationController pushViewController:suVC animated:YES];
//    }else{ // if delivery impossible, go to no delivery page
//        
//        NoDeliveryViewController *ndVC = [storyboard instantiateViewControllerWithIdentifier:@"NoDeliveryViewController"];
//        [self presentViewController:ndVC animated:YES completion:nil];
//        
//    }
    
    
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
