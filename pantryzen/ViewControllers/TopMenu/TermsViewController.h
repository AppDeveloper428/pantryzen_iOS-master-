#import <UIKit/UIKit.h>


@interface TermsViewController : UIViewController <UIWebViewDelegate>
{    
    UIActivityIndicatorView* _Indicator;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
