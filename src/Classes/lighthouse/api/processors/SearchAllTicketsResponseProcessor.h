//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousResponseProcessor.h"
#import "LighthouseApiServiceDelegate.h"

@class TicketDataCollector;

@interface SearchAllTicketsResponseProcessor : AsynchronousResponseProcessor
{
    id projectKey;
    NSString * searchString;
    NSUInteger page;
    id object;
    id<LighthouseApiServiceDelegate> delegate;

    TicketDataCollector * collector;
}

@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, copy, readonly) NSString * searchString;
@property (nonatomic, assign, readonly) NSUInteger page;
@property (nonatomic, retain, readonly) id object;
@property (nonatomic, assign, readonly) id<LighthouseApiServiceDelegate>
    delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
              searchString:(NSString *)aSearchString
                      page:(NSUInteger)aPage
                  delegate:(id<LighthouseApiServiceDelegate>)aDelegate;
+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                projectKey:(id)aProjectKey
              searchString:(NSString *)aSearchString
                      page:(NSUInteger)aPage
                    object:(id)anObject
                  delegate:(id<LighthouseApiServiceDelegate>)aDelegate;

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
         searchString:(NSString *)aSearchString
                 page:(NSUInteger)aPage
             delegate:(id<LighthouseApiServiceDelegate>)aDelegate;
- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
           projectKey:(id)aProjectKey
         searchString:(NSString *)aSearchString
                 page:(NSUInteger)aPage
               object:(id)anObject
             delegate:(id<LighthouseApiServiceDelegate>)aDelegate;

@end
