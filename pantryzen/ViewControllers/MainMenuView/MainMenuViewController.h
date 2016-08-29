//
//  MainMenuViewController.h
//  DIRECT
//
//  Created by admin on 27/01/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DownPicker.h"
#import "DropDownListView.h"

@interface MainMenuViewController : UIViewController/*<kDropDownListViewDelegate>{
    NSArray *arryList;
    DropDownListView * Dropobj;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPhoto;
*/

/****
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic) DownPicker *picker;
 */
- (IBAction)exitBtn:(id)sender;

@end
