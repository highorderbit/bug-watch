//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "Project.h"

@interface Project ()

@property (nonatomic, copy) NSString * name;

@end

@implementation Project

@synthesize name;

+ (id)projectWithName:(NSString *)aName
{
    return [[[[self class] alloc] initWithName:aName] autorelease];
}

- (void)dealloc
{
    self.name = nil;

    [super dealloc];
}

- (id)initWithName:(NSString *)aName
{
    if (self = [super init])
        self.name = aName;

    return self;
}

- (NSString *)description
{
    return self.name;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

@end
