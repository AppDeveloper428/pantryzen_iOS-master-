//
//  ProductPageViewController.m
//  pantryzen
//
//  Created by admin on 17/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ProductPageViewController.h"
#import "MIBadgeButton.h"
#import "AppDelegate.h"
#import "MyCartViewController.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"

@interface ProductPageViewController (){

    NSMutableArray *img_array_address;
    
    NSInteger index;


}
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet MIBadgeButton *btnShoppingCart;
@property (strong, nonatomic) IBOutlet UIButton *btn_next;

@property (strong, nonatomic) IBOutlet UIButton *btn_prev;


@end

@implementation ProductPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    img_array_address = [NSMutableArray array];
    
    [self.btn_next setHidden:YES];
    [self.btn_prev setHidden:YES];
    
    index = 0;
    
    NSLog(@"products_id = %@", self.product_id);
    
    NSLog(@"category_id = %@", self.category_id);
    
    //parse backend api by using category_id and product_id
    
    
    if ([self.category_id  isEqualToString:@"8"] && [self.product_id isEqualToString:@"13"]
        ) {
        
        [self.btn_next setHidden:NO];
        [self.btn_prev setHidden:NO];

        NSString *str1 = [NSString stringWithFormat:@"%@%@", @"http://m2.pantryzen.com/pub/media/catalog/product/cache/1/small_image/240x300/beff4985b56e3afdbeabfc89641a4582", [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"img"]];
//        NSString *str1 = [NSString stringWithFormat:@"%@%@", BASEURL, [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"img"]];
        
        NSString *str2 = @"http://m2.pantryzen.com/pub/media/catalog/product/cache/1/image/e9c3970ab036de70892d86c6d221abfe/m/o/mountain-bread-spelt-wraps-nutrition-table.jpg";
        
        [img_array_address addObject:str1];
        [img_array_address addObject:str2];
        
    }
    
    self.lblProductName.text = [[self.arrProducts objectAtIndex:self.indexRow]objectForKey:@"title"];
    
    if (self.lblProductName.text == nil && self.lblProductName.text.length == 0) {
        self.lblProductName.text = self.strProductName;
    }
    
    self.lblProductPrice.text = self.strProductPrice;
    NSLog(@"%@", self.arrProducts);
    NSString *str1 = [NSString stringWithFormat:@"%@%@", @"http://m2.pantryzen.com/pub/media/catalog/product/cache/1/small_image/240x300/beff4985b56e3afdbeabfc89641a4582", [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"img"]];
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
//    NSString *str1 = [NSString stringWithFormat:@"%@%@", BASEURL, [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"img"]];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
//    self.imgProduct.image = [UIImage imageWithData:data];
    [self.imgProduct sd_setImageWithURL:[NSURL URLWithString:str1]];
    
    self.lblProductDescription.text = [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"description"];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.navigationController.navigationBar setBackIndicatorImage:
     [UIImage imageNamed:@"back_btn.png"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:
     [UIImage imageNamed:@"back_btn.png"]];
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(yourOtherMethod:)];
//    UIButton *myButton = (UIButton *)[self.view viewWithTag:101];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
//    self.navigationItem.rightBarButtonItem = self.btnShoppingCart;
    
    self.btn1.layer.cornerRadius = 9;
    self.btn1.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.btn1 setTitle:@"1" forState:UIControlStateNormal];
    
    self.btn2.layer.cornerRadius = 9;
    self.btn2.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.btn2 setTitle:@"2" forState:UIControlStateNormal];
    
    self.btn3.layer.cornerRadius = 9;
    self.btn3.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.btn3 setTitle:@"3" forState:UIControlStateNormal];
    
    self.productQty = @"1";
    
    
    [self.btnShoppingCart setTitle:@"" forState:UIControlStateNormal];
    [self.btnShoppingCart setBadgeBackgroundColor:[UIColor colorWithRed:255/255.0 green:221/255.0 blue:54/255.0 alpha:1.0]];
    [self.btnShoppingCart setBadgeTextColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0]];
    if([AppDelegate sharedInstance].arrMyCart.count>0){
        NSString *badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[AppDelegate sharedInstance].arrMyCart.count];
        [self.btnShoppingCart setBadgeString:badgeValue];
    }
    [self.btnShoppingCart setBadgeEdgeInsets:UIEdgeInsetsMake(14, 0, 0, 0)];
    
    
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
//    if([AppDelegate sharedInstance].arrMyCart.count>0){
//        NSString *badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[AppDelegate sharedInstance].arrMyCart.count];
//        [self.btnShoppingCart setBadgeString:badgeValue];
//    }else{
//        [self.btnShoppingCart setBadgeString:nil];
//    }
    
}

- (IBAction)clickBtn1:(id)sender {
    [self.btn1 setTitleColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn1 setBackgroundColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0]];
    [self.btn2 setTitleColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn2 setBackgroundColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0]];
    [self.btn3 setTitleColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn3 setBackgroundColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0]];
    self.productQty = @"1";
}
- (IBAction)clickBtn2:(id)sender {
    [self.btn2 setTitleColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn2 setBackgroundColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0]];
    [self.btn1 setTitleColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn1 setBackgroundColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0]];
    [self.btn3 setTitleColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn3 setBackgroundColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0]];
    self.productQty = @"2";
}
- (IBAction)clickBtn3:(id)sender {
    [self.btn3 setTitleColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn3 setBackgroundColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0]];
    [self.btn2 setTitleColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn2 setBackgroundColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0]];
    [self.btn1 setTitleColor:[UIColor colorWithRed:71/255.0 green:154/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.btn1 setBackgroundColor:[UIColor colorWithRed:238/255.0 green:234/255.0 blue:187/255.0 alpha:1.0]];
    self.productQty = @"3";
}

- (IBAction)onClickAddToOrderBtn:(id)sender {
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* description = [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"description"];
    if (description == nil) {
        description = @"";
    }
    NSDictionary *obj = @{   @"customer_id":  [userDefaults objectForKey:@"CustomerID"],
                             @"product_id": [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"product_id"],
                             @"description": description,
                             @"qty": self.productQty,
                             @"price": [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"price"],
                             @"is_active": @1

                        };
    
    // add into selected array
        [appdelegate.arrMyCart addObject:obj];
    

    //-------------------send request----------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"add_cartlist"];
    
    
//        NSLog([[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"product_id"]);
//    NSLog([[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"price"]);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSLog([[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"price"]);
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSLog(@"CGH : %@", [userDefaults objectForKey:@"CustomerID"]);
    
    if (appdelegate.barcodeFlag == YES) {
        self.indexRow = 0;
    }
    
    [manager POST:URL //post URL here
       parameters: @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"],
                     @"product_id": [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"product_id"],
//                     @"product_id": @"10",
                     @"description": description,
                     @"qty": self.productQty,
                     @"price": [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"price"],
                     @"is_active": @1
                     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
              
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
 
    // perform add to cart animation
        [self addToCartTapped];
   
}

- (void)addToCartTapped {

    // grab the imageview

    UIImageView *imgV = (UIImageView *)[self.view viewWithTag:100];

    // get the exact location of image
    CGRect rect = [imgV.superview convertRect:imgV.frame fromView:nil];
    rect = CGRectMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2, imgV.frame.size.width, imgV.frame.size.height);
//    NSLog(@"rect is %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    // create new duplicate image
    UIImageView *starView = [[UIImageView alloc] initWithImage:imgV.image];
    starView.contentMode = UIViewContentModeScaleAspectFit;
    [starView setFrame:rect];
    starView.layer.cornerRadius=5;
    starView.layer.borderColor=[[UIColor blackColor]CGColor];
    starView.layer.borderWidth=0;
    [self.view addSubview:starView];

    // begin ---- apply position animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration=0.65;
    pathAnimation.delegate=self;
    
    // tab-bar right side item frame-point = end point
    UIButton *myButton = (UIButton *)[self.view viewWithTag:101];
    
    CGPoint endPoint = CGPointMake(myButton.frame.origin.x+myButton.frame.size.width/2, myButton.frame.origin.y+myButton.frame.size.height/2);
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, starView.frame.origin.x, starView.frame.origin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, starView.frame.origin.y, endPoint.x, starView.frame.origin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    // end ---- apply position animation
    
    // apply transform animation
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"transform"];
    [basic setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.25, 0.25, 0.25)]];
    [basic setAutoreverses:NO];
    [basic setDuration:0.7];
    
    [starView.layer addAnimation:pathAnimation forKey:@"curveAnimation"];
    [starView.layer addAnimation:basic forKey:@"transform"];
    
    [starView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.65];
    [self performSelector:@selector(reloadBadgeNumber) withObject:nil afterDelay:0.65];
    
}

// update the Badge number
- (void)reloadBadgeNumber {
    
//    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[AppDelegate sharedInstance].arrMyCart.count];
    [self.btnShoppingCart setBadgeString:badgeValue];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickPrevBtn:(id)sender {
    
    index--;
    
    if (index < 0) {
        
        index = img_array_address.count - 1;
        
    }
    
    NSString *str1 = [img_array_address objectAtIndex:index];
    
    [self.imgProduct sd_setImageWithURL:[NSURL URLWithString:str1]];
    
    /*
    if(self.indexRow>0){

        self.lblProductName.text = [[self.arrProducts objectAtIndex:--self.indexRow] objectForKey:@"title"];
        self.lblProductPrice.text = [NSString stringWithFormat:@"%@%@%@%@", @"$", [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"price"], @" ", [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"unit"]];
        NSString *str1 = [NSString stringWithFormat:@"%@%@", BASEURL, [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"img"]];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
//        self.imgProduct.image = [UIImage imageWithData:data];
        [self.imgProduct sd_setImageWithURL:[NSURL URLWithString:str1]];
        
        self.lblProductDescription.text = [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"description"];
    }
     */
}
- (IBAction)onClickNextBtn:(id)sender {
    
    index++;
    
    if (index > img_array_address.count - 1) {
        
        index = 0;
        
    }
    
    NSString *str1 = [img_array_address objectAtIndex:index];
    
    [self.imgProduct sd_setImageWithURL:[NSURL URLWithString:str1]];
    
    /*
    if(self.indexRow < self.arrProducts.count-1){

        self.lblProductName.text = [[self.arrProducts objectAtIndex:++self.indexRow] objectForKey:@"title"];
        self.lblProductPrice.text = [NSString stringWithFormat:@"%@%@%@%@", @"$", [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"price"], @" ", [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"unit"]];
        NSString *str1 = [NSString stringWithFormat:@"%@%@", BASEURL, [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"img"]];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str1]];
//        self.imgProduct.image = [UIImage imageWithData:data];
        [self.imgProduct sd_setImageWithURL:[NSURL URLWithString:str1]];
        
        self.lblProductDescription.text = [[self.arrProducts objectAtIndex:self.indexRow] objectForKey:@"description"];
    }
     
     */
}

- (IBAction)onProductDescription:(id)sender {
    
    NSDictionary *userAttributes = @{NSFontAttributeName: self.lblProductDescription.font, NSForegroundColorAttributeName: [UIColor blackColor]};
    CGSize textSize = [self.lblProductDescription.text sizeWithAttributes:userAttributes];
    int lineCount = textSize.width/self.lblProductDescription.frame.size.width/18.64*textSize.height;
    lineCount+=2;
    if (lineCount <= 3) {
        return;
    }
    
    if (self.lblProductDescription.numberOfLines == 3) {
        self.lblProductDescription.numberOfLines = lineCount;
    } else {
        self.lblProductDescription.numberOfLines = 3;
    }
    
    CGRect descriptionFrame = self.descroptionContainer.frame;
    CGRect containerFrame = self.buttonContainer.frame;
    
    self.constraintDescriptionContainer.constant = 18.64*(self.lblProductDescription.numberOfLines-3);

    if (self.lblProductDescription.numberOfLines == 3) {
        self.constraintDescriptionContainer.constant = 0;
    }
    float aaa = self.constraintDescriptionContainer.constant;
    if (descriptionFrame.origin.y + self.constraintDescriptionContainer.constant > self.view.frame.size.height - containerFrame.size.height - 18.64*3) {
        self.constraintDescriptionContainer.constant = self.view.frame.size.height - descriptionFrame.origin.y - containerFrame.size.height - 18.64*3;
    }
}

- (IBAction)onClickBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onClickShoppingCartBtn:(id)sender {
    //-------------------send request----------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"get_mycart_items"];
    
    NSLog(URL);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //    NSLog(@"CGH : %@", [userDefaults objectForKey:@"CustomerID"]);
    
    NSLog(@"custom_id = %@", [userDefaults objectForKey:@"CustomerID"]);
    
    [manager POST  :URL //post URL here
        parameters : @{@"customer_id":  [userDefaults objectForKey:@"CustomerID"]}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [[AppDelegate sharedInstance].arrMyCart removeAllObjects];
                
                NSMutableArray *totalArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
                
                [[AppDelegate sharedInstance].arrMyCart addObjectsFromArray:totalArray];
                
                [userDefaults setObject:[AppDelegate sharedInstance].arrMyCart forKey:@"cartlist"];
                
                NSMutableArray *count_array = [userDefaults objectForKey:@"cartlist"];
                
                NSLog(@"[AppDelegate sharedInstance].arrMyCart ========== %lu", (unsigned long)count_array.count);
                
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

- (IBAction)onShowLargeProdcutImagePage:(id)sender {
    if (self.imgProduct.image != nil) {
        self.largeProductImageView.image = self.imgProduct.image;
        self.largeProductImageContainer.hidden = NO;
    }
}

- (IBAction)onCloseLargeProductImagePage:(id)sender {
    self.largeProductImageContainer.hidden = YES;
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