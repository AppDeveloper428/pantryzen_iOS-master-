#import <UIKit/UIKit.h>


@interface PrivacyViewController : UIViewController <UIWebViewDelegate>
{    
    UIActivityIndicatorView* _Indicator;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
