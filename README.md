CocoaBench
==========

CocoaBench is a quick and dirty mechanism to benchmark chunks of code
and generate a text summary. Just wrap it around the code you want to
time and `NSLog()` the summary when you're ready to go!

### Example 1 - Wrapping around code ###

    // Tell the global cocoa bench object to start profiling
    // with a given name
    [NLCocoaBench startProfile:@"longRunningOperation"];

    for (NSString *values in strings) {
        // Do some expensive operation over and over...
    }

    // Tell cocoa bench that you're done with this profile.
    [NLCocoaBench finishProfile:@"longRunningOperation"];

    // Dump the summary of the benchmark to the console
    NSLog(@"%@", [NLCocoaBench summary]);

    /*
      Outputs something like:

      Cocoa Bench Summary:
      longRunningOperation - 30 ns
    */


### Example 2 - More than one profile ###

    // Tell the global cocoa bench object to start profiling
    [NLCocoaBench startProfile:@"wholeOperation"];

    // Do some first part of a long operation

    // Nest this inner profile benchmark
    [NLCocoabench startProfile:@"innerOperation"];
    // Do a smaller part of the larger operation...
    [NLCocoaBench finishProfile:@"innerOperation"];

    // Stop this first profile
    [NLCocoaBench finishProfile:@"wholeOperation"];

    // Dump the summary of the benchmark to the console
    NSLog(@"%@", [NLCocoaBench summary]);

    /*
      Outputs something like:

      Cocoa Bench Summary:
      wholeOperation - 90 ms
      innerOperation - 30 ns
    */


### Example 3 - Block syntax! ###


License
-------

Copyright (c) 2010 Navel Labs, Ltd.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

