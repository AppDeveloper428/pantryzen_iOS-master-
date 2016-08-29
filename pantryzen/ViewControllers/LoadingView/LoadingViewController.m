//
//  ViewController.m
//  DIRECT
//
//  Created by admin on 1/18/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "LoadingViewController.h"
#import "MFLFillableTextLoader.h"
#import "TutorialController.h"
//#import "JoinViewController.h"
//#import "PageItemController.h"


@interface LoadingViewController ()

@property (nonatomic, strong) NSArray *contentImages;
//@property (nonatomic, strong) UIPageViewController *pageViewController;

@property MFLFillableTextLoader *loader;
@property (weak) IBOutlet MFLFillableTextLoader *ibLoader;


@end

@implementation LoadingViewController
//@synthesize contentImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    [para setAlignment:NSTextAlignmentCenter];
    NSAttributedString *details = [[NSAttributedString alloc] initWithString:@""
                                                                  attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Franklin Gothic Book" size:18],
                                                                               NSForegroundColorAttributeName : UIColorFromRGB(0x49bd9b),
                                                                               NSParagraphStyleAttributeName : para}];
    
    self.loader = [[MFLFillableTextLoader alloc] initWithString:@"direct."
                                                           font:[UIFont fontWithName:@"StarJedi" size:15]
                                                      alignment:NSTextAlignmentLeft
                                                      withFrame:CGRectMake(0, 0, 320, 400)];
    
    [self.loader setDetailText:details];
    [self.loader setProgressFont:[UIFont fontWithName:@"SW Crawl Body" size:0]];
    [self.loader setStrokeColor:UIColorFromRGB(0xffffff)];
    [self.loader setUnfilledTextColor:UIColorFromRGB(0x49bd9b)];
    
    [self.loader setStrokeWidth:1];
    
    [self.view addSubview:self.loader];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_loader);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_loader]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loader
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.f]];

    [self.loader addConstraint:[NSLayoutConstraint constraintWithItem:self.loader
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:465]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.loader
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:240.0]];

    
    
//    [self.ibLoader setDetailText:details];
//    [self.ibLoader setProgressFont:[UIFont fontWithName:@"SW Crawl Body" size:18]];
//    [self.ibLoader setFillableFont:[UIFont fontWithName:@"StarJedi" size:28]];
//    [self.ibLoader setTextAlignment:NSTextAlignmentCenter];
//    [self.ibLoader setStrokeColor:UIColorFromRGB(0xe5b13a)];
    
    [self updateProgress];
//    [self panLoaderInFromBelow];
    
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)updateProgress
{
    if (self.loader.progress >= 1.0f) {
        [self.loader setProgress:0.0];
        [self goTutorialAction];
        return;
    }
//    NSLog(@"fsdfds");
    [self.loader setProgress:self.loader.progress + ((arc4random() % 10) / 1000.0f)];
    [self.ibLoader setProgress:self.loader.progress];
    
    [self performSelector:@selector(updateProgress) withObject:nil afterDelay:.05];
    
}

//- (void)panLoaderInFromBelow
//{
//    CATransform3D spinBlowInStart = CATransform3DIdentity;
//    spinBlowInStart.m34 = 1.0 / -700;
//    spinBlowInStart = CATransform3DScale(spinBlowInStart, 0.01, 0.01, -1.11);
//    spinBlowInStart = CATransform3DTranslate(spinBlowInStart, 0, 300, 3000);
//    spinBlowInStart = CATransform3DRotate(spinBlowInStart,
//                                          90.0f * M_PI / 155.0f, 1.0f, 0.0f, 0.0f);
//    
//    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath: @"transform"];
//    transformAnimation.fromValue = [NSValue valueWithCATransform3D:spinBlowInStart];
//    transformAnimation.toValue =[NSValue valueWithCATransform3D:CATransform3DIdentity];
//    transformAnimation.duration = 2;
//    [self.loader.layer addAnimation:transformAnimation forKey:@"transform"];
//    [self.loader.layer setZPosition:1000];
//    [self.loader.layer setTransform:CATransform3DIdentity];
//    
//    [self.ibLoader.layer addAnimation:transformAnimation forKey:@"transform"];
//    [self.ibLoader.layer setZPosition:1000];
//    [self.ibLoader.layer setTransform:CATransform3DIdentity];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self blowLoaderOut];
//    });
//}
//
//- (void)blowLoaderOut
//{
//    CATransform3D blowOutTransform = CATransform3DIdentity;
//    blowOutTransform.m34 = 1.0 / -700;
//    blowOutTransform = CATransform3DScale(blowOutTransform, 1, 0.01, 1.0);
//    blowOutTransform = CATransform3DTranslate(blowOutTransform, 0, 300, 3000);
//    blowOutTransform = CATransform3DRotate(blowOutTransform,
//                                           90.0f * M_PI / 155.0f, 1.0f, 0.0f, 0.0f);
//    
//    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath: @"transform"];
//    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    transformAnimation.toValue = [NSValue valueWithCATransform3D:blowOutTransform];
//    transformAnimation.duration = 1;
//    [self.loader.layer addAnimation:transformAnimation forKey:@"transform"];
//    [self.loader.layer setZPosition:1000];
//    [self.ibLoader.layer addAnimation:transformAnimation forKey:@"transform"];
//    [self.ibLoader.layer setZPosition:1000];
//    
//    
//    //Set transform
//    
//    CATransform3D spinBlowInStart = CATransform3DIdentity;
//    spinBlowInStart.m34 = 1.0 / -700;
//    spinBlowInStart = CATransform3DScale(spinBlowInStart, 0.01, 0.01, -1.11);
//    spinBlowInStart = CATransform3DTranslate(spinBlowInStart, 0, 300, 3000);
//    spinBlowInStart = CATransform3DRotate(spinBlowInStart,
//                                          90.0f * M_PI / 155.0f, 1.0f, 0.0f, 0.0f);
//    [self.loader.layer setTransform:spinBlowInStart];
//    [self.ibLoader.layer setTransform:spinBlowInStart];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self panLoaderInFromBelow];
//    });
//}


- (void)goTutorialAction {
//    NSLog(@"sfdsf");
    
    TutorialController *tutorialVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TutorialController"];
//    [self presentViewController:tutorialVC animated:YES completion:nil];
    [self.navigationController pushViewController:tutorialVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
