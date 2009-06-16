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
#import "LighthouseCredentials.h"
#import "CredentialsUpdatePublisher.h"

@interface NewsFeedDisplayMgr ()

@property (nonatomic, retain) NewsFeedItemViewController *
    newsFeedItemViewController;

- (void)addRefreshButtonItem;
- (void)removeRefreshButtonItem;

@end

@implementation NewsFeedDisplayMgr

@synthesize newsFeedItemViewController;

- (void)dealloc
{
    [newsFeedDataSource release];

    [newsFeedItemViewController release];
    [newsFeedViewController release];

    [networkAwareViewController release];

    [credentialsUpdatePublisher release];

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

        networkAwareViewController.navigationItem.leftBarButtonItem =
            leftBarButtonItem;

        credentialsUpdatePublisher =
            [[CredentialsUpdatePublisher alloc]
            initWithListener:self action:@selector(setCredentials:)];

        if ([self credentials]) {
            [self addRefreshButtonItem];
            [networkAwareViewController setNoConnectionText:
                NSLocalizedString(@"nodata.noconnection.text", @"")];
        } else {
            [self removeRefreshButtonItem];
            [networkAwareViewController setNoConnectionText:
                NSLocalizedString(@"loggedout.nodata.text", @"")];
            [networkAwareViewController setCachedDataAvailable:NO];
            [networkAwareViewController setUpdatingState:kDisconnected];
        }
    }

    return self;
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)networkAwareViewWillAppear
{
    if ([self credentials]) {
        NSArray * items = [newsFeedDataSource currentNewsFeed];
        newsFeedViewController.newsItems = items;
        [networkAwareViewController setCachedDataAvailable:!!items];

        BOOL updating = [newsFeedDataSource fetchNewsFeedIfNecessary];
        if (updating)
            [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        else
            [networkAwareViewController
                setUpdatingState:kConnectedAndNotUpdating];
    }
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

- (LighthouseCredentials *)credentials
{
    return [newsFeedDataSource credentials];
}

- (void)setCredentials:(LighthouseCredentials *)credentials
{
    [newsFeedDataSource setCredentials:credentials];

    [networkAwareViewController setCachedDataAvailable:NO];
    if (credentials) {
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"nodata.noconnection.text", @"")];

        [newsFeedDataSource setCredentials:credentials];
        [self userDidRequestRefresh];
        [self addRefreshButtonItem];
    } else {
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
        [networkAwareViewController setNoConnectionText:
            NSLocalizedString(@"loggedout.nodata.text", @"")];
        [self removeRefreshButtonItem];
    }
}

- (NewsFeedItemViewController *)newsFeedItemViewController
{
    if (!newsFeedItemViewController) {
        newsFeedItemViewController =
        [[NewsFeedItemViewController alloc]
        initWithNibName:@"NewsFeedItemView" bundle:nil];
    }

    return newsFeedItemViewController;
}

- (void)addRefreshButtonItem
{
    if (!networkAwareViewController.navigationItem.rightBarButtonItem) {
        UIBarButtonItem * refreshButton =
            [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                 target:self
                                 action:@selector(userDidRequestRefresh)];
        networkAwareViewController.navigationItem.rightBarButtonItem =
            refreshButton;
        [refreshButton release];
    }
}

- (void)removeRefreshButtonItem
{
    networkAwareViewController.navigationItem.rightBarButtonItem = nil;
}

@end
