
#
#  platforms/darwin_ios_simulator.rb
#  This file is part of the "Dream" project, and is released under the MIT license.
#

Platform.define(:darwin_ios_simulator) do |platform|
	platform.configure do |config|
		iphone_sdk_version = ENV["IPHONE_SDK_VERSION"] || "6.0" 
	
		config.xcode_path = Pathname.new(`xcode-select --print-path`.chomp)
		config.platform = config.xcode_path + "Platforms/iPhoneSimulator.platform"
		config.toolchain = config.xcode_path + "Toolchains/XcodeDefault.xctoolchain"
	
		config.sdk_version = iphone_sdk_version
		config.sdk = config.platform + "Developer/SDKs/iPhoneSimulator#{config.sdk_version}.sdk"
	
		config.arch = "-arch i386"
		config.cflags = "#{config.arch} -isysroot #{config.sdk} -miphoneos-version-min=#{config.sdk_version} -mdynamic-no-pic"
		config.configure = []
	
		config.build_environment = {
			"CC" => (config.toolchain + "usr/bin/clang").to_s,
			"CXX" => (config.toolchain + "usr/bin/clang++").to_s,
			"LD" => (config.toolchain + "usr/bin/ld").to_s,
			"CFLAGS" => "#{GLOBAL_CFLAGS} #{config.cflags}",
			"CXXFLAGS" => "#{GLOBAL_CFLAGS} #{config.cflags} -std=c++11 -stdlib=libc++ -Wno-c++11-narrowing",
			"LDFLAGS" => "#{GLOBAL_LDFLAGS} #{config.cflags}"
		}
	end
	
	platform.make_available! if RUBY_PLATFORM.include?("darwin")
end
