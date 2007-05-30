#
# API de Download
#

module Download

class API
	
	include Singleton
	include WebService
	
	def pack(args)
		args.check("session_id", "manager_id")
		
		wc = Auth::SessionSet.instance.get(args["session_id"]).wc
		version = Repos::Version.new(args["version"]) if args["version"]
		manager_id = args["manager_id"].to_sym if args["manager_id"]
		
		return Download.new(wc, version, manager_id).pack()
	end
end

HTTP::APIHandler.set_webservice("download", API.instance)

end
