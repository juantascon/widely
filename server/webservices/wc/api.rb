#
# API de WorkingCopy
#

module WC

class API
	
	include Singleton
	include WebService
	
	#
	# Retorna la lista de posibles manejadores de copia de trabajo
	#
	def manager_list(args)
		args.check("session_id")
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		return true, WorkingCopy.wplugin_list
	end
	
	#
	# Crea una copia de trabajo nueva
	#
	def create(args)
		args.check("session_id", "repo_id", "name", "manager")
		
		name = args["name"]
		manager = args["manager"]
		
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		raise wex_arg("name", name, "workingcopy already exists") if user.wcset.get(name)
		
		repo = user.reposet.get_ex(args["repo_id"])
		
		wc = WorkingCopy.new(user, repo, name, manager)
		user.wcset.add(wc)
		
		wc.checkout
		
		return true, wc.collectable_key
	end
	
	#
	# Elimina una copia de trabajo
	#
	def destroy(args)
		args.check("session_id", "name")
		
		name = args["name"]
		
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		wc = user.wcset.get(name)
		
		raise wex_arg("name", name, "workingcopy does not exists") if ! wc
		
		wc.destroy
		
		return true
	end
	
	#
	# Retorna una lista de las copias de trabajo de un usuario
	#
	def list(args)
		args.check("session_id")
		user = Auth::SessionSet.instance.get_ex(args["session_id"]).user
		
		ret = Array.new
		user.wcset.each { |key, object| ret.push object.to_h }
		
		return true, ret
	end
	
	
	#
	# Hace checkout desde el repositorio hacia la copia de trabajo
	#
	def checkout(args)
		args.check("session_id")
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		wc = session.wc
		version = Repo::Version.new(args["version"]) if args["version"]
		
		return wc.checkout(version)
	end
	
	#
	# Actualiza los cambios desde el repositorio hacia la copia de trabajo
	#
	def update(args)
		args.check("session_id")
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		wc = session.wc
		
		return wc.update()
	end
	
	#
	# TODO: doc
	#
	def status(args)
		args.check("session_id")
		session = Auth::SessionSet.instance.get_ex(args["session_id"])
		wc = session.wc
		
		return wc.status()
	end
	
	#
	# Hace commit de los cambios hacia el repositorio
	#
	def commit(args)
		args.check("session_id", "log")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.commit(args["log"])
	end
	
	#
	# Retorna una lista de versiones incluyendo la copia de trabajo
	#
	def version_list(args)
		args.check("session_id")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.versions()
	end
	
	#
	# Muestra el contenido de un archivo
	#
	def cat(args)
		args.check("session_id", "path")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		version = Repo::Version.new(args["version"]) if args["version"]
		
		return wc.cat(args["path"], version)
	end
	
	#
	# Muestra el contenido de un directorio de forma recursiva
	#
	def ls(args)
		args.check("session_id", "path")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		version = Repo::Version.new(args["version"]) if args["version"]
		
		return wc.ls(args["path"], version)
	end
	
	#
	# Adiciona un archivo
	#
	def add(args)
		args.check("session_id", "path")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		as_dir = ( args["as_dir"] == "true" )
		
		return wc.add(args["path"], as_dir)
	end
	
	#
	# Elimina un archivo
	#
	def delete(args)
		args.check("session_id", "path")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.delete(args["path"])
	end
	
	#
	# Mueve un archivo
	#
	def move(args)
		args.check("session_id", "path_from", "path_to")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.move(args["path_from"], args["path_to"])
	end
	
	#
	# Copia un archivo
	#
	def copy(args)
		args.check("session_id", "path_from", "path_to")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.copy(args["path_from"], args["path_to"])
	end
	
	#
	# Reescribe el contenido de un archivo
	#
	def write(args)
		args.check("session_id", "path", "content")
		wc = Auth::SessionSet.instance.get_ex(args["session_id"]).wc
		
		return wc.write(args["path"], args["content"])
	end
end

# Registra este API como un webservice
HTTPAPI::WebServiceHandler.set_webservice("wc", WC::API.instance)

end
