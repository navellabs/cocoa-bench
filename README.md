CocoaBench
==========

CocoaBench is a quick and dirty mechanism to benchmark chunks of code
and generate a text summary. Just wrap it around the code you want to
time and `NSLog()` the summary when you're ready to go!


Usage
-----

### Example 1 - Block syntax! ###

If you're able to use the new Objective C block syntax, then just wrap
the code you want to profile in a block:

    NLCBProfile *profile = [NLCocoaBench profile:@"Some Operation" block:^{
      for (NSString *values in strings) {
          // Do some expensive operation over and over...
      }
    }];

    // Dump the summary of the benchmark to the console
    NSLog(@"%@", profile);

Outputs something like:

    Some Operation - 25.2 ms


### Example 2 - Manually wrapping around code ###

You can use the convenient class methods to generate and start a profile
running. Stop it when you're done and then query it for whatever you
need!

    // Tell the global cocoa bench object to start profiling
    // with a given name
    NLCBProfile *profile = [NLCocoaBench startProfile:@"Long Running Operation"];

    for (NSString *values in strings) {
        // Do some expensive operation over and over...
    }

    // Tell cocoa bench that you're done with this profile.
    [profile stop];

    // Dump the summary of the benchmark to the console
    NSLog(@"%@", profile);

Outputs something like:

    Long Running Operation - 30 ns


Installation
------------

Just copy the `CocoaBench` subdirectory from this project somewhere into
your project and add to Xcode. Make sure everything compiles and then
just:

    #import "NLCocoaBench.h"


Gotchas
-------

  - If you start a profile of a same name to one you started and finished
    earlier, it's previous information will be overwritten.
  - Don't call `summary` until you've finished all the open profiles.


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

