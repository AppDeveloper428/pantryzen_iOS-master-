//
//  MyCartTableViewCell.h
//  pantryzen
//
//  Created by admin on 20/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblProductQty;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnProductImage;
@property (weak, nonatomic) IBOutlet UIButton *btnProductName;

@end
