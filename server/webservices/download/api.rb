module Download

class API
	
	include Singleton
	include WebService
	
	def pack(args)
		args.check("session_id", "wc_id", "manager_id")
		
		session = args.collection_get(Auth::Sessions.instance, "session_id")
		
		wc = args.collection_get(session.user.wcs, "wc_id")
		
		version = Repos::Version.new(args["version"]) if args["version"]
		
		manager_id = args["manager_id"].to_sym if args["manager_id"]
		
		return Download.new(wc, version, manager_id).pack()
	end
end

HTTP::APIHandler.set_webservice("download", API.instance)

end
