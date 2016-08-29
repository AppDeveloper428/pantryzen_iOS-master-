		//
//  barcodeViewController.m
//  pantryzen
//
//  Created by My Star on 7/7/16.
//  Copyright © 2016 admin. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "barcodeViewController.h"
#import <ZXingObjC/ZXingObjC.h>
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "JSON.h"
#import "Global.h"
#import "ProductPageViewController.h"
#import "typesearchViewController.h"
#import "SWRevealViewController.h"
#import "ProductListViewController.h"
#import "AppDelegate.h"
#import "Global.h"

@interface barcodeViewController ()


@property (weak, nonatomic) IBOutlet UIView *imageLageContainer;

//@property (strong, nonatomic) IBOutlet UIButton *sidebarButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation barcodeViewController{

    CGAffineTransform _captureSizeTransform;
    BOOL scan_falg;
    NSMutableArray *arrProducts;
    NSString *barcode;
}

#pragma mark - View Controller Methods

- (void)dealloc {
    [self.capture.layer removeFromSuperlayer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrProducts = [NSMutableArray array];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
    
    scan_falg = YES;
    
    self.capture = [[ZXCapture alloc] init];

    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;

    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    [self.view bringSubviewToFront:self.txt_barcode];
    
    
    
    [self.scanRectView setFrame:CGRectMake(30, 105, 260, 260)];
    
    NSLog(@"scale rect = %f,%f", self.scanRectView.frame.origin.x, self.scanRectView.frame.origin.y);
    NSLog(@"scale rect = %f, %f", self.scanRectView.frame.size.width , self.scanRectView.frame.size.height);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.barcode_scan == YES) {
        scan_falg = YES;
    }
    
    self.capture.delegate = self;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.view bringSubviewToFront:self.topView];
    
    [self applyOrientation2];
 
    [AppDelegate sharedInstance].barcodeFlag = NO;
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self applyOrientation2];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self applyOrientation2];
     }];
}
-(void) applyOrientation{
}
#pragma mark - Private
- (void)applyOrientation2 {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    
    [self applyRectOfInterest:orientation];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    
    [self.capture setTransform:transform];
    
    [self.capture setRotation:scanRectRotation];
    
    self.capture.layer.frame = self.view.frame;
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = self.scanRectView.frame;
    if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        
        NSLog(@"sessionPrest = %@", self.capture.sessionPreset);
        
        videoSizeX = 1080;
        videoSizeY = 1920;
    } else {
        
        NSLog(@"sessionPrest = %@", self.capture.sessionPreset);
        videoSizeX = 720;
        videoSizeY = 1280;
    }
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        
        NSLog(@"scalevideowidth = %f", self.view.frame.size.width);
        
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        
        NSLog(@"scalevideoheight = %f", self.view.frame.size.height);
        
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
            
        } else {
            
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
            
        }
    } else {
        
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            
            transformedVideoRect.origin.y = self.view.frame.size.height/2 - self.scanRectView.frame.size.height/2;; //(scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
            
        } else {
            
            transformedVideoRect.origin.x = self.view.frame.size.width/2 - self.scanRectView.frame.size.width/2; //(scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
            
        }
    }
    _captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods
- (void)captureCameraIsReady:(ZXCapture *)capture {
    NSLog(@"capture camera is ready...");
    NSLog((capture!=nil)?@"ok":@"no");
}
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    
    
    if (scan_falg == YES) {
        
        NSLog(@"capture result = ");
        NSLog((result==nil)?@"nothing":@"okay");
        if (!result) return;
        
        CGAffineTransform inverse = CGAffineTransformInvert(_captureSizeTransform);
        NSMutableArray *points = [[NSMutableArray alloc] init];
        NSString *location = @"";
        for (ZXResultPoint *resultPoint in result.resultPoints) {
            CGPoint cgPoint = CGPointMake(resultPoint.x, resultPoint.y);
            CGPoint transformedPoint = CGPointApplyAffineTransform(cgPoint, inverse);
            transformedPoint = [self.scanRectView convertPoint:transformedPoint toView:self.scanRectView.window];
            NSValue* windowPointValue = [NSValue valueWithCGPoint:transformedPoint];
            location = [NSString stringWithFormat:@"%@ (%f, %f)", location, transformedPoint.x, transformedPoint.y];
            [points addObject:windowPointValue];
        }
        
        
        // We got a result. Display information about the result onscreen.
        NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
        
        self.txt_barcode.text = result.text;
        
        barcode = result.text;
        
        NSLog(@"barcode = %@", barcode);
        
        NSString *display = [NSString stringWithFormat:@"barcode scanned!\n\nFormat: %@\n\nContents:\n%@\nLocation: %@", formatString, result.text, location];
        [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
        
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [self.capture stop];
        
        
        //barcode scanning success.
        
        [self searchrequest];
                
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.capture start];
        });

        
    }
    
    scan_falg = NO;
    
   }

-(void) searchrequest{

    [self.navigationController setNavigationBarHidden:NO animated:NO];

    //-------------------send request----------------------
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URL= [NSString stringWithFormat:@"%@%@", SERVICEPATH, @"search_product_barcode"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

//    barcode = @"9330882002689";
    
    [AppDelegate sharedInstance].barcode = barcode;
    
    [manager POST:URL //post URL here
       parameters: @{@"keyword":   barcode}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              NSLog(@"----------------------------true---------------");
              NSLog(@"=============================JSON: %@", responseObject);
              
              arrProducts = [responseObject valueForKey:@"data"];
              
              NSString * responsemessage = [responseObject valueForKey:@"message"];
              
              NSLog(@"responsemessage= %@", responsemessage);
        
              
              if ([responsemessage isEqualToString:@"SUCCESS"]) {
                  
                  [AppDelegate sharedInstance].barcodeFlag = YES;
                  
                  /*
                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                  
                  typesearchViewController *VC = (typesearchViewController*)[storyboard instantiateViewControllerWithIdentifier:@"typesearch"];
                  
                  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                  
                  
                  [self.navigationController pushViewController:VC animated:YES];
                  
                  [self.view sendSubviewToBack:self.imageLageContainer];
                   */
                 
//                  NSString *nameSelected;
//                  
//                  nameSelected = [collectionNames objectAtIndex:[indexPath row]];
                  
                  //    NSLog(@"nameSelected: %@ ...", nameSelected);
                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                  ProductPageViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"ProductPageViewController"];
                  
                  VC.strProductName = [[arrProducts objectAtIndex:0] objectForKey:@"title"];
                  VC.strProductPrice = [NSString stringWithFormat:@"%@%@", @"$", [[arrProducts objectAtIndex:0] objectForKey:@"price"]];
                  //    VC.strProductPrice = [NSString stringWithFormat:@"%@%@%@%@", @"$", [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"price"], @" ", [[arrProducts objectAtIndex:indexPath.row] objectForKey:@"unit"]];
                  VC.arrProducts = arrProducts;
                  //    VC.arrProductPrice = collectionPrices;
                  VC.indexRow = 0;
                  
                  //select catetory_id and product_id
                  
                  VC.product_id = [[arrProducts objectAtIndex:0] objectForKey:@"product_id"];
                  
                  VC.category_id = [[arrProducts objectAtIndex:0] objectForKey:@"category_id"];
                  
                  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                  
                  [self.navigationController pushViewController:VC animated:YES];
                  
              }else{
                  
                  [self.view bringSubviewToFront:self.imageLageContainer];
                  
                  [self.navigationController setNavigationBarHidden:YES animated:NO];
                  
              }
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"CGH Error: %@", error);
              //showing imagelage view when have nothing
              
              NSLog(@"false ========");
              
              [self.view bringSubviewToFront:self.imageLageContainer];
              
              //alert-end
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              return;
          }
     ];
    
    
    //------------------end request---------------------------

    
//    [self.view bringSubviewToFront:self.imageLageContainer];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)btn_search:(id)sender {
    
    scan_falg = YES;
    
    NSString *display = @"Scan a product barcode";
    [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
    
    self.txt_barcode.text = @"";
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.view sendSubviewToBack:self.imageLageContainer];
    
}

- (IBAction)btn_type_search:(id)sender {

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    typesearchViewController *VC = (typesearchViewController*)[storyboard instantiateViewControllerWithIdentifier:@"typesearch"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    [self.navigationController pushViewController:VC animated:YES];
    
    [self.view sendSubviewToBack:self.imageLageContainer];
}


- (IBAction)close:(id)sender {
    
//    [self.revealViewController revealToggleAnimated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
     ProductListViewController *swVC = [storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.navigationController pushViewController:swVC animated:YES];

//    [self.view sendSubviewToBack:self.imageLageContainer];
    
}

- (IBAction)btn_close:(id)sender {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.view sendSubviewToBack:self.imageLageContainer];
}




- (IBAction)btn_click_close:(id)sender {
    
    category_id = 0;
    category_note = @"Hi there";
    category_title = @"WELCOME";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    ProductListViewController *swVC = [storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:swVC animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
