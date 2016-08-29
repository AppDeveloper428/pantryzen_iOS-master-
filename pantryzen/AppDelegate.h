//
//  AppDelegate.h
//  pantryzen
//
//  Created by admin on 14/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) NSString   *username;
@property (weak, nonatomic) ProductItem *productItem;
@property (strong, nonatomic) NSMutableArray *arrMyCart;
@property (strong, nonatomic) NSDictionary   *_tmpDic;

@property BOOL loginFlag;
@property BOOL createFlag;
@property BOOL barcodeFlag;
@property NSString *barcode;
@property BOOL ulnavigationFlag;

+(AppDelegate *)sharedInstance;

@end

