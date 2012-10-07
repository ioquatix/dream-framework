#!/usr/bin/env ruby

#
#  rakefile.rb
#  This file is part of the "Dream" project, and is released under the MIT license.
#
#  Created by Samuel Williams on 14/08/2010.
#  Copyright (c) 2010 Samuel Williams. All rights reserved.
#

require 'rubygems'
gem 'rexec'

require 'rexec/environment'
require 'stringio'
require 'fileutils'
require 'pathname'
require 'yaml'

module Dream
	# The root path for all project relative operations:
	BASE_PATH = Pathname.new(__FILE__).dirname
end

EXT_PATH = Pathname.new(__FILE__).dirname
SOURCE_PATH = EXT_PATH + "src"
BUILD_PATH = EXT_PATH + "build"
CPP_SOURCE = ['h', 'c', 'cpp']

case ENV['VARIANT']
when 'debug'
	GLOBAL_CFLAGS = "-O0 -g -Wall -Wmissing-prototypes -pipe"
when 'release'
	GLOBAL_CFLAGS = "-O2 -Wall -ffast-math -fno-strict-aliasing -pipe"
else
	GLOBAL_CFLAGS = ""
end

Dir["./tasks/*.rake"].each do |path|
	load path
end

task :default => [:fetch, :build_all]

task :build_all do
	Platform.all.each do |platform|
		order = []
		Package.all.each do |package|
			if package.depends.size == 0
				order << package.name
			else
				package.depends
			end
			package.name
		end
		
		Package.all.each do |package|
			package.build(platform)
		end
	end
end

task :build, [:package, :platform] do |task, arguments|
	platforms = Platform.all
	packages = Package.all
	
	if arguments[:package]
		package = Package::ALL[arguments[:package]]
		
		unless package
			puts "Could not find package #{arguments[:package]}"
			
			next
		end
		
		packages = [package]
	end
	
	if arguments[:platform]
		platform = Platform::ALL[arguments[:platform].to_sym]
		
		unless platform
			puts "Could not find platform #{arguments[:package]}"
			
			next
		end
		
		platforms = [platform]
	end
	
	unless ENV['ONLY']
		ordered = Package.build_order(packages)
	else
		ordered = packages
	end
	
	puts "Building: #{ordered.join(', ')}"
	
	platforms.each do |platform|
		ordered.each do |package|
			package.build(platform)
		end
	end
end

task :list do
	ordered = Package::build_order(Package::ALL.values)
	
	ordered.each do |package|
		puts "Package: #{package.name}"
		
		if package.depends.size > 0
			puts "	(depends on #{package.depends.join(', ')})"
		end
	end
	
	Platform.all.each do |platform|
		puts "Platform: #{platform.name}"
	end
end
