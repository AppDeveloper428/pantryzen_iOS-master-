//
//  typesearchViewController.m
//  pantryzen
//
//  Created by My Star on 7/8/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "typesearchViewController.h"
#import "ProductListViewController.h"
#import "SWRevealViewController.h"
#import "ProductPageViewController.h"
#import "MIBadgeButton.h"
#import "AppDelegate.h"
#import "MyCartViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "Global.h"
#import "UIImageView+WebCache.h"
#import "barcodeViewController.h"

@interface typesearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

{

    NSArray *collectionImages;
    NSArray *collectionNames;
    NSArray *collectionIDs;
    NSArray *collectionPrices;
    NSMutableArray *arrProducts;
    NSString *searchpar;

}
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet MIBadgeButton *btnShoppingCart;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UITextField *txt_search;

@end

@implementation typesearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.navigationController.navigationBar setBackIndicatorImage:
    
    [UIImage imageNamed:@"back_btn.png"]];
    
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:
     [UIImage imageNamed:@"back_btn.png"]];
    
    // navigationbar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        
    
    // Do any additional setup after loading the view.

    
    [self.btnShoppingCart setTitle:@"" forState:UIControlStateNormal];
    
    [self.btnShoppingCart setBadgeBackgroundColor:[UIColor colorWithRed:255/255.0 green:221/255.0 blue:54/255.0 alpha:1.0]];
    
    [self.btnShoppingCart setBadgeTextColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0]];
    
    if([AppDelegate sharedInstance].arrMyCart.count>0){
        
        NSString *badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[AppDelegate sharedInstance].arrMyCart.count];
        [self.btnShoppingCart setBadgeString:badgeValue];
        
    }
    
    [self.btnShoppingCart setBadgeEdgeInsets:UIEdgeInsetsMake(14, 0, 0, 0)];
 
    if ([AppDelegate sharedInstance].barcodeFlag == YES) {
        
        self.viewTop.hidden = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"search_product_barcode"];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        

        NSString *barcode = [AppDelegate sharedInstance].barcode;
        
        [manager POST:URL //post URL here
           parameters: @{@"keyword":   barcode}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [self.navigationController setNavigationBarHidden:NO animated:NO];
                  
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  NSLog(@"----------------------------true---------------");
                  NSLog(@"=============================JSON: %@", responseObject);
                  
                  arrProducts = [responseObject valueForKey:@"data"];
                  
                  [self.CollectionView reloadData];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"CGH Error: %@", error);
                  //showing imagelage view when have nothing
                  
                  NSLog(@"false ========");
                  
                  //alert-end
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  
                  return;
              }
         ];
        

        
        
    }else{
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    
        self.viewTop.alpha = 0;
        self.viewTop.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.viewTop.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    [self.view endEditing:YES];

}

-(void)viewWillAppear:(BOOL)animated{


    if([AppDelegate sharedInstance].arrMyCart.count>0){
        NSString *badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[AppDelegate sharedInstance].arrMyCart.count];
        
                [self.btnShoppingCart setBadgeString:badgeValue];
        
    }else{
        
                [self.btnShoppingCart setBadgeString:nil];
        
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionview layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2 - 10, self.view.frame.size.width/2);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger rowCount = arrProducts.count;
    //    NSLog(@"nameSelected: %lu ...", (unsigned long)rowCount);
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"searchCell";
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    UIImageView *img1 = (UIImageView *)[cell viewWithTag:100];
    
    
    //    [img1.layer setCornerRadius:img1.frame.size.width/2];
    
    
    [img1.layer setMasksToBounds:YES];
    
    
    NSString *str1 = [NSString stringWithFormat:@"%@%@", @"http://m2.pantryzen.com/pub/media/catalog/product/cache/1/small_image/240x300/beff4985b56e3afdbeabfc89641a4582", [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"img"]];
    
    [img1 sd_setImageWithURL:[NSURL URLWithString:str1]];
    
    
    NSString *strImgBG = @"collection_item_bg";
    int randNum = rand() % 4;
    NSString *param = [NSString stringWithFormat:@"%d", randNum];
    
    NSArray *arrStrs = [NSArray arrayWithObjects:strImgBG, param, @".png", nil];
    NSString *strTempBG = [arrStrs componentsJoinedByString:@""];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:strTempBG]];
    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:strTempBG]];
    
    NSString *str2 = [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"title"];
    UILabel *label1 = (UILabel *)[cell viewWithTag:101];
    label1.text = str2;
    
    NSString *strPrice = [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"price"];
    NSString *strUnit = [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"unit"];
    if ([strUnit compare:@"each"] == NSOrderedSame) {
        strUnit = @"";
    }
    NSString *strPriceUnit = [NSString stringWithFormat:@"%@%@%@%@", @"$", strPrice, @" ", strUnit];
    UILabel *label2 = (UILabel *)[cell viewWithTag:102];
    label2.text = strPriceUnit;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    
    NSString *nameSelected;
    
    nameSelected = [collectionNames objectAtIndex:[indexPath row]];
    
    //    NSLog(@"nameSelected: %@ ...", nameSelected);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductPageViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"ProductPageViewController"];
    
    VC.strProductName = [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"title"];
    VC.strProductPrice = [NSString stringWithFormat:@"%@%@", @"$", [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"price"]];
    //    VC.strProductPrice = [NSString stringWithFormat:@"%@%@%@%@", @"$", [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"price"], @" ", [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"unit"]];
    VC.arrProducts = arrProducts;
    //    VC.arrProductPrice = collectionPrices;
    VC.indexRow = indexPath.row;
    
    //select catetory_id and product_id
    
    VC.product_id = [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"product_id"];
    
    VC.category_id = [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"category_id"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:VC animated:YES];
    //    VC.title = nameSelected;
    //    VC.number = indexPath.row;
    //    VC.labels = collectionLabels;
}




- (IBAction)btn_shop:(id)sender {
    
    //-------------------send request----------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"get_mycart_items"];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    NSLog(@"CGH : %@", [userDefaults objectForKey:@"CustomerID"]);
    [manager POST  :URL //post URL here
        parameters : @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"]}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[AppDelegate sharedInstance].arrMyCart removeAllObjects];
                NSMutableArray *totalArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
                [[AppDelegate sharedInstance].arrMyCart addObjectsFromArray:totalArray];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MyCartViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"MyCartViewController"];
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                [self.navigationController pushViewController:VC animated:YES];
                VC.strTotalPrice = [[responseObject objectForKey:@"mycart_total_price"] objectForKey:@"totalPrice"];
                
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


- (IBAction)inClickShoppingCartBtn:(id)sender {
    
    //-------------------send request----------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"get_mycart_items"];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    NSLog(@"CGH : %@", [userDefaults objectForKey:@"CustomerID"]);
    [manager POST  :URL //post URL here
        parameters : @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"]}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[AppDelegate sharedInstance].arrMyCart removeAllObjects];
                NSMutableArray *totalArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
                [[AppDelegate sharedInstance].arrMyCart addObjectsFromArray:totalArray];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MyCartViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"MyCartViewController"];
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                [self.navigationController pushViewController:VC animated:YES];
                VC.strTotalPrice = [[responseObject objectForKey:@"mycart_total_price"] objectForKey:@"totalPrice"];
                
               
                
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

- (IBAction)onClickBtnSearch:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewTop.alpha = 0;
    } completion:^(BOOL finished) {
        self.viewTop.hidden = YES;
    }];
    
    searchpar = self.txt_search.text;
    
//    https://www.pantryzen.com/backend/index.aphp/mobile/Api/search_product
    
        //-------------------send request----------------------
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
        NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"search_product"];
    
    
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    [manager POST  :URL //post URL here
        parameters : @{@"keyword":  searchpar}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                  [MBProgressHUD hideHUDForView:self.view animated:YES];
    
                NSLog(@"----------------------------true---------------");
                
                NSLog(@"=============================JSON: %@", [responseObject valueForKey:@"data"]);
                
                arrProducts = [responseObject valueForKey:@"data"];
                
                [self.CollectionView reloadData];
                
                
                
                NSLog(@"=============================JSON: %@", arrProducts);
    
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

- (IBAction)onClickBtnSearchCancel:(id)sender {
    
    [self.view endEditing:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewTop.alpha = 0;
    } completion:^(BOOL finished) {
        self.viewTop.hidden = YES;
    }];
    
    
    
}
- (IBAction)onClickSearch:(id)sender {
    
    [self.view endEditing:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    searchpar = self.txt_search.text;
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"search_product"];
    
    NSLog(@"url = %@", URL);
    NSLog(@"search parament = %@", searchpar);
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    [manager POST  :URL //post URL here
        parameters : @{@"keyword":  searchpar}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.viewTop.alpha = 0;
                } completion:^(BOOL finished) {
                    self.viewTop.hidden = YES;
                }];
             
                arrProducts = [responseObject valueForKey:@"data"];
                
                [self.CollectionView reloadData];
                
                if ([arrProducts count] == 0) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"No products match that keyword." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                    //alert-end
                    
                    return;
                    
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

- (IBAction)click_shopping:(id)sender {
    
    
    

    
}

- (IBAction)bnt_shopping:(id)sender {
    
    //-------------------send request----------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"get_mycart_items"];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    NSLog(@"CGH : %@", [userDefaults objectForKey:@"CustomerID"]);
    [manager POST  :URL //post URL here
        parameters : @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"]}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[AppDelegate sharedInstance].arrMyCart removeAllObjects];
                NSMutableArray *totalArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
                [[AppDelegate sharedInstance].arrMyCart addObjectsFromArray:totalArray];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MyCartViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"MyCartViewController"];
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                [self.navigationController pushViewController:VC animated:YES];
                VC.strTotalPrice = [[responseObject objectForKey:@"mycart_total_price"] objectForKey:@"totalPrice"];
                
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


- (IBAction)btn_forward:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)btn_search:(id)sender {
    
    self.viewTop.alpha = 0;
    self.viewTop.hidden = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.viewTop.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
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
