//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseUrlBuilder.h"

@interface LighthouseUrlBuilder ()

@property (nonatomic, copy) NSString * lighthouseDomain;
@property (nonatomic, copy) NSString * lighthouseScheme;

@end

@implementation LighthouseUrlBuilder

@synthesize lighthouseDomain, lighthouseScheme;

+ (id)builderWithLighthouseDomain:(NSString *)domain scheme:(NSString *)scheme
{
    id obj = [[[self class] alloc] initWithLighthouseDomain:domain
                                                     scheme:scheme];
    return [obj autorelease];
}

- (void)dealloc
{
    self.lighthouseDomain = nil;
    self.lighthouseScheme = nil;
    [super dealloc];
}

- (id)initWithLighthouseDomain:(NSString *)domain scheme:(NSString *)scheme
{
    if (self = [super init]) {
        self.lighthouseDomain = domain;
        self.lighthouseScheme = scheme;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LighthouseUrlBuilder * copy =
        [[LighthouseUrlBuilder allocWithZone:zone]
            initWithLighthouseDomain:lighthouseDomain
                              scheme:lighthouseScheme];
    return copy;
}

- (NSURL *)urlForPath:(NSString *)path
{
    return [self urlForPath:path args:nil];
}

- (NSURL *)urlForPath:(NSString *)path allArgs:(NSArray *)args
{
    NSMutableString * urlString = [lighthouseDomain mutableCopy];

    [urlString
        insertString:[NSString stringWithFormat:@"%@://", lighthouseScheme]
             atIndex:0];
    [urlString appendString:@"/"];
    [urlString appendString:path];

    BOOL name = YES, first = YES;
    for (id arg in args) {
        [urlString
            appendFormat:@"%@%@", name ? first ? @"?" : @"&" : @"=", arg];

        name = !name;
        if (first) first = NO;
    }

    return [NSURL URLWithString:urlString];
}

- (NSURL *)urlForPath:(NSString *)path args:(id)firstArg, ...
{
    NSMutableArray * allArgs = [NSMutableArray array];

    va_list args;
    va_start(args, firstArg);

    for (id arg = firstArg; arg != nil; arg = va_arg(args, id))
        [allArgs addObject:arg];

    va_end(args);

    return [self urlForPath:path allArgs:allArgs];
}

@end
