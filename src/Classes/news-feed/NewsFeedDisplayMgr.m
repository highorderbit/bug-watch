//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedDisplayMgr.h"
#import "NewsFeedItem.h"
#import "NewsFeedViewController.h"
#import "NewsFeedItemViewController.h"
#import "NewsFeedDataSource.h"

@interface NewsFeedDisplayMgr (Private)

@property (nonatomic, retain, readonly) NewsFeedItemViewController *
    newsFeedItemViewController;

@end

@implementation NewsFeedDisplayMgr

- (void)dealloc
{
    [newsFeedViewController release];
    [newsFeedItemViewController release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithNewsFeedViewController:(NewsFeedViewController *)controller
                  newsFeedDataSource:(NewsFeedDataSource *)dataSource
{
    if (self = [super init]) {
        newsFeedViewController = [controller retain];
        newsFeedViewController.delegate = self;

        newsFeedDataSource = [dataSource retain];
        newsFeedDataSource.delegate = self;
    }

    return self;
}

#pragma mark NewsFeedViewControllerDelegate implementation

- (void)viewDidLoad
{
    NSArray * items = [newsFeedDataSource currentNewsFeed];
    newsFeedViewController.newsItems = items;
}

- (void)viewWillAppear
{
    [newsFeedDataSource fetchNewsFeedIfNecessary];
}

- (void)userDidSelectNewsItem:(NewsFeedItem *)item
{
    NSLog(@"The user has selected an item: '%@'.", item);
    [newsFeedViewController.navigationController
        pushViewController:[self newsFeedItemViewController] animated:YES];
}

- (void)userDidRequestRefresh
{
    [newsFeedDataSource refreshNewsFeed];
}

#pragma mark NewsFeedDataSourceDelegate implementation

- (void)newsFeedUpdated:(NSArray *)newsFeed
{
    newsFeedViewController.newsItems = newsFeed;
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