//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "TicketDetailsViewControllerDelegate.h"
#import "TicketMetaData.h"

@interface TicketDetailsViewController : UITableViewController
{
    IBOutlet UIView * headerView;
    IBOutlet UIView * metaDataView;
    IBOutlet UIImageView * gradientImage;
    IBOutlet UILabel * numberLabel;
    IBOutlet UILabel * stateLabel;
    IBOutlet UILabel * dateLabel;
    IBOutlet UILabel * descriptionLabel;
    IBOutlet UILabel * reportedByLabel;
    IBOutlet UILabel * assignedToLabel;
    IBOutlet UILabel * milestoneLabel;
    IBOutlet UILabel * messageLabel;
    NSObject<TicketDetailsViewControllerDelegate> * delegate;
}

@property (nonatomic, retain)
    NSObject<TicketDetailsViewControllerDelegate> * delegate;

- (void)setTicketNumber:(NSUInteger)aNumber
    ticket:(Ticket *)aTicket metaData:(TicketMetaData *)someMetaData
    reportedBy:(NSString *)reportedBy assignedTo:(NSString *)assignedTo
    milestone:(NSString *)milestone;

@end
