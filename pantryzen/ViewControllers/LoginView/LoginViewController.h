//
//  LoginViewController.h
//  pantryzen
//
//  Created by admin on 16/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    CGPoint prevPt;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parentTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parentBottomConstraint;

@end
