//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedDataSourceDelegate.h"
#import "NewsFeedViewControllerDelegate.h"
#import "NetworkAwareViewControllerDelegate.h"

@class NewsFeedViewController, NewsFeedItemViewController;
@class NewsFeedDataSource;
@class NetworkAwareViewController;
@class LighthouseCredentials, CredentialsUpdatePublisher;

@interface NewsFeedDisplayMgr :
    NSObject <NewsFeedViewControllerDelegate, NewsFeedDataSourceDelegate,
    NetworkAwareViewControllerDelegate>
{
    NetworkAwareViewController * networkAwareViewController;

    NewsFeedViewController * newsFeedViewController;
    NewsFeedItemViewController * newsFeedItemViewController;

    NewsFeedDataSource * newsFeedDataSource;

    CredentialsUpdatePublisher * credentialsUpdatePublisher;
}

#pragma mark Initialization

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
                  newsFeedDataSource:(NewsFeedDataSource *)dataSource
                   leftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;

#pragma mark Changing user credentials

- (LighthouseCredentials *)credentials;
- (void)setCredentials:(LighthouseCredentials *)credentials;

@end
