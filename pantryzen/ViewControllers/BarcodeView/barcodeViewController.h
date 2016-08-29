//
//  barcodeViewController.h
//  pantryzen
//
//  Created by My Star on 7/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>

@interface barcodeViewController : UIViewController<ZXCaptureDelegate>

@property (nonatomic, strong) ZXCapture *capture;

@property (weak, nonatomic) IBOutlet UIView *scanRectView;

@property (strong, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UILabel *decodedLabel;

@property (weak, nonatomic) IBOutlet UILabel *txt_barcode;

@property (nonatomic) BOOL barcode_scan;

@end
