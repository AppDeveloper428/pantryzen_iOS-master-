//
//  ProductPageViewController.h
//  pantryzen
//
//  Created by admin on 17/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDigitInput.h"
#import "CustomDatePicker.h"
#import "REFormattedNumberField.h"

@interface PaymentDetailViewController : UIViewController
{
    CHDigitInput *digitInput;
}
@property (nonatomic) BOOL isFromSignup;
@property (nonatomic) NSString *strCCNumber;
@property (nonatomic) NSString *strVoucher;
@property (nonatomic) NSDate *expiry_date;
@end
