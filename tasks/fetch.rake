
task :fetch do
	Package::ALL.each do |name, package|
		# We are interested in full name..
		name = package.name + "-" + package.version
		location = package.fetch_location
		
		if !location
			puts "Could not determine fetch location for #{name}!"
		elsif File.exist? package.source_path
			puts "Source path #{package.source_path} already exists!"
		else
			url = location[:url]
			local_path = package.path + (location[:filename] || File.basename(url))
			
			puts "Local path: #{local_path}"
			
			unless package.source_path.exist?
				unless local_path.exist?
					puts "Downloading #{name} to #{local_path}..."
					sh("curl", "-L", url, "-o", local_path.to_s)
				end
			
				puts "Extracting #{name}..."
				sh("mkdir", package.source_path.to_s)
				sh("tar", "-C", package.source_path.to_s, "--strip-components", "1", "-xvf", local_path.to_s)
			end
		end
	end
end
