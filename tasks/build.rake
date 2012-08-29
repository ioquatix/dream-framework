
require Pathname.new(__FILE__).dirname + 'package.rb'
require Pathname.new(__FILE__).dirname + 'platform.rb'

# The build scripts don't make specific reference to the Dream project since we want to keep things generic:
Package = Dream::Package
Platform = Dream::Platform
PLATFORMS_PATH = Dream::PLATFORMS_PATH
PACKAGES_PATH = Dream::PACKAGES_PATH

def run(*args)
	$stderr.puts args.join(' ')
	system(*args.collect{|arg| arg.to_s})
end

# Load all platforms - some might not build on the current host.
Dir[PLATFORMS_PATH + "*/platform.rb"].each do |path|
	require path
end

Dir[PACKAGES_PATH + "*"].each do |path|
	next unless File.exist? path + "/package.rb"
	
	Package.require(File.basename(path))
end
