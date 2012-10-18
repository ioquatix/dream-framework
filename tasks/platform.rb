
module Dream
	PLATFORMS_PATH = BASE_PATH + "platforms"
	
	class Platform
		ALL = {}

		def self.all
			ALL.values.select{|platform| platform.available?}
		end
	
		class Config
			def initialize(values = {})
				@values = values
			end
		
			attr :values
		
			def method_missing(name, *args)
				if name.to_s.match(/^(.*?)(\=)?$/)
					if $2
						return @values[$1.to_sym] = args[0]
					else
						return @values[$1.to_sym]
					end
				else
					super(name, *args)
				end
			end
			
			def merge(config)
				Config.new(@values.merge(config))
			end
		end
	
		def prefix
			BUILD_PATH + @name.to_s
		end
	
		def initialize(name)
			@name = name
			@config = nil
			@available = false
			
			ALL[name] = self
		end
		
		def configure(&block)
			@configuration = Proc.new &block
		end
		
		def config
			if available?
				config = Config.new
			
				@configuration.call(config)
			
				return config
			else
				return nil
			end
		end
		
		def self.define(name, &block)
			platform = Platform.new(name)

			yield(platform)
		end
		
		attr :name
		
		def make_available!
			@available = true
		end
		
		def available?
			@available
		end
		
		def to_s
			"<Platform #{@name}: #{@availble ? 'available' : 'inactive'}>"
		end
	end
end
