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

@interface NLCocoaBench ()

- (NLCBProfileStats *)fetchOrCreateStatsForName:(NSString *)profileName;

@end


@implementation NLCocoaBench

@synthesize activeProfileNames;


#pragma mark Memory Management

- (void)dealloc
{
    [activeProfileNames release];
    [profileStats release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        activeProfileNames = [[NSMutableArray alloc] initWithCapacity:20];
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


#pragma mark -
#pragma mark NLCBProfileStats


@implementation NLCBProfileStats

@synthesize name;
@synthesize startTime, stopTime;


#pragma mark Memory Management

- (void)dealloc
{
    self.name = nil;
    [super dealloc];
}


static inline UInt64 NLCBAbsoluteNanoTime()
{
    UInt64 time = mach_absolute_time();
    Nanoseconds timeNano = AbsoluteToNanoseconds(*(AbsoluteTime *) &time);
    return *(uint64_t *)&timeNano;
}

#pragma mark Public Methods

- (void)start
{
    startTime = NLCBAbsoluteNanoTime();
}

- (void)stop
{
    stopTime = NLCBAbsoluteNanoTime();
}


#pragma mark Properties

- (UInt64)duration
{
    return stopTime - startTime;
}


@end


#pragma mark -
#pragma mark NLCBProfileStatsFormatter


@implementation NLCBProfileStatsFormatter


#pragma mark Memory Management

- (void)dealloc
{
    [numberFormatter release];
    [super dealloc];
}


#pragma mark Initialization

- (id)init
{
    if (self = [super init]) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return self;
}


#pragma mark Public Methods

- (NSString *)stringFromStats:(NLCBProfileStats *)stats
{
    NSDecimalNumber *newDuration = nil, *duration = [[[NSDecimalNumber alloc]initWithUnsignedLongLong:stats.duration] autorelease];
    NSString *units = nil;

    if (stats.duration > kSecondScale) {
        duration = [duration decimalNumberByDividingBy:[[[NSDecimalNumber alloc] initWithUnsignedLong:kSecondScale] autorelease]];
        units = @"s";
    } else if (stats.duration > kMillisecondScale) {
        duration = [duration decimalNumberByDividingBy:[[[NSDecimalNumber alloc] initWithUnsignedLong:kMillisecondScale] autorelease]];
        units = @"ms";
    } else {
        units = @"ns";
    }

    NSString *numberString = [numberFormatter stringFromNumber:duration];
    return [NSString stringWithFormat:@"%@ %@", numberString, units];
}

@end