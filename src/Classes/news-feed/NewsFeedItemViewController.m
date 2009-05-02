//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedItemViewController.h"
#import "NewsFeedItem.h"
#import "NSDate+StringHelpers.h"
#import "UIWebView+FileLoadingAdditions.h"

@interface NewsFeedItemViewController ()

- (void)updateDisplay;

+ (NSString *)htmlForContent:(NSString *)content;

@property (nonatomic, copy) NewsFeedItem * newsFeedItem;

@end

@implementation NewsFeedItemViewController

@synthesize newsFeedItem;

- (void)dealloc
{
    [headerView release];
    [dropShadowView release];
    [bodyView release];

    [authorLabel release];
    [titleLabel release];
    [entityTypeLabel release];
    [timestampLabel release];

    [newsFeedItem release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title =
        NSLocalizedString(@"newsfeeditem.view.title", @"");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateDisplay];
}

- (void)updateNewsItem:(NewsFeedItem *)item
{
    self.newsFeedItem = item;

    [self updateDisplay];
}

- (void)updateDisplay
{
    authorLabel.text = newsFeedItem.author;
    titleLabel.text = newsFeedItem.title;
    timestampLabel.text = [newsFeedItem.published shortDateAndTimeDescription];
    entityTypeLabel.text = newsFeedItem.type;

    [bodyView
        loadHtmlRelativeToMainBundle:
        [[self class] htmlForContent:newsFeedItem.content]];
}

#pragma mark UIWebViewDelegate implementation

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL * url = [request URL];
        [[UIApplication sharedApplication] openURL:url];

        return NO;
    }

    return YES;
}

+ (NSString *)htmlForContent:(NSString *)content
{
    return
        [NSString stringWithFormat:
        @"<html>"
         "  <head>"
         "   <style media=\"screen\" type=\"text/css\" rel=\"stylesheet\">"
         "     @import url(news-feed-item-style.css);"
         "   </style>"
         "  </head>"
            // margin-top is the height of the header view * 3
         "  <body style=\"margin-top: 330px; margin-bottom: 475px;\">"
         "    %@"
         "  </body>"
         "</html>",
        content];
}

@end
