//
//  TutorialController.m
//  DIRECT
//
//  Created by admin on 21/01/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "TutorialController.h"
#import "AppDelegate.h"

@interface TutorialController ()

@end

@implementation TutorialController {
    int currentPageIndex;
    NSLayoutConstraint* layoutGroup[3];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    currentPageIndex = 0;
    layoutGroup[0] = self.constraintTutorial1Leading;
    layoutGroup[1] = self.constraintTutorial2Leading;
    layoutGroup[2] = self.constraintTutorial3Leading;

    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.constraintTutorial1Leading.constant = 0;
    self.constraintTutorial2Leading.constant = screenRect.size.width;
    self.constraintTutorial3Leading.constant = screenRect.size.width*2;
    
    self.constraintTutorial1Width.constant = screenRect.size.width;
    self.constraintTutorial2Width.constant = screenRect.size.width;
    self.constraintTutorial3Width.constant = screenRect.size.width;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeRight.numberOfTouchesRequired = 1;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeLeft.numberOfTouchesRequired = 1;
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSwipeRight: (UISwipeGestureRecognizer*) recognizer {
    currentPageIndex--;
    if (currentPageIndex < 0) {
        currentPageIndex = 0;
    }
    [self animatePage];
}

-(void)didSwipeLeft: (UISwipeGestureRecognizer*) recognizer {
    currentPageIndex++;
    if (currentPageIndex > 2) {
        currentPageIndex = 2;
    }
    [self animatePage];
}

-(void) animatePage {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = 0; i < 3; i++) {
            layoutGroup[i].constant = (i-currentPageIndex)*screenRect.size.width;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)onGetStarted:(id)sender {
    
    NSString *customerid = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomerID"];
    
    if (customerid)
    {
        if (![customerid  isEqual: @""]) {
            
            NSMutableArray *totalArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"cartlist"];
            
            [[AppDelegate sharedInstance].arrMyCart addObjectsFromArray:totalArray];
            
            UIViewController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
            
            [self presentViewController:swVC animated:YES completion:nil];
            
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onSignin:(id)sender {
    
    NSString *customerid = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomerID"];
    if (customerid)
    {
        if (![customerid  isEqual: @""]) {
            
            NSMutableArray *totalArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"cartlist"];
            
            [[AppDelegate sharedInstance].arrMyCart addObjectsFromArray:totalArray];
            
            UIViewController *swVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ULNavigationController"];
            
            [self presentViewController:swVC animated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
