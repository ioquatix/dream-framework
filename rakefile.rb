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
GLOBAL_CFLAGS = "-O2 -Wall -Wmissing-prototypes -std=c99 -ffast-math -fno-strict-aliasing -pipe"

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
		
		# For testing...
		# next unless platform.name == :darwin_iphonesimulator
		Package.all.each do |package|
			# next unless package.name == "boost_1_43_0"
			package.build(platform)
		end
	end
end

task :build, [:package, :platform] do |task, arguments|
	platforms = Platform.all
	packages = Package.all
	
	if arguments[:package]
		packages = [Package::ALL[arguments[:package]]]
	end
	
	if arguments[:platform]
		platforms = [Platform::ALL[arguments[:platform].to_sym]]
	end
	
	platforms.each do |platform|
		packages.each do |package|
			package.build(platform)
		end
	end
end

task :list do
	ordered = Package::build_order(Package::ALL)
	
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
