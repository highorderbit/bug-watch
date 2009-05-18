//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewControllerDelegate.h"
#import "MilestoneDetailsDataSourceDelegate.h"

@class MilestoneDetailsDataSource, Milestone;
@class NetworkAwareViewController, TicketsViewController;
@class MilestoneHeaderView;

@interface MilestoneDetailsDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, MilestoneDetailsDataSourceDelegate>
{
    NetworkAwareViewController * networkAwareViewController;
    TicketsViewController * ticketsViewController;
    MilestoneHeaderView * milestoneHeaderView;
    UISegmentedControl * ticketFilterControl;

    MilestoneDetailsDataSource * detailsDataSource;

    Milestone * milestone;
    id milestoneKey;
    id projectKey;

    NSDictionary * tickets;
    NSDictionary * metadata;
    NSDictionary * userIds;
    NSDictionary * creatorIds;
}

#pragma mark Initialization

- (id)initWithMilestoneDetailsDataSource:(MilestoneDetailsDataSource *)ds;

#pragma mark Display milestone details

- (void)displayDetailsForMilestone:(Milestone *)aMilsetone
                  withMilestoneKey:(id)milestoneKey
                        projectKey:(id)projectKey
              navigationController:(UINavigationController *)navController;

@end