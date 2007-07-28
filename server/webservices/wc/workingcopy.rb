#
# Manejador de Copia de Trabajo
#

module WC

class WorkingCopy < WPluginable
	
	include WStorage::Storable
	
	@@default_wc = Repo::Version.new("-1")
	def self.default_wc; @@default_wc; end
	
	attr_reader :owner, :repo, :name, :data_dir
	alias :collectable_key :name
	
	def initialize(owner, repo, name, manager, from_storage=false)
		@owner = owner
		@repo = repo
		@name = name
		@manager = manager
		
		@data_dir = "#{@owner.data_dir}/wcs/#{@name}/data_dir" if ! @data_dir
		
		raise wex_arg("name", @name, "(nice try)") if ! validate_id(@name)
		raise wex_arg("owner", @owner) if ! @owner.kind_of? WUser::User
		raise wex_arg("repo", @repo) if ! @repo.kind_of? Repo::Repository
		
		wplugin_activate(@manager)
		wplugin_init()
		
		w_debug("new: #{@name} #{@manager} #{@data_dir}")
	end
	
	def initialize_from_storage(data)
		owner = WUser::Set.instance.get_ex(data["owner"])
		repo = owner.reposet.get_ex(data["repo"])
		name = data["name"]
		manager = data["manager"]
		w_debug("restoring object: WC[owner:#{owner.user_id} name:#{name}]")
		
		initialize(owner, repo, name, manager, true)
	end
	
	def destroy()
		rm_rf(File.dirname(@data_dir))
		@owner.wcset.delete_by_object(self)
	end
	
	def to_h()
		{ "repo" => @repo.name, "owner" => @owner.user_id, "name" => @name, "manager" => @manager }
	end
	
end

WUser::ExtraAttrs.instance.add(:wcset) do |user, from_storage|
	storager = WStorage::DistributedStorager.new(WorkingCopy, "#{user.data_dir}/wcs/%s/wc.conf")
	storager.load_all if from_storage
	storager
end

end
