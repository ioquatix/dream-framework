
Package.define("tagged-format-0.2.0") do |package|
	package.fetch_from :url => "https://github.com/ioquatix/tagged-format/tarball/0.2.0", :filename => "tagged-format-0.2.0.tar.gz"
	
	package.build(:all) do |platform, config|
		RExec.env(config.build_environment) do
			Dir.chdir(package.source_path) do
				sh("rm", "-rf", "build")
				sh("mkdir", "build")
				
				Dir.chdir("build") do
					cmake_options = []
					cmake_options << "-DCMAKE_INSTALL_PREFIX:PATH=#{platform.prefix}"
					cmake_options << "-DCMAKE_PREFIX_PATH=#{platform.prefix}"
					cmake_options << ".."
					
					sh("cmake", "-G", "Unix Makefiles", *cmake_options)
					
					sh("make")
					sh("make", "install")
				end
			end
		end
	end
end
