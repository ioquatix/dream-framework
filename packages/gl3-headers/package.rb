
Package.define("gl3-headers-1.0") do |package|
	package.build(:all) do |platform, config|
	end

	package.build(:linux) do |platform, config|
		include_path = File.expand_path("../include", __FILE__)
		
		$stderr.puts "Copying #{include_path} to #{platform.prefix}"
		FileUtils.cp_r include_path, platform.prefix.to_s
	end
end

