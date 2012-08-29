
task :fetch do
	Package::ALL.each do |name, package|
		# We are interested in full name..
		name = package.name + "-" + package.version
		location = package.fetch_location
		
		unless location
			puts "Could not determine fetch location for #{name}!"
		else
			url = location[:url]
			local_path = package.path + (location[:filename] || File.basename(url))
		
			unless File.exist? local_path
				puts "Downloading #{name} to #{local_path}..."
				sh("curl", "-L", url, "-o", local_path)
			
				puts "Extracting #{name}..."
				sh("tar", "-C", package.path, "-xvf",local_path)
			end
		end
	end
end
