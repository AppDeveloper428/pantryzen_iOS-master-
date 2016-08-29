//
//  TutorialController.h
//  DIRECT
//
//  Created by admin on 21/01/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *tutorial1View;
@property (weak, nonatomic) IBOutlet UIImageView *tutorial2View;
@property (weak, nonatomic) IBOutlet UIImageView *tutorial3View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTutorial1Leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTutorial2Leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTutorial3Leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTutorial1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTutorial2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTutorial3Width;

@end
