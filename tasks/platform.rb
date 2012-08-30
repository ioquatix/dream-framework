
module Dream
	PLATFORMS_PATH = BASE_PATH + "platforms"
	
	class Platform
		ALL = {}
	
		def available
			return @config.available
		end

		def self.all
			ALL.values.select{|platform| platform.available}
		end
	
		class Config
			def initialize
				@values = {}
			end
		
			attr :values
		
			def method_missing(name, *args)
				if name.to_s.match(/^(.*?)(\=)?$/)
					if $2
						return @values[$1] = args[0]
					else
						return @values[$1]
					end
				else
					super(name, *args)
				end
			end
		end
	
		def prefix
			BUILD_PATH + @name.to_s
		end
	
		def initialize(name, &block)
			@name = name
			@config = Config.new
		
			yield @config
		
			ALL[name] = self
		end
	
		attr :name
		attr :config
		
		def to_s
			"<Platform: #{@name}>"
		end
	end
end
