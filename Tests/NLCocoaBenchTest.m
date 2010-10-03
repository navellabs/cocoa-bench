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

#import <SenTestingKit/SenTestingKit.h>
#import "NLCocoaBench.h"
#import "NLCBProfileStatsStub.h"


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

- (void)testGettingAProfileSummary
{
    [bench startProfile:@"someLoop"];
    [bench finishProfile:@"someLoop"];
    [bench startProfile:@"otherLoop"];
    [bench finishProfile:@"otherLoop"];
    NSString *summary = [bench summary];
    STAssertNotNil(summary, nil);
}

- (void)testSharedSingleton
{
    NLCocoaBench *bench1 = [NLCocoaBench sharedBench];
    NLCocoaBench *bench2 = [NLCocoaBench sharedBench];
    STAssertEquals(bench1, bench2, nil);
}

#ifdef __BLOCKS__

- (void)testBenchmarkingWithABlock
{
    __block NSString *mustBeSet = nil;

    [bench profile:@"someLoop" block:^{
        mustBeSet = @"with this";
    }];
    NSTimeInterval time = [bench profileTime:@"someLoop"];
    STAssertFalse(time == 0, nil);
    STAssertNotNil(mustBeSet, nil);
}

#endif

@end
