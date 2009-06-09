//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UpdateTicketDescription.h"

@interface UpdateTicketDescription ()

@property (nonatomic) BOOL ticketStateSet;

@end

@implementation UpdateTicketDescription

@synthesize title, comment, state, ticketStateSet, assignedUserKey;
@synthesize milestoneKey, tags;

+ (id)description
{
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc
{
    self.title = nil;
    self.comment = nil;

    self.assignedUserKey = nil;
    self.milestoneKey = nil;

    self.tags = nil;

    [super dealloc];
}

- (id)init
{
    if (self = [super init])
        ticketStateSet = NO;

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"new ticket description: '%@', '%@', "
        "'%d', '%@', '%@', '%@'.", self.title, self.comment, self.state,
        self.assignedUserKey, self.milestoneKey, self.tags];
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    UpdateTicketDescription * desc = [[[self class] allocWithZone:zone] init];

    desc.title = self.title;
    desc.comment = self.comment;
    desc.state = self.state;
    desc.ticketStateSet = self.ticketStateSet;
    desc.assignedUserKey = self.assignedUserKey;
    desc.milestoneKey = self.milestoneKey;
    desc.tags = self.tags;

    return desc;
}

#pragma mark Convert to XML

- (NSString *)xmlDescriptionForProject:(id)projectKey
{
    /*
    <ticket>
      <assigned-user-id type="integer"></assigned-user-id>
      <attachments-count type="integer">0</attachments-count>
      <body></body>
      <body-html></body-html>
      <created-at type="datetime"></created-at>
      <creator-id type="integer"></creator-id>
      <milestone-id type="integer"></milestone-id>
      <number type="integer"></number>
      <permalink></permalink>
      <project-id type="integer"></project-id>
      <state></state>
      <title></title>
      <updated-at type="datetime"></updated-at>
      <user-id type="integer"></user-id>
    </ticket>
    */     

    NSAssert(projectKey, @"Project key cannot be nil.");

    NSMutableString * xml = [NSMutableString string];
    [xml appendString:@"<ticket>\n"];

    if (self.title)
        [xml appendFormat:@"    <title>%@</title>\n", self.title];

    if (self.comment)
        [xml appendFormat:@"    <body>%@</body>\n", self.comment];

    if (self.ticketStateSet)
        [xml appendFormat:
            @"    <state>%@</state>\n",
            [TicketMetaData descriptionForState:self.state]];

    if (self.assignedUserKey)
        [xml appendFormat:
            @"    <assigned-user-id type=\"integer\">%@</assigned-user-id>\n",
            self.assignedUserKey];

    if (self.milestoneKey)
        [xml appendFormat:
            @"    <milestone-id type=\"integer\">%@</milestone-id>\n",
            self.milestoneKey];

    if (self.tags)
        [xml appendFormat:@"    <tag>%@</tag>\n", self.tags];

    [xml appendFormat:
        @"    <project-id type=\"integer\">%@</project-id>\n", projectKey];

    [xml appendString:@"</ticket>"];

    return xml;
}

#pragma mark Accessors

- (void)setState:(TicketState)newState
{
    ticketStateSet = YES;
    state = newState;
}

@end
