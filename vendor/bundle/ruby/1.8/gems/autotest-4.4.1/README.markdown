As soon as you save a file, autotest will run the matching tests.

This is a fork of the ZenTest package to extract autotest from it.

Improvements over ZenTest
=========================
 - possibility to not run all tests after a failed test passes
 - possibility to use alternative config file
 - simplified test setup
 - simplified packaging
 - less globals flying around
 - integration tests


Install
=======
Uninstall ZenTest first, or autotest will not be found:
    sudo gem uninstall ZenTest
Install:
    sudo gem install autotest
Optional: Support for Test::Unit on Rails
    sudo gem install autotest-rails-pure
Optional: an [ZenTest without Autotest](http://github.com/grosser/zentest) version:
    sudo gem install zentest-without-autotest


Usage
=====
 - go to a project folder with tests/specs/...
 - run autotest

### Options
    -f, --fast-start                 Do not run full tests at start
    -c, --no-full-after-failed       Do not run full tests after failed test passed
    -v, --verbose                    Be verbose. Prints files that autotest doesn't know how to map to tests
    -q, --quiet                      Be quiet.
    -r, --rc                         Path to config file. (Defaults to ~/.autotest or current_dir/.autotest)
    -h, --help                       Show this.


Tips
====
 - you need diff.exe on windows. Try http://gnuwin32.sourceforge.net/packages.html

TODO
====
 - add documentation for hooks
 - cleanup bin/autotest Dir hacks
 - remove globals from unitdiff
 - add some automatic notifications e.g. autotest -n -> use any notify library found


License
=======

### Autotest was extracted from ZenTest and improved by:
 - [Charles Roper](http://twitter.com/charlesroper)
 - [Shane Liebling](http://github.com/shanel)
 - [Michael Grosser](http://pragmatig.wordpress.com)

### ZenTest Authors
 - http://www.zenspider.com/ZSS/Products/ZenTest/
 - http://rubyforge.org/projects/zentest/
 - ryand-ruby@zenspider.com


(The MIT License)

Copyright (c) 2001-2006 Ryan Davis, Eric Hodel, Zen Spider Software

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.