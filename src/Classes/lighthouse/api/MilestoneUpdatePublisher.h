//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractUpdatePublisher.h"

@interface MilestoneUpdatePublisher : AbstractUpdatePublisher
{
}

//
// The selector provided should have the same arguments as:
//   - (void)milestonesReceivedForAllProjects:(NSArray *)milestones
//                              milestoneKeys:(NSArray *)milestoneKeys
//                                projectKeys:(NSArray *)projectKeys;
//
+ (id)publisherWithListener:(id)listener action:(SEL)action;
- (id)initWithListener:(id)listener action:(SEL)action;

@end
