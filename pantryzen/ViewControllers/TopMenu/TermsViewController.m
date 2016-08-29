#import "TermsViewController.h"

@implementation TermsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    NSString *url = @"https://pantryzen.com/terms.html";
    NSURL *nsURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsURL];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)onCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [_Indicator stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_Indicator stopAnimating];
}

@end
