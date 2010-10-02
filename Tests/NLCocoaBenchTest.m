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

#import <SenTestingKit/SenTestingKit.h>
#import "NLCocoaBench.h"


@interface NLCocoaBenchTest : SenTestCase {
    NLCocoaBench *bench;
}

@end


@implementation NLCocoaBenchTest

- (void)setUp
{
    [super setUp];
    bench = [[[NLCocoaBench alloc] init] autorelease];
}

- (void)testStartingAProfile
{
    [bench startProfile:@"someLoop"];
    STAssertEquals((int)[bench.activeProfileNames count], (int)1, nil);
    STAssertEquals([bench.activeProfileNames objectAtIndex:0], @"someLoop", nil);
}

- (void)testFinishingAProfileRemovesItFromTheActiveList
{
    [bench startProfile:@"someLoop"];
    [bench finishProfile:@"someLoop"];
    STAssertEquals((int)[bench.activeProfileNames count], (int)0, nil);
}

- (void)testStartingAnotherProfileAddsItToTheActiveList
{
    [bench startProfile:@"someLoop"];
    [bench startProfile:@"innerLoop"];
    STAssertEquals((int)[bench.activeProfileNames count], (int)2, nil);
    STAssertEqualObjects(bench.activeProfileNames, ([NSArray arrayWithObjects:@"someLoop", @"innerLoop", nil]), nil);
}

- (void)testGettingAProfilesTime
{
    [bench startProfile:@"someLoop"];
    [bench finishProfile:@"someLoop"];
    NSTimeInterval time = [bench profileTime:@"someLoop"];
    STAssertFalse(time == 0, nil);
}

@end


#pragma mark -
#pragma mark NLCBProfileStats object tests


@interface NLCBProfileStatsTest : SenTestCase {
    NLCBProfileStats *stats;
}

@end

@implementation NLCBProfileStatsTest

- (void)setUp
{
    stats = [[[NLCBProfileStats alloc] init] autorelease];
}

- (void)testProfileNameProperty
{
    stats.name = @"someName";
    STAssertEqualObjects(stats.name, @"someName", nil);
}

- (void)testProfileStartTimeProperty
{
    stats.startTime = 1;
    STAssertEquals(stats.startTime, (UInt64)1, nil);
}

- (void)testProfileEndTimeProperty
{
    stats.stopTime = 1;
    STAssertEquals(stats.stopTime, (UInt64)1, nil);
}

- (void)testProfileDurationProperty
{
    stats.startTime = 1;
    stats.stopTime = 2;
    STAssertEquals(stats.duration, (UInt64)1, nil);
}

- (void)testTiming
{
    [stats start];
    [stats stop];
    STAssertFalse(stats.duration == 0, nil);
}

@end

