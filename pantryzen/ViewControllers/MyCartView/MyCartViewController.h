//
//  MyCartViewController.h
//  pantryzen
//
//  Created by admin on 20/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak) NSString *strTotalPrice;
@end
