//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MilestoneUpdatePublisher : NSObject
{
  @private
    NSMutableDictionary * listeners;
}

+ (id)publisher;
- (id)init;

//
// The selector provided should have the same arguments as:
//   - (void)milestonesReceivedForAllProjects:(NSArray *)milestones
//                              milestoneKeys:(NSArray *)milestoneKeys
//                                projectKeys:(NSArray *)projectKeys;
//
- (void)subscribeForMilestoneUpdatesForAllProjects:(id)target
                                            action:(SEL)action;

- (void)unsubscribeForMilestoneUpdatesForAllProjets:(id)target;

@end
