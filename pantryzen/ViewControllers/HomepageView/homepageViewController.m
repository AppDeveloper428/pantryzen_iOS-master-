//
//  homepageViewController.m
//  pantryzen
//
//  Created by My Star on 7/16/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "homepageViewController.h"

@interface homepageViewController () <UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation homepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_Indicator == nil) {
        _Indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _Indicator.frame = CGRectMake(0, 0, 100, 100);
        _Indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
        _Indicator.color = [UIColor colorWithRed:223.0/256.0 green:182.0/256.0 blue:0 alpha:1];
        _Indicator.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
        [self.view addSubview:_Indicator];
        [_Indicator bringSubviewToFront:self.view];
    }
    
    [_Indicator startAnimating];
    NSString *url = @"https://pantryzen.com";
    NSURL *nsURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsURL];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [_Indicator stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_Indicator stopAnimating];
}

@end
