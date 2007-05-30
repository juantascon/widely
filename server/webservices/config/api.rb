#
# API de Config
#

module Config

class API
	
	include Singleton
	include WebService
	
	def initialize
	end
	
	def login(args)
		args.check("user_id", "password")
	end
	
end

HTTP::APIHandler.set_webservice("config", Config::API.instance)

end
