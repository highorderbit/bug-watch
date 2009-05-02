//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UIWebView+FileLoadingAdditions.h"

@implementation UIWebView (FileLoadingAdditions)

- (void)loadHtmlRelativeToMainBundle:(NSString *)html
{
    // Loading the bundle path as the baseURL of the web view will
    // enable us to embed CSS or image files into the HTML later if
    // desired without any additional code.
    NSString * path = [[NSBundle mainBundle] bundlePath];
    NSURL * url = [NSURL fileURLWithPath:path];

    [self loadHTMLString:html baseURL:url];
}

@end