
task :fetch do
	info = YAML::load_file(EXT_PATH + "packages/fetch.yaml")
	
	Package::ALL.each do |name, package|
		# We are interested in full name..
		name = package.name + "-" + package.version
		
		unless info[name]
			puts "Couldn't find information for #{name}!"
			next
		end
		
		url = info[name]['url']
		local_path = package.path + (info[name]['filename'] || File.basename(url))
		
		unless File.exist? local_path
			puts "Downloading #{name} to #{local_path}..."
			puts ["curl", "-L", url, "-o", local_path].join(' ')
			system("curl", "-L", url, "-o", local_path)
			
			puts "Extracting #{name}..."
			system("tar", "-C", package.path, "-xvf",local_path)
		end
	end
end
