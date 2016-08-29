//
//  scanViewController.m
//  pantryzen
//
//  Created by My Star on 7/21/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "scanViewController.h"
#import "SWRevealViewController.h"
#import "typesearchViewController.h"

@interface scanViewController ()

@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // navigationbar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.navigationController.navigationBar setBackIndicatorImage:
     [UIImage imageNamed:@"back_btn.png"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:
     [UIImage imageNamed:@"back_btn.png"]];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_close:(id)sender {
    
//    [self.revealViewController revealToggleAnimated:YES];
    
    SWRevealViewController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self.navigationController pushViewController:swVC animated:YES];
}
- (IBAction)btn_type_search:(id)sender {
    
            
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        typesearchViewController *VC = (typesearchViewController*)[storyboard instantiateViewControllerWithIdentifier:@"typesearch"];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        
        [self.navigationController pushViewController:VC animated:YES];
        //
        
        
    
    
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
