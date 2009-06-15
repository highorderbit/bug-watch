//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"
#import "NewsFeedItem.h"
#import "NewsFeedViewController.h"
#import "NewsFeedItemViewController.h"
#import "NewsFeedDataSource.h"
#import "NetworkAwareViewController.h"
#import "UIAlertView+InstantiationAdditions.h"

@interface NewsFeedDisplayMgr ()

@property (nonatomic, retain) NewsFeedItemViewController *
    newsFeedItemViewController;

@end

@implementation NewsFeedDisplayMgr

@synthesize newsFeedItemViewController;

- (void)dealloc
{
    [newsFeedDataSource release];

    [newsFeedItemViewController release];
    [newsFeedViewController release];

    [networkAwareViewController release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
                  newsFeedDataSource:(NewsFeedDataSource *)dataSource
                   leftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (self = [super init]) {
        networkAwareViewController = [navc retain];
        networkAwareViewController.delegate = self;

        newsFeedViewController =
            [[NewsFeedViewController alloc]
            initWithNibName:@"NewsFeedView" bundle:nil];
        newsFeedViewController.delegate = self;
        networkAwareViewController.targetViewController =
            newsFeedViewController;

        newsFeedDataSource = [dataSource retain];
        newsFeedDataSource.delegate = self;

        UIBarButtonItem * refreshButton =
            [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
            target:self
            action:@selector(userDidRequestRefresh)];
        networkAwareViewController.navigationItem.rightBarButtonItem =
            refreshButton;
        [refreshButton release];

        networkAwareViewController.navigationItem.leftBarButtonItem =
            leftBarButtonItem;
    }

    return self;
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)networkAwareViewWillAppear
{
    NSArray * items = [newsFeedDataSource currentNewsFeed];
    newsFeedViewController.newsItems = items;
    [networkAwareViewController setCachedDataAvailable:!!items];

    BOOL updating = [newsFeedDataSource fetchNewsFeedIfNecessary];
    if (updating)
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    else
        [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

#pragma mark NewsFeedViewControllerDelegate implementation

- (void)userDidSelectNewsItem:(NewsFeedItem *)item
{
    NSLog(@"The user has selected an item: '%@'.", item);
    [self.newsFeedItemViewController updateNewsItem:item];
    [networkAwareViewController.navigationController
        pushViewController:self.newsFeedItemViewController animated:YES];
}

#pragma mark Handling a refresh

- (void)userDidRequestRefresh
{
    [newsFeedDataSource refreshNewsFeed];
    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
}

#pragma mark NewsFeedDataSourceDelegate implementation

- (void)newsFeedUpdated:(NSArray *)newsFeed
{
    NSLog(@"Received news feed: %@.", newsFeed);
    newsFeedViewController.newsItems = newsFeed;

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToUpdateNewsFeed:(NSError *)error
{
    NSLog(@"Failed to update news feed: %@.", error);

    NSString * title =
        NSLocalizedString(@"newsfeed.update.failed.alert.title", @"");
    NSString * message = error.localizedDescription;

    UIAlertView * alertView =
        [UIAlertView simpleAlertViewWithTitle:title message:message];
    [alertView show];

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController
        setCachedDataAvailable:!!newsFeedViewController.newsItems];
}

#pragma mark Accessors

- (NewsFeedItemViewController *)newsFeedItemViewController
{
    if (!newsFeedItemViewController) {
        newsFeedItemViewController =
        [[NewsFeedItemViewController alloc]
        initWithNibName:@"NewsFeedItemView" bundle:nil];
    }

    return newsFeedItemViewController;
}

@end
