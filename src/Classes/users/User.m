//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "User.h"

@interface User ()

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * job;
@property (nonatomic, copy) NSString * websiteLink;
@property (nonatomic, copy) NSString * avatarLink;

@end

@implementation User

@synthesize name, job, websiteLink, avatarLink;

+ (id)userWithName:(NSString *)aName job:(NSString *)aJob
    websiteLink:(NSString *)aWebsiteLink avatarLink:(NSString *)anAvatarLink
{
    return
        [[[[self class]
        alloc]
        initWithName:aName job:aJob websiteLink:aWebsiteLink
        avatarLink:anAvatarLink]
        autorelease];
}

- (void)dealloc
{
    self.name = nil;
    self.job = nil;
    self.websiteLink = nil;
    self.avatarLink = nil;

    [super dealloc];
}

- (id)initWithName:(NSString *)aName job:(NSString *)aJob
    websiteLink:(NSString *)aWebsiteLink avatarLink:(NSString *)anAvatarLink
{
    if (self = [super init]) {
        self.name = aName;
        self.job = aJob;
        self.websiteLink = aWebsiteLink;
        self.avatarLink = anAvatarLink;
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"user: '%@', job: '%@', website: '%@', "
        "avatar: '%@'.", self.name, self.job, self.websiteLink,
        self.avatarLink];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

@end
