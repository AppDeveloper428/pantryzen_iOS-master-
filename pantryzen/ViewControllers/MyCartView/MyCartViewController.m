//
//  MyCartViewController.m
//  pantryzen
//
//  Created by admin on 20/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "MyCartViewController.h"
#import "MyCartTableViewCell.h"
#import "AppDelegate.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "ProductPageViewController.h"

@interface MyCartViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@end

@implementation MyCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackIndicatorImage:
     [UIImage imageNamed:@"back_btn.png"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:
     [UIImage imageNamed:@"back_btn.png"]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"separator.png"]]];
    
    self.lblTotalPrice.text = self.strTotalPrice;
    
     
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickProduct:(UIButton *)sender {
    CGPoint center = sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    
    NSString *productName = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:selectedIndexPath.item] objectForKey:@"product_name"];
    
    NSString *productPrice = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:selectedIndexPath.item] objectForKey:@"price"];
    
//    NSString *productQty = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:selectedIndexPath.item] objectForKey:@"qty"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductPageViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"ProductPageViewController"];
    
    VC.strProductName = productName;
    VC.strProductPrice = [NSString stringWithFormat:@"%@%@", @"$", [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:selectedIndexPath.row] objectForKey:@"price"]];

//    VC.strProductPrice = [NSString stringWithFormat:@"%@%@%@%@", @"$", [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:selectedIndexPath.row] objectForKey:@"price"], @" ", [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:selectedIndexPath.row] objectForKey:@"unit"]];
    VC.arrProducts = [AppDelegate sharedInstance].arrMyCart;
    //    VC.arrProductPrice = collectionPrices;
    VC.indexRow = selectedIndexPath.row;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    
    [self.navigationController pushViewController:VC animated:YES];

}

- (void)onClickRemoveBtn:(UIButton *)sender {
    CGPoint center = sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    
    
    
    //-------------------send request----------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"remove_mycart_item"];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [manager POST  :URL //post URL here
        parameters : @{@"cart_id":  [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:selectedIndexPath.row] objectForKey:@"id"],
                       @"customer_id":  [userDefaults objectForKey:@"CustomerID"]}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSLog(@"selected indexpath.ro ========%li", (long)selectedIndexPath.row);
                
                [[AppDelegate sharedInstance].arrMyCart removeObjectAtIndex:selectedIndexPath.row];
                
                [userDefaults setObject:[AppDelegate sharedInstance].arrMyCart forKey:@"cartlist"];
                
                NSMutableArray *count_array = [userDefaults objectForKey:@"cartlist"];
                
                NSLog(@"[AppDelegate sharedInstance].arrMyCart ========== %lu", (unsigned long)count_array.count);
                
                [self.tableView reloadData];
                
                NSLog(@"responseobject========%@", responseObject);
                
                NSString *totalPrice = [[responseObject objectForKey:@"mycart_total_price"] objectForKey:@"totalPrice"];
                
                NSLog(@"totalPrice ====== %@", totalPrice);
                
                
                
                if ([totalPrice isEqual:[NSNull null]]) {
                    
                    self.lblTotalPrice.text = @"";
                    
                } else{
                
                    self.lblTotalPrice.text = totalPrice;
                
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppDelegate sharedInstance].arrMyCart.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCartTableViewCell" forIndexPath:indexPath];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
//    imgView.frame = CGRectMake(0, 103, 480, 10);
//    [cell.contentView addSubview:imgView];
    
    
    NSString *productName = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:indexPath.item] objectForKey:@"product_name"];
    NSString *productPrice = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:indexPath.item] objectForKey:@"price"];
    NSString *productQty = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:indexPath.item] objectForKey:@"qty"];
    
    
//    UIImageView *imgV = (UIImageView *)[self.view viewWithTag:100];
    NSString *str1 = [NSString stringWithFormat:@"%@%@", @"http://m2.pantryzen.com/pub/media/catalog/product/cache/1/small_image/240x300/beff4985b56e3afdbeabfc89641a4582", [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:indexPath.item] objectForKey:@"img"]];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
//    cell.imgProduct.image = [UIImage imageWithData:data];
    [cell.imgProduct sd_setImageWithURL:[NSURL URLWithString:str1]];
    
//    cell.imgProduct.image = [UIImage imageNamed:productName];
    
    
    cell.lblProductName.text = productName;
    cell.lblProductQty.text = productQty;

    cell.lblProductPrice.text = [NSString stringWithFormat:@"%.02f", (float)[productPrice floatValue]*[productQty integerValue]];
    
    [cell.btnDelete addTarget:self action:@selector(onClickRemoveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnProductImage addTarget:self action:@selector(onClickProduct:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnProductName addTarget:self action:@selector(onClickProduct:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [[AppDelegate sharedInstance].arrMyCart removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
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
