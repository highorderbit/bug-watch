//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LighthouseApiParser;

@interface BugWatchObjectBuilder : NSObject
{
    LighthouseApiParser * parser;
}

#pragma mark Instantiation and initialization

+ (id)builderWithParser:(LighthouseApiParser *)aParser;
- (id)initWithParser:(LighthouseApiParser *)aParser;

#pragma mark Building objects

- (NSArray *)parseErrors:(NSData *)xml;
- (NSArray *)parseTicketUrls:(NSData *)xml;

@end
