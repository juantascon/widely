#
# API de Download
#

module Download

class API
	
	include Singleton
	include WebService
	
	def pack(args)
		args.check("session_id", "manager")
		
		manager = args["manager"]
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		version = Repo::Version.new(args["version"]) if args["version"]
		
		return Download.new(wc, version, manager).pack()
	end
end

HTTPAPI::WebServiceHandler.set_webservice("download", API.instance)

end
