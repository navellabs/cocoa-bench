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

 http://github.com/navellabs/cocoa-bench
 */

#import "NLCBProfile.h"
#import "NLCBProfileStatsFormatter.h"
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <unistd.h>

@implementation NLCBProfile

@synthesize name;
@synthesize startTime, stopTime;
@synthesize whenStarted, whenStopped;

static mach_timebase_info_data_t timebase;

#pragma mark Memory Management

- (void)dealloc
{
    self.whenStarted = nil;
    self.whenStopped = nil;
    self.name = nil;
    [super dealloc];
}


static inline UInt64 NLCBAbsoluteNanoTime()
{
    mach_timebase_info_data_t timebase;
    (void) mach_timebase_info(&timebase);
    UInt64 time = mach_absolute_time();
    return ((double)(time)) * ((double)timebase.numer) / ((double)timebase.denom);
}

#pragma mark Public Methods

- (void)start
{
    startTime = NLCBAbsoluteNanoTime();
    self.whenStarted = [NSDate date];
}

- (void)stop
{
    stopTime = NLCBAbsoluteNanoTime();
    self.whenStopped = [NSDate date];
}

- (NSString *)description
{
    NLCBProfileStatsFormatter *formatter = [[NLCBProfileStatsFormatter alloc] init];
    NSString *result = [NSString stringWithFormat:@"%@: %@ - %@", self.whenStopped, self.name, [formatter stringFromProfile:self]];
    [formatter release];
    return result;
}


#pragma mark Properties

- (UInt64)duration
{
    return stopTime - startTime;
}


@end


