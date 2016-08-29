//
//  ProductPageViewController.h
//  pantryzen
//
//  Created by admin on 17/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDescription;
@property (nonatomic) NSString *strProductName;
@property (nonatomic) NSString *strProductPrice;
@property (nonatomic) NSArray *arrProducts;
@property (nonatomic) NSArray *arrProductPrice;
@property (nonatomic) NSUInteger indexRow;
@property (nonatomic) NSString *productQty;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnProductDescription;
@property (weak, nonatomic) IBOutlet UIView *descroptionContainer;
@property (weak, nonatomic) IBOutlet UIView *largeProductImageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *largeProductImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseLargeProductImage;
@property (nonatomic) NSString *product_id;
@property (nonatomic) NSString *category_id;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDescriptionContainer;

@end
