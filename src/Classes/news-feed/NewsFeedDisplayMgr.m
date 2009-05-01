//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"
#import "NewsFeedItem.h"
#import "NewsFeedViewController.h"
#import "NewsFeedItemViewController.h"
#import "NewsFeedDataSource.h"
#import "NetworkAwareViewController.h"

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

        //newsFeedViewController = [navc.targetViewController retain];
        //newsFeedViewController.delegate = self;

        newsFeedDataSource = [dataSource retain];
        newsFeedDataSource.delegate = self;
    }

    return self;
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)networkAwareViewWillAppear
{
    NSLog(@"Network aware view will appear called.");

    NSArray * items = [newsFeedDataSource currentNewsFeed];
    newsFeedViewController.newsItems = items;
    [networkAwareViewController setCachedDataAvailable:!!items];

    BOOL updating = [newsFeedDataSource fetchNewsFeedIfNecessary];
    if (updating)
        [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
    else
        [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];

    //[networkAwareViewController updateView];
}

#pragma mark NewsFeedViewControllerDelegate implementation

- (void)viewDidLoad
{
}

- (void)viewWillAppear
{
}

- (void)userDidSelectNewsItem:(NewsFeedItem *)item
{
    NSLog(@"The user has selected an item: '%@'.", item);
    [newsFeedViewController.navigationController
        pushViewController:self.newsFeedItemViewController animated:YES];
}

- (void)userDidRequestRefresh
{
    [newsFeedDataSource refreshNewsFeed];
}

#pragma mark NewsFeedDataSourceDelegate implementation

- (void)newsFeedUpdated:(NSArray *)newsFeed
{
    NSLog(@"Received news feed: %@.", newsFeed);
    newsFeedViewController.newsItems = newsFeed;

    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
    [networkAwareViewController setCachedDataAvailable:YES];
    //[networkAwareViewController updateView];
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
