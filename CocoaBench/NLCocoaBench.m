/*
 Copyright (c) 2010 Navel Labs, Ltd.

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */

#import "NLCocoaBench.h"
#import "NLCocoaBenchSummaryFormatter.h"
#import "NLCBProfileStats.h"

@interface NLCocoaBench ()
- (NLCBProfileStats *)fetchOrCreateStatsForName:(NSString *)profileName;
@end

static NLCocoaBench *sharedNLCocoaBench = nil;

@implementation NLCocoaBench

@synthesize activeProfileNames;


#pragma mark Recommended Class Methods

+ (void)startProfile:(NSString *)profileName
{
    [[self sharedBench] startProfile:profileName];
}

+ (void)finishProfile:(NSString *)profileName
{
    [[self sharedBench] finishProfile:profileName];
}

+ (NSString *)summary
{
    return [self sharedBench].summary;
}

+ (NLCocoaBench *)sharedBench
{
    @synchronized(self) {
        if (!sharedNLCocoaBench) {
            sharedNLCocoaBench = [[self allocWithZone:NULL] init];
        }
    }
    return sharedNLCocoaBench;
}


#pragma mark Memory Management

- (void)dealloc
{
    [activeProfileNames release];
    [allProfileNames release];
    [profileStats release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        activeProfileNames = [[NSMutableArray alloc] initWithCapacity:20];
        allProfileNames = [[NSMutableArray alloc] initWithCapacity:20];
        profileStats = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    return self;
}


#pragma mark Profile Management

- (void)startProfile:(NSString *)profileName
{
    NLCBProfileStats *stats = [self fetchOrCreateStatsForName:profileName];
    [stats start];
    [activeProfileNames addObject:profileName];
    [allProfileNames addObject:profileName];
}

- (void)finishProfile:(NSString *)profileName
{
    NLCBProfileStats *stats = [self fetchOrCreateStatsForName:profileName];
    [stats stop];
    [activeProfileNames removeObject:profileName];
}

- (UInt64)profileTime:(NSString *)profileName
{
    NLCBProfileStats *stats = [self fetchOrCreateStatsForName:profileName];
    return stats.duration;
}

- (NSString *)summary
{
    NLCocoaBenchSummaryFormatter *formatter = [[NLCocoaBenchSummaryFormatter alloc] init];
    NSString *result = [formatter summarizeProfileNames:allProfileNames forStats:profileStats];
    [formatter release];
    return result;
}


#ifdef __BLOCKS__

- (void)profile:(NSString *)profileName block:(NLCocoaBenchBlock)block
{
    [self startProfile:profileName];
    block();
    [self finishProfile:profileName];
}

#endif


#pragma mark Private Methods

- (NLCBProfileStats *)fetchOrCreateStatsForName:(NSString *)profileName
{
    NLCBProfileStats *stats = [profileStats objectForKey:profileName];
    if (!stats) {
        stats = [[[NLCBProfileStats alloc] init] autorelease];
        [profileStats setObject:stats forKey:profileName];
    }
    return stats;
}


@end
