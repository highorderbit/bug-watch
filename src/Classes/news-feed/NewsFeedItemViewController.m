//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedItemViewController.h"
#import "NewsFeedItem.h"
#import "RoundedRectLabel.h"
#import "NSDate+StringHelpers.h"
#import "UIWebView+FileLoadingAdditions.h"
#import "UIColor+BugWatchColors.h"
#import "UILabel+DrawingAdditions.h"

@interface NewsFeedItemViewController ()

- (void)updateDisplay;

+ (NSString *)htmlForContent:(NSString *)content;

- (void)positionView:(UIView *)bottomView verticallyBelowView:(UIView *)topView
    padding:(CGFloat)padding;
- (void)positionView:(UIView *)bottomView verticallyBelowView:(UIView *)topView;
- (void)alignBaselineOfView:(UIView *)targetView withView:(UIView *)destView;

- (void)resizeTitle;
- (void)resizeHeaderView;
- (void)resizeBodyView;

+ (void)setBackgroundColor:(UIColor *)color
        ofRoundedRectLabel:(RoundedRectLabel *)label;

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
    [headerGradientView release];

    [newsFeedItem release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    entityTypeLabel.font = [UIFont systemFontOfSize:12.0];
    entityTypeLabel.roundedCornerWidth = 5.0;
    entityTypeLabel.roundedCornerHeight = 5.0;
    bodyView.backgroundColor = [UIColor whiteColor];

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
    //
    // load content
    //

    authorLabel.text = newsFeedItem.author;
    titleLabel.text = newsFeedItem.title;
    timestampLabel.text = [newsFeedItem.published shortDateAndTimeDescription];
    entityTypeLabel.text = newsFeedItem.type;
    [[self class] setBackgroundColor:[UIColor colorForEntity:newsFeedItem.type]
                  ofRoundedRectLabel:entityTypeLabel];

    [bodyView
        loadHTMLStringRelativeToMainBundle:
        [[self class] htmlForContent:newsFeedItem.content]];

    //
    // resize UI elements to fit content
    //

    [self resizeTitle];

    // move the other labels to the correct position relative to the title
    [self positionView:authorLabel verticallyBelowView:titleLabel];
    [self positionView:entityTypeLabel verticallyBelowView:authorLabel];
    [self alignBaselineOfView:timestampLabel withView:entityTypeLabel];

    [self resizeHeaderView];

    [self alignBaselineOfView:headerGradientView withView:headerView];
    [self positionView:dropShadowView verticallyBelowView:headerView padding:0];

    [self resizeBodyView];
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
         "  <body>"
         "    %@"
         "  </body>"
         "</html>",
        content];
}

- (void)positionView:(UIView *)bottomView verticallyBelowView:(UIView *)topView
    padding:(CGFloat)padding
{
    CGRect frame = bottomView.frame;
    frame.origin.y =
        topView.frame.origin.y + topView.frame.size.height + padding;
    bottomView.frame = frame;
}

- (void)positionView:(UIView *)bottomView verticallyBelowView:(UIView *)topView
{
    [self positionView:bottomView verticallyBelowView:topView padding:5.0];
}

- (void)alignBaselineOfView:(UIView *)targetView withView:(UIView *)destView
{
    CGFloat destBottom = destView.frame.origin.y + destView.frame.size.height;

    CGRect frame = targetView.frame;
    frame.origin.y = destBottom - frame.size.height;
    targetView.frame = frame;
}

- (void)resizeTitle
{
    // grow the title label to the appropriate height
    CGFloat titleHeight = [titleLabel heightForString:newsFeedItem.title];
    CGRect titleLabelFrame = titleLabel.frame;
    titleLabelFrame.size.height = titleHeight;
    titleLabel.frame = titleLabelFrame;
}

- (void)resizeHeaderView
{
    CGFloat headerViewSize =
        titleLabel.frame.size.height +
        authorLabel.frame.size.height +
        entityTypeLabel.frame.size.height +
        headerGradientView.frame.size.height +
        21.0;

    CGRect frame = headerView.frame;
    frame.size.height = headerViewSize;
    headerView.frame = frame;
}

- (void)resizeBodyView
{
    CGRect oldBodyFrame = bodyView.frame;
    [self positionView:bodyView verticallyBelowView:headerView padding:0];
    CGRect newBodyFrame = bodyView.frame;
    newBodyFrame.size.height =
        bodyView.frame.size.height +
        (oldBodyFrame.origin.y - bodyView.frame.origin.y);
    bodyView.frame = newBodyFrame;
}

- (void)setViewBackgroundColor:(RoundedRectLabel *)label
                 forEntityType:(NSString *)type
{
    UIColor * color = [UIColor colorForEntity:type];

    const CGFloat * colorComps = CGColorGetComponents(color.CGColor);

    NSLog(@"Setting color to: (%f, %f, %f).", colorComps[0], colorComps[1],
        colorComps[2]);

    label.roundedRectRed = colorComps[0];
    label.roundedRectGreen = colorComps[1];
    label.roundedRectBlue = colorComps[2];

    [label setNeedsDisplay];
}

+ (void)setBackgroundColor:(UIColor *)color
        ofRoundedRectLabel:(RoundedRectLabel *)label
{
    const CGFloat * colorComps = CGColorGetComponents(color.CGColor);

    label.roundedRectRed = colorComps[0];
    label.roundedRectGreen = colorComps[1];
    label.roundedRectBlue = colorComps[2];

    [label setNeedsDisplay];
}

@end
