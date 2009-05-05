//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Milestone;

@protocol MilestonesViewControllerDelegate

- (void)userDidSelectMilestone:(Milestone *)milestone;

@end