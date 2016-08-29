//
//  MainMenuViewController.m
//  DIRECT
//
//  Created by admin on 27/01/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SWRevealViewController.h"
#import "Global.h"

@interface MainMenuViewController ()


@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitBtn:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)onAisles:(id)sender {
    category_id = 0;
    category_note = @"Hi there";
    category_title = @"WELCOME";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onBaby:(id)sender {
    category_id = 20;
    category_note = @"Pure & simple";
    category_title = @"BABY";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onBaking:(id)sender {
    category_id = 11;
    category_note = @"From the heart";
    category_title = @"BAKING";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onBreakFast:(id)sender {
    category_id = 3;
    category_note = @"Heathy start";
    category_title = @"BREAKFAST";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onCannedFood:(id)sender {
    category_id = 41;
    category_note = @"Lasts long";
    category_title = @"CANNED FOOD";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onCleaners:(id)sender {
    category_id = 9;
    category_note = @"Natural";
    category_title = @"CLEANERS";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onCooking:(id)sender {
    category_id = 42;
    category_note = @"Made with love";
    category_title = @"COOKING";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onDrinks:(id)sender {
    category_id = 43;
    category_note = @"Liquid cleansers";
    category_title = @"DRINKS";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onHealth:(id)sender {
    category_id = 44;
    category_note = @"Your vitals";
    category_title = @"HEALTH";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onHygiene:(id)sender {
    category_id = 45;
    category_note = @"Keep clean";
    category_title = @"HYGIENE";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onSnake:(id)sender {
    category_id = 46;
    category_note = @"Guilt free";
    category_title = @"SNACKS";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"productListView"];
    [[self revealViewController] pushFrontViewController:vc animated:YES];
}

- (IBAction)onScan:(id)sender {
}

@end
