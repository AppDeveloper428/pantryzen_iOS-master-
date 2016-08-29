//
//  LoginViewController.m
//  pantryzen
//
//  Created by admin on 16/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "Global.h"
#import "AppDelegate.h"
#import "ULNavigationController.h"
#import "SignupViewController.h"
#import "CheckAddressViewController.h"
#import "ProductListViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>{

    NSString *email;
}
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    email = [userDefaults objectForKey:@"Email"];
    
    NSLog(@"%@", [userDefaults objectForKey:@"SaveCity"]);
    NSLog(@"%@", [userDefaults objectForKey:@"SaveAddressLine1"]);
    NSLog(@"%@", [userDefaults objectForKey:@"SaveAddressLine2"]);
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:(245/255.0) green:(232/255.0) blue:(209/255.0) alpha:1] }];
    
    self.txtEmail.delegate = self;
    
    self.txtPassword.delegate = self;
    
    self.txtEmail.attributedPlaceholder = str;
    
    NSAttributedString *pdstr = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:(245/255.0) green:(232/255.0) blue:(209/255.0) alpha:1] }];
    
    self.txtPassword.attributedPlaceholder = pdstr;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    prevPt = touchPoint;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    self.parentTopConstraint.constant = self.parentTopConstraint.constant + touchPoint.y - prevPt.y;
    self.parentBottomConstraint.constant = self.parentBottomConstraint.constant - touchPoint.y + prevPt.y;
    if (self.parentTopConstraint.constant > 0) {
        self.parentTopConstraint.constant = 0;
        self.parentBottomConstraint.constant = 0;
    }

    prevPt = touchPoint;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtEmail) {
        [self.txtPassword becomeFirstResponder];
    } else if (textField == self.txtPassword) {
        [self.view endEditing:YES];
        [self onClickLoginBtn:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *email = [userDefaults objectForKey:@"Email"];
    
    NSString *pass = [userDefaults objectForKey:@"password"];
    
    NSLog(@"email ============= %@", email);
    
    if (![self.txtEmail.text isEqualToString:@""]){
        
        if (![self.txtPassword.text isEqualToString:@""]) {
            
            NSLog(@"============= find ====================");
          
        }

    }
    
    /*
    
    if (![self.txtEmail.text isEqualToString:email]){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Will you login with the other user id?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     
                                     self.txtPassword.text = @"";

                                     
                                     [alertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                     
                                 }];
        
        UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 
                                 self.txtEmail.text = email;
                                 
                                 self.txtPassword.text = pass;
                                 
                                 [alertController dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                             }];
        
        
        
        [alertController addAction:cancel];
        [alertController addAction:ok];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
    
//        self.txtPassword.text = @"";
    }
     */
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (IBAction)onClickLoginBtn:(id)sender {
    
    
    
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
        
    }else{
        

        //-------------------send request----------------------
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"login"];
        
//        NSString *param_uid= @"?uid=";
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *currentUser_uid = [userDefaults objectForKey:@"SaveUserUID"];
//        
//        NSArray *arrStrs = [NSArray arrayWithObjects:oriURL, reservationNumber, param_uid, currentUser_uid, nil];
//        NSString *strRequestURL = [arrStrs componentsJoinedByString:@""];
//        NSLog(@"%@", strRequestURL);
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSLog(@"%@%@", self.txtEmail.text, self.txtPassword.text);
        
        
        NSLog(@"email ======== %@", self.txtEmail.text);
        NSLog(@"password ====== %@", self.txtPassword.text);
        NSLog(@"address_line1 ========== %@", [userDefaults objectForKey:@"SaveAddressLine1"]);
        NSLog(@"address_line2 ============ %@", [userDefaults objectForKey:@"SaveAddressLine2"]);
        
        NSLog(@"city=========== %@", [userDefaults objectForKey:@"SaveCity"]);

        
        
        [manager POST:URL //post URL here
           parameters: @{@"email":   self.txtEmail.text,
                         @"password": self.txtPassword.text,
                         @"address_line1": [userDefaults objectForKey:@"SaveAddressLine1"],
                         @"address_line2": [userDefaults objectForKey:@"SaveAddressLine2"],
                         @"city": [userDefaults objectForKey:@"SaveCity"]
                         }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  NSLog(@"%@", responseObject);
                  if (![[responseObject valueForKey:@"message"]  isEqual: @"LOGINSUCCESS"]) {
                      //alert
                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Failed!" message:@"Sorry, Please check your email address and password again!" preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                      [alertController addAction:ok];
                      [self presentViewController:alertController animated:YES completion:nil];
                      //alert-end
                  }else{
                      NSLog(@"----------------------------true---------------");
                      
                      
                      NSLog(@"=================[AppDelegate sharedInstance].arrMyCart ========== %lu", [AppDelegate sharedInstance].arrMyCart.count);
                      
                      NSString *customerid = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomerID"];
                      
                      NSDictionary *user = [[responseObject valueForKey:@"userinfo"] objectAtIndex:0];
                      
//                      NSLog(@"%@%@", user,responseObject);
                 
                      [userDefaults setObject:self.txtEmail.text forKey:@"Email"];
                      
                      [userDefaults setObject:self.txtPassword.text forKey:@"password"];
                      
                      [userDefaults setObject:[user valueForKey:@"id"] forKey:@"CustomerID"];
              
                      
                      NSLog(@"=================[AppDelegate sharedInstance].arrMyCart ========== %lu", [AppDelegate sharedInstance].arrMyCart.count);
                      
                      /*
                      NSMutableArray *totalArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"myCartList"]];
                      
                      [userDefaults setObject:totalArray forKey:@"cartlist"];
                      
                      [[AppDelegate sharedInstance].arrMyCart addObjectsFromArray:totalArray];
                      
                      NSLog(@"%@", [AppDelegate sharedInstance].arrMyCart);
                       */
                      
//                      SWRevealViewController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//                      [self.navigationController pushViewController:swVC animated:YES];
                      
                      if ([AppDelegate sharedInstance].loginFlag == NO) {
                      
                          ULNavigationController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
                          [self presentViewController:swVC animated:YES completion:nil];
                          
                          [AppDelegate sharedInstance].createFlag = YES;
                          
                      }else{
                          
                          ULNavigationController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
                          [self presentViewController:swVC animated:YES completion:nil];
                          
                          [AppDelegate sharedInstance].createFlag = YES;
//                      
//                          [self dismissViewControllerAnimated:YES completion:nil];
                      
                      }
                  
                      
                      
                  }
                  
              }
         
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"Error: %@", error);
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

- (IBAction)btn_create:(id)sender {
    
//    if ([AppDelegate sharedInstance].createFlag == NO) {
    
    
    CheckAddressViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckAddressViewController"];
    
    [self presentViewController:nextViewController animated:YES completion:nil];
    
    
//        SignupViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
//    
//    [self presentViewController:nextViewController animated:YES completion:nil];
//        [self.navigationController pushViewController: nextViewController animated:YES];
    
//    }else{
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Sorry, You have already created your account!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
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
