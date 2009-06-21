//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "TicketDetailsViewControllerDelegate.h"
#import "TicketMetaData.h"
#import "LighthouseKey.h"

@interface TicketDetailsViewController : UITableViewController
{
    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;
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

    NSDictionary * comments;
    NSDictionary * commentAuthors;
    NSUInteger ticketNumber;
    Ticket * ticket;
    TicketMetaData * metadata;
    LighthouseKey * milestoneKey;
    NSNumber * reportedByKey;
    NSNumber * assignedToKey;
    NSDictionary * userNames;
    NSDictionary * milestoneNames;
}

@property (nonatomic, retain)
    NSObject<TicketDetailsViewControllerDelegate> * delegate;

@property (nonatomic, retain) Ticket * ticket;
@property (nonatomic, retain) TicketMetaData * metadata;
@property (nonatomic, copy) LighthouseKey * milestoneKey;
@property (nonatomic, copy) NSNumber * reportedByKey;
@property (nonatomic, copy) NSNumber * assignedToKey;
@property (nonatomic, copy) NSDictionary * userNames;
@property (nonatomic, copy) NSDictionary * milestoneNames;

- (void)setTicketNumber:(NSUInteger)aNumber
    ticket:(Ticket *)aTicket metaData:(TicketMetaData *)someMetaData
    reportedByKey:(NSNumber *)reportedByKey
    assignedToKey:(NSNumber *)assignedToKey
    milestoneKey:(LighthouseKey *)milestoneKey
    comments:(NSDictionary *)someComments
    commentAuthors:(NSDictionary *)someCommentAuthors
    userNames:(NSDictionary *)userNames
    milestoneNames:(NSDictionary *)milestoneNames;
    
- (IBAction)sendInEmail:(id)sender;
- (IBAction)openInBrowser:(id)sender;

@end
