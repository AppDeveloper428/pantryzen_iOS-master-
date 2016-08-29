//
//  FriendsViewController.m
//  DIRECT
//
//  Created by admin on 27/01/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "VegetablesViewController.h"
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

@interface VegetablesViewController ()<UICollectionViewDelegate, UISearchBarDelegate>
{
    NSArray *collectionImages;
    NSArray *collectionNames;
    NSArray *collectionIDs;
    NSArray *collectionPrices;
    NSMutableArray *arrProducts;
}
@property (weak, nonatomic) IBOutlet MIBadgeButton *btnShoppingCart;

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionVw;
@end

@implementation VegetablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Do any additional setup after loading the view.
    
    //-------------------send request----------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"product_list"];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [manager POST:URL //post URL here
       parameters: @{@"category_id":   @"12"
                     }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              //              NSLog(@"----------------------------true---------------");
              //              NSLog(@"=============================JSON: %@", responseObject);
              arrProducts = [responseObject valueForKey:@"data"];
              [self.myCollectionVw reloadData];
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
    
    
    // navigationbar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

    [self.btnShoppingCart setTitle:@"" forState:UIControlStateNormal];
    
    [self.btnShoppingCart setBadgeBackgroundColor:[UIColor colorWithRed:255/255.0 green:221/255.0 blue:54/255.0 alpha:1.0]];
    
    [self.btnShoppingCart setBadgeTextColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0]];
    
    if([AppDelegate sharedInstance].arrMyCart.count>0){
        NSString *badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[AppDelegate sharedInstance].arrMyCart.count];
        [self.btnShoppingCart setBadgeString:badgeValue];
    }
        
    [self.btnShoppingCart setBadgeEdgeInsets:UIEdgeInsetsMake(20, 0, 0, -6)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if([AppDelegate sharedInstance].arrMyCart.count>0){
        NSString *badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[AppDelegate sharedInstance].arrMyCart.count];
        [self.btnShoppingCart setBadgeString:badgeValue];
    }else{
        [self.btnShoppingCart setBadgeString:nil];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//Collection implement part

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger rowCount = arrProducts.count;
//    NSLog(@"nameSelected: %lu ...", (unsigned long)rowCount);
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *identifier = @"Cell";
    
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *img1 = (UIImageView *)[cell viewWithTag:100];
//    [img1.layer setCornerRadius:img1.frame.size.width/2];
    [img1.layer setMasksToBounds:YES];
    
    
    
    NSString *str1 = [NSString stringWithFormat:@"%@%@", BASEURL, [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"img"]];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
//    img1.image = [UIImage imageWithData:data];
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
    VC.strProductPrice = [NSString stringWithFormat:@"%@%@%@%@", @"$", [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"price"], @" ", [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"unit"]];
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
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
- (IBAction)onClickShoppingCartBtn:(id)sender {
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

/*
// header implement part
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:@"1236"];
        headerView.title.text = title;
        NSString *label = [[NSString alloc]initWithFormat:@"FRIEND"];
        headerView.label.text = label;
//        UIImage *headerImage = [UIImage imageNamed:@"nav-logo.png"];
//        headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
