//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"

@class LighthouseCredentials;

@interface LogInResponseProcessor : ResponseProcessor
{
    LighthouseCredentials * credentials;
    id delegate;
}

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
               credentials:(LighthouseCredentials *)someCredentials
                  delegate:(id)aDelegate;
- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
          credentials:(LighthouseCredentials *)someCredentials
             delegate:(id)aDelegate;

@end
