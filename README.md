# Dream Framework #

* Author: Samuel G. D. Williams (<http://www.oriontransfer.co.nz>)
* Copyright (C) 2012 Samuel G. D. Williams.
* Released under the MIT license.

This framework includes a number of packages typically useful in application development along with build scripts to compile everything for a variety of different platforms. The main targets at this time include Mac OS X, iOS and Linux. Android support is currently in progress and Windows support may happen eventually.

A [selection of examples][1] that use this framework are available. For more details, please see the main [project page][2].

[1]: https://github.com/ioquatix/dream-examples
[2]: http://www.oriontransfer.co.nz/research/dream

## New Projects ##

### Build ###

To build and compile all dependencies, simply run the default task:

	% rake

You can specify a debug variant which compiles with debug symbols

	% rake build VARIANT=debug

If you want something more specific you can specify the package, platform, etc:

	% rake build[dream,darwin_ios] ONLY=true VARIANT=debug

### Combine ###

The purpose of this framework is to facilitate the development of cross-platform projects. To link this framework to a new project, use the following command:

	% rake project:link path/to/project

This will create a relative symlink `path/to/project/support/dream-framework` which points to the dream-framework directory.

#### Xcode Configuration #####

Xcode integration works by using `.xcconfig` files

	% rake project:xcconfig path/to/project

This will create `path/to/project/support/dream-framework.xcconfig` which you can use in your Xcode project.

#### CMake Configuration ####

CMake integration works by including the relevant CMake modules into your existing build system.

This is currently a work in progress.

## Packages ##

To list all available packages:

	% rake list
	(in /Users/samuel/Documents/Programming/Graphics/Dream/ext)
	Package: libpng
	Package: libvorbis
	Package: jpeg
	Package: freetype
	Package: OpenCV
	Package: libogg
		(depends on libvorbis)
	Platform: darwin_ios_simulator
	Platform: darwin_osx
	Platform: darwin_ios

To build all packages, use the following command:

	% rake build_all

To build a specific package use the following command:

	% rake build[freetype,android_ndk]

## Platforms ##

Platforms are specific configurations for compiling external dependencies. Unfortunately, since most dependencies use `autoconf`, we need to work hard to setup the correct build environment to ensure that libraries are compiled properly. Feel free to adjust the platform configuration files for your own requirements.

### Darwin ###

At this time, Mac OS X 10.8 is required to build `darwin_*` platforms. 

### Linux ###

Build using the following command:

	$ sudo apt-get install cmake libz-dev libopenal-dev
	$ rake build PLATFORM=linux

### Android NDK ###

You will need to download the [android_ndk][3] (only the latest version is supported) into platforms in order for this to work.

[3]: http://www.crystax.net/android/ndk

## License ##

Copyright (c) 2012 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
