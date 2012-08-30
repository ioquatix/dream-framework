# Dream Framework #

This framework includes a number of packages typically useful in application development along with build scripts to compile everything for a variety of different platforms. To build and compile all dependencies, simply run the default task:

	% rake

The main targets at this time include Mac OS X, iOS and Linux. Android support is currently in progress and Windows support may happen eventually.

## New Projects ##

The purpose of this framework is to facilitate the development of cross-platform projects. To link Dream Project to a new project, use the following command:

	% rake project:link path/to/project
	-- This will create path/to/project/support/dream-framework

This will 

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

### Android NDK ###

You will need to download the [android_ndk][1] (only the latest version is supported) into platforms in order for this to work.

[1]: http://www.crystax.net/android/ndk
