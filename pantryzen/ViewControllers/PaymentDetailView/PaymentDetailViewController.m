//
//  ProductPageViewController.m
//  pantryzen
//
//  Created by admin on 17/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "PaymentDetailViewController.h"
#import "MIBadgeButton.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "ULNavigationController.h"


@interface PaymentDetailViewController ()

@property (weak, nonatomic) IBOutlet REFormattedNumberField *txtCCNumber;
@property (weak, nonatomic) IBOutlet CustomDatePicker *customPicker;
@property (weak, nonatomic) IBOutlet UITextField *txtVoucher;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataPickerXPosConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataPickerWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataPickerYPosConstraint;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation PaymentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.navigationController.navigationBar setBackIndicatorImage:
     [UIImage imageNamed:@"back_btn.png"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:
     [UIImage imageNamed:@"back_btn.png"]];
    
    if (self.view.frame.size.width == 320 || self.view.frame.size.height == 320) {
        if (self.view.frame.size.width == 480 || self.view.frame.size.height == 480) {
            self.dataPickerYPosConstraint.constant = -5;
        }
        self.dataPickerXPosConstraint.constant = -50;
//        self.dataPickerWidthConstraint.constant = 150;
    }
    
    self.txtCCNumber.format = @"XXXX XXXX XXXX XXXX";
    if(!_isFromSignup){
        self.txtCCNumber.text = self.strCCNumber;
        [self.customPicker setDate:self.expiry_date];
    }

    self.txtVoucher.text = self.strVoucher;
    self.webview.delegate = self;
    [_webview setHidden:NO];
    [self loadiFrame];
}


- (IBAction)onClickSaveCCBtn:(id)sender {
    NSDate *today = [NSDate date];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    NSInteger this_year = [comp year];
    NSInteger this_month = [comp month];


    if (self.txtCCNumber.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Credit Card Number" message:@"Please enter your Credit Card Number!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (self.txtCCNumber.text.length < 16){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Credit Card Number" message:@"Is your Credit Card Number correct?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if([self.customPicker.sel_year intValue] < this_year || ([self.customPicker.sel_year intValue] == this_year &&  [self.customPicker.sel_month intValue] < this_month)){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Expiry Date" message:@"Is your Credit Card expired? Please enter the correct expiry date!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        //-------------------send request----------------------
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, _isFromSignup?@"add_payment_info":@"update_payment_info"];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDateComponents *temps = [[NSDateComponents alloc] init];
        [temps setDay:[self.customPicker.sel_day intValue]+1];
        [temps setMonth:[self.customPicker.sel_month intValue]];
        [temps setYear:[self.customPicker.sel_year intValue]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd"];
        NSString *expiryDate = [dateFormat stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:temps]];

        [manager POST:URL //post URL here
           parameters: @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"],
                         @"expiry":  expiryDate,
                         @"cc_token": self.txtCCNumber.text,
                         @"voucher" : self.txtVoucher.text
                         }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  ULNavigationController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
                  [self presentViewController:swVC animated:YES completion:nil];
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
- (void) saveVoucher {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, _isFromSignup?@"add_payment_info":@"update_payment_info"];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [manager POST:URL //post URL here
       parameters: @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"],
                     @"expiry":  @"2100-12-31",
                     @"cc_token": @"1234 2345 3456 4567",
                     @"voucher" : @"1111 2222 3333"
                     }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              ULNavigationController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
              [self presentViewController:swVC animated:YES completion:nil];
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

- (void) loadiFrame {
    NSString *URLstr= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"generate_paystation_params"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:URLstr //post URL here
       parameters: @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              NSMutableArray *val = [responseObject valueForKey:@"data"];
              NSLog(@"=============================JSON: %@", val);
              
              NSString *reqURL = [val valueForKey:@"url"];
              NSLog(@"=============================JSON: %@", reqURL);
              
              NSURL *url = [NSURL URLWithString:reqURL];
              NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
              [_webview loadRequest:urlRequest];
              
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    int width = [UIScreen mainScreen].bounds.size.width;
    NSString* scriptTitle = [NSString stringWithFormat:@"document.getElementById(\"headerContainer\").style.display='none'; if(document.getElementById(\"messageStep1\")){document.getElementById(\"messageStep1\").innerHTML = \"Select your card type:\";} if(document.getElementById(\"subMessageStep1\")){document.getElementById(\"subMessageStep1\").innerHTML = \"\";} document.getElementById(\"content\").style.width='%dpx';if(document.getElementById(\"purchaseData\")){document.getElementById(\"purchaseData\").style.display='none';} if(document.getElementById(\"messageStep2\")){document.getElementById(\"messageStep2\").innerHTML = \"2: Enter your card details <br> Your card won't be charged until your first order is placed.\";} if(document.getElementById(\"cardholdernamelabel\")){ var label = document.querySelector('label[for=\"cardholder\"]'); label.textContent = 'Have a voucher code?'; document.getElementById(\"cardholder\").style.marginTop = \"5px\";}  document.body.style.backgroundColor = \"#499936\"; document.getElementById(\"footerContainer\").style.display='none'; [].forEach.call(document.querySelectorAll(\".testmode\"), function (el) { el.style.visibility = \"hidden\";}); [].forEach.call(document.querySelectorAll(\".yellowBox clearfix\"), function (el) { el.style.backgroundColor = \"red\";});", width];
    NSString* value1 = [self.webview stringByEvaluatingJavaScriptFromString:scriptTitle];
    NSLog(@"++%@",value1);
    NSString* value = [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"messageStep4\").innerHTML"];
    if (![value isEqualToString: @"" ]) {
        [self saveVoucher];
        ULNavigationController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
        [self presentViewController:swVC animated:YES completion:nil];
    }
//        [_webview setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBackBtn:(id)sender {
    if(_isFromSignup){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        ULNavigationController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
        [self presentViewController:swVC animated:YES completion:nil];
    }
    
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