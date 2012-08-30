
Package.define("jpeg-8d") do |package|
	package.fetch_from :url => "http://www.ijg.org/files/jpegsrc.v8d.tar.gz"
	
	package.variant(:all) do |platform, config|
		RExec.env(config.build_environment) do
			Dir.chdir(package.source_path) do
				sh("make", "clean") if File.exist? "Makefile"
				
				sh("./configure", "--prefix=#{platform.prefix}", "--disable-dependency-tracking", "--enable-shared=no", "--enable-static=yes", *config.configure)
				sh("make install")
			end
		end
	end
end
