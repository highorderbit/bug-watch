//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewTicketDescription.h"

@implementation NewTicketDescription

@synthesize title, body, state, assignedUserKey, milestoneKey, tags;

+ (id)description
{
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc
{
    self.title = nil;
    self.body = nil;

    self.assignedUserKey = nil;
    self.milestoneKey = nil;

    self.tags = nil;

    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.title = @"";
        self.body = @"";
        self.state = kNew;

        self.assignedUserKey = @"";
        self.milestoneKey = @"";

        self.tags = @"";
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"new ticket description: '%@', '%@', "
        "'%d', '%@', '%@', '%@'.", self.title, self.body, self.state,
        self.assignedUserKey, self.milestoneKey, self.tags];
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    NewTicketDescription * desc = [[[self class] allocWithZone:zone] init];

    desc.title = self.title;
    desc.body = self.body;
    desc.state = self.state;
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

    return
        [NSString stringWithFormat:
        @"<ticket>\n"
        @"    <assigned-user-id type=\"integer\">%@</assigned-user-id>\n"
        @"    <attachments-count type=\"integer\">0</attachments-count>\n"
        @"    <body>%@</body>\n"
        @"    <body-html></body-html>\n"
        @"    <created-at type=\"datetime\"></created-at>\n"
        @"    <creator-id type=\"integer\"></creator-id>\n"
        @"    <milestone-id type=\"integer\">%@</milestone-id>\n"
        @"    <number type=\"integer\"></number>\n"
        @"    <permalink></permalink>\n"
        @"    <project-id type=\"integer\">%@</project-id>\n"
        @"    <state>%@</state>\n"
        @"    <title>%@</title>\n"
        @"    <updated-at type=\"datetime\"></updated-at>\n"
        @"    <user-id type=\"integer\"></user-id>\n"
        @"    <tag>%@</tag>\n"
        @"</ticket>",
        self.assignedUserKey,
        self.body,
        self.milestoneKey,
        projectKey ? projectKey : @"",
        [TicketMetaData descriptionForState:self.state],
        self.title,
        self.tags];
}

@end
