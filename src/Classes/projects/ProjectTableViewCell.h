//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedRectLabel.h"

@interface ProjectTableViewCell : UITableViewCell
{
    IBOutlet UILabel * projectNameLabel;
    IBOutlet RoundedRectLabel * openTicketsLabel;
}

- (void)setProjectName:(NSString *)projectName;
- (void)setNumOpenTickets:(NSUInteger)numOpenTickets;

@end
