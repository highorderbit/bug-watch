//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UIWebView+FileLoadingAdditions.h"

@implementation UIWebView (FileLoadingAdditions)

- (void)loadHTMLStringRelativeToMainBundle:(NSString *)html
{
    NSString * path = [[NSBundle mainBundle] bundlePath];
    NSURL * url = [NSURL fileURLWithPath:path];

    [self loadHTMLString:html baseURL:url];
}

@end