//
//  ProductPageViewController.m
//  pantryzen
//
//  Created by admin on 17/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "NoDeliveryViewController.h"
#import "MIBadgeButton.h"
#import "AppDelegate.h"
#import "MyCartViewController.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"

@interface NoDeliveryViewController ()


@end

@implementation NoDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.navigationController.navigationBar setBackIndicatorImage:
     [UIImage imageNamed:@"back_btn.png"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:
     [UIImage imageNamed:@"back_btn.png"]];
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(yourOtherMethod:)];
//    UIButton *myButton = (UIButton *)[self.view viewWithTag:101];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
//    self.navigationItem.rightBarButtonItem = self.btnShoppingCart;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}



- (IBAction)onClickAddToOrderBtn:(id)sender {
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *obj = @{

                        };
    
    // add into selected array
        [appdelegate.arrMyCart addObject:obj];
    

    //-------------------send request----------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"add_cartlist"];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSLog(@"CGH : %@", [userDefaults objectForKey:@"CustomerID"]);
    
    [manager POST:URL //post URL here
       parameters: @{
                     
                     }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              //              NSLog(@"----------------------------true---------------");
              //              NSLog(@"=============================JSON: %@", responseObject);
//              arrProducts = [responseObject valueForKey:@"data"];
             
              //              NSLog(@"=============================JSON: %@", arrProducts);
              
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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