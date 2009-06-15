//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiParser.h"

@interface BugWatchObjectBuilder : NSObject
{
    LighthouseApiParser * parser;
}

#pragma mark Instantiation and initialization

+ (id)builderWithParser:(LighthouseApiParser *)aParser;
- (id)initWithParser:(LighthouseApiParser *)aParser;

#pragma mark Building objects

- (NSArray *)parseErrors:(NSData *)xml;

- (NSArray *)parseTickets:(NSData *)xml;
- (NSArray *)parseTicketMetaData:(NSData *)xml;
- (NSArray *)parseTicketNumbers:(NSData *)xml;
- (NSArray *)parseTicketUrls:(NSData *)xml;
- (NSArray *)parseTicketMilestoneIds:(NSData *)xml;
- (NSArray *)parseTicketProjectIds:(NSData *)xml;
- (NSArray *)parseTicketComments:(NSData *)xml;
- (NSArray *)parseTicketCommentAuthors:(NSData *)xml;
- (NSArray *)parseTicketUserKeys:(NSData *)xml;
- (NSArray *)parseTicketCreatorKeys:(NSData *)xml;

- (NSArray *)parseUsers:(NSData *)xml;
- (NSArray *)parseUserKeys:(NSData *)xml;

- (NSArray *)parseProjects:(NSData *)xml;
- (NSArray *)parseProjectKeys:(NSData *)xml;

- (NSArray *)parseMilestones:(NSData *)xml;
- (NSArray *)parseMilestoneIds:(NSData *)xml;
- (NSArray *)parseMilestoneProjectIds:(NSData *)xml;

- (NSArray *)parseMessages:(NSData *)xml;
- (NSArray *)parseMessageKeys:(NSData *)xml;
- (NSArray *)parseMessageAuthorKeys:(NSData *)xml;
- (NSArray *)parseMessageCommentKeys:(NSData *)xml;
- (NSArray *)parseMessageComments:(NSData *)xml;
- (NSArray *)parseMessageCommentAuthorIds:(NSData *)xml;

- (NSArray *)parseTicketBins:(NSData *)xml;

@end
