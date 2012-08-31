
require 'pathname'

module Dream
	PACKAGES_PATH = BASE_PATH + "packages"

	class Package
		ALL = {}
    
		class BuildError < StandardError
		end

		def self.all
			ALL.values
		end

		def self.build_order(packages)
			ordered = []

			expand = lambda do |name|
				package = ALL[name]

				unless package
					puts "Couldn't resolve #{name}"
				else
					package.depends.each do |dependency|
						expand.call(dependency)
					end

					unless ordered.include? package
						ordered << package
					end
				end
			end

			packages.each do |package|
				expand.call(package.name)
			end

			return ordered
		end

		def initialize(name, path = nil)
			parts = name.split('-')
			@name = parts[0..-2].join('-')
			@version = parts[-1]

			@path = path || (PACKAGES_PATH + @name)

			@variants = {}
			@depends = []

			@source_path = @path + name
			@fetch_location = nil

			ALL[@name] = self
		end

		attr :name
		attr :version
		attr :path
		attr :variants
		attr :fetch_location

		attr :depends, true
		attr :source_path, true

		def self.define(name, &block)
			package = Package.new(name)

			yield(package)
		end

		def variant(name, &block)
			@variants[name] = Proc.new
		end

		def build(platform)
			puts "Building #{@name} for #{platform.name}".center(80, "-")
			callback = @variants[platform.name] || @variants[:all]

			if (callback)
				Dir.chdir(@path) do
					puts "Entering #{@path}"
					callback.call(platform, platform.config)
				end
			else
				raise BuildError.new("Could not find variant #{platform.name}")
			end
		end
    
		def fetch_from(location)
			@fetch_location = location
		end

		def self.require(name)
			unless ALL[name]
				load PACKAGES_PATH + name + "package.rb"
			end

			return ALL[name]
		end
		
		def to_s
			"<Package: #{@name}>"
		end
	end
end
