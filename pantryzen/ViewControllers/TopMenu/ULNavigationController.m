//
//  ULNavigationController.m
//  RBMenuBarDemo
//
//  Created by Roshan Balaji on 6/12/14.
//  Copyright (c) 2014 Uniq Labs. All rights reserved.
//

#import "ULNavigationController.h"
#import "RBMenu.h"
#import "ULFirstViewController.h"
#import "ULSecondViewController.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import "ProductPageViewController.h"
#import "ProductListViewController.h"
#import "SWRevealViewController.h"
#import "PaymentDetailViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "ULNavigationController.h"
#import "CustomDatePicker.h"
#import "Global.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface ULNavigationController ()<MFMailComposeViewControllerDelegate, UITextFieldDelegate>

@property(nonatomic, strong)RBMenu *menu;

@end

@implementation ULNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //creating the menu items
    
    
    RBMenuItem *item = [[RBMenuItem alloc]initMenuItemWithTitle:@"My Account" image:[UIImage imageNamed:@""]  withCompletionHandler:^(BOOL finished){
        
        
        
    }];
//    RBMenuItem *item1 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Payment" image:[UIImage imageNamed:@"payment.png"]  withCompletionHandler:^(BOOL finished){
//        
//        PaymentDetailViewController *caVC = [storyboard instantiateViewControllerWithIdentifier:@"PaymentDetailViewController"];
//        
//        //-------------------send request----------------------
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        
//        NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"get_payment_info"];
//        
//        
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        
//        [manager POST:URL //post URL here
//           parameters: @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"]               }
//              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  [MBProgressHUD hideHUDForView:self.view animated:YES];
//                  
//                  NSLog(@"=============================JSON: %@", responseObject);
//                  if ([[responseObject valueForKey:@"message"]  isEqual: @"SUCCESS"]) {
//                      NSDictionary *paymentInfo = [responseObject valueForKey:@"data"] ;
//                      // Convert string to date object
//                      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//                      [dateFormat setDateFormat:@"yyyy-MM-dd"];
//                      NSDate *expiry_date = [dateFormat dateFromString:[paymentInfo valueForKey:@"expiry"]];
//                      NSLog(@"%@ success: ", expiry_date);
//                      
//                      //                      _customPicker.date = expiry_date;
//                      
//                      caVC.strCCNumber = [paymentInfo valueForKey:@"cc_token"];
//                      caVC.strVoucher = [paymentInfo valueForKey:@"voucher"];
//                      
//                      //                      NSDateComponents *comps = [[NSDateComponents alloc] init];
//                      //                      [comps setDay:28];
//                      //                      [comps setMonth:10];
//                      //                      [comps setYear:2017];
//                      //                      NSDate * expireDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
//                      //                      NSLog(@"%@ cgh:", expireDate);
//                      caVC.expiry_date = expiry_date;
//                      
//                      //                      [caVC.customPicker init];
//                      //                      [_customPicker layoutSubviews];
//                      [self setViewControllers:@[caVC] animated:NO];
//                  }
//                  
//                  
//              }
//              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  NSLog(@"CGH Error: %@", error);
//                  //alert
//                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"request error!" message:@"Sorry, request error!" preferredStyle:UIAlertControllerStyleAlert];
//                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//                  [alertController addAction:ok];
//                  [self presentViewController:alertController animated:YES completion:nil];
//                  //alert-end
//                  [MBProgressHUD hideHUDForView:self.view animated:YES];
//                  return;
//              }
//         ];
//        //------------------end request---------------------------
//        
//        
//    }];
    /*
     RBMenuItem *item2 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Delivery Address" image:[UIImage imageNamed:@"address.png"] withCompletionHandler:^(BOOL finished){
     
     
     }];
     RBMenuItem *item3 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Email Address" image:[UIImage imageNamed:@"email.png"] withCompletionHandler:^(BOOL finished){
     
     
     }];
     RBMenuItem *item4 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Help" image:[UIImage imageNamed:@"help.png"] withCompletionHandler:^(BOOL finished){
     
     
     }];
     */
    
    RBMenuItem *item2 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Terms" image:[UIImage imageNamed:@"terms.png"] withCompletionHandler:^(BOOL finished){
        
        UIViewController *termsVC = [storyboard instantiateViewControllerWithIdentifier:@"termsVC"];
        [self presentViewController:termsVC animated:YES completion:nil];
        
    }];
    
    RBMenuItem *item3 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Privacy" image:[UIImage imageNamed:@"privacy.png"] withCompletionHandler:^(BOOL finished){
        
        UIViewController *privacyVC = [storyboard instantiateViewControllerWithIdentifier:@"privacyVC"];
        [self presentViewController:privacyVC animated:YES completion:nil];
        
    }];
    
    RBMenuItem *item4 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Help" image:[UIImage imageNamed:@"help.png"] withCompletionHandler:^(BOOL finished){
        
        [[ZDKConfig instance]
         initializeWithAppId:@"2cfbb21350f6f417e75e85400c326137496ef3da7aa888ca"
         zendeskUrl:@"https://pantryzen.zendesk.com"
         clientId:@"mobile_sdk_client_55319fa1703e00e7f6be"];
        ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
        [ZDKConfig instance].userIdentity = identity;
        [ZDKLogger enable:YES];
        [ZDKHelpCenter presentHelpCenterWithViewController:self];
        
    }];
    
    RBMenuItem *item5 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Give us feedback" image:[UIImage imageNamed:@"feedback.png"] withCompletionHandler:^(BOOL finished){
        
        if ([MFMailComposeViewController canSendMail])
        {
            NSString *emailTitle = @"Pantry Zen Feedback";
            NSString *messageBody = @"";
            
            
            NSString *email = @"contact@pantryzen.com";
            NSArray *toRecipents = [NSArray arrayWithObject:email];
            
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
            
            // Determine the file name and extension
            /* PDF file creation ...
             
             */
            
            //            // Add attachment
            //            [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
            
            
        }else{
            
            UIAlertController *alert_emailResult = [UIAlertController
                                                    alertControllerWithTitle:@"Failure!"
                                                    message:@"Your device doesn't support the composer sheet"
                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     [alert_emailResult dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert_emailResult addAction:ok];
            
            [self presentViewController:alert_emailResult animated:YES completion:nil];
            
        }
        
        
    }];
    
    RBMenuItem *item6 = [[RBMenuItem alloc]initMenuItemWithTitle:@"Logout" image:[UIImage imageNamed:@"logout.png"] withCompletionHandler:^(BOOL finished){
        
        //        CheckAddressViewController *caVC = [storyboard instantiateViewControllerWithIdentifier:@"CheckAddressViewController"];
        //        [self setViewControllers:@[caVC] animated:NO];
        //        exit(0);
        
        [AppDelegate sharedInstance].arrMyCart = [NSMutableArray array];
        
        [AppDelegate sharedInstance].loginFlag = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CustomerID"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIViewController *loninVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UIViewController* tutorialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialController"];
        [self presentViewController:loninVC animated:YES completion:nil];
        [loninVC presentViewController:tutorialVC animated:NO completion:nil];
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    _menu = [[RBMenu alloc] initWithItems:@[item,/* item1,*/ item2, item3, item4, item5, item6] textColor:[UIColor colorWithRed:184/255.0 green:222/255.0 blue:176/255.0 alpha:1.0] hightLightTextColor:[UIColor colorWithRed:184/255.0 green:222/255.0 blue:176/255.0 alpha:1.0] backgroundColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0] andTextAlignment:RBMenuTextAlignmentLeft forViewController:self];
    


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppDelegate sharedInstance].ulnavigationFlag = YES;
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu{
    
    [_menu showMenu];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
