class ArtAdminController < SwellMedia::AdminController
	before_action :get_Art, except: [ :create, :empty_trash, :index ]
	
	def create
		authorize( Art, :admin_create? )
		@art = Art.new( art_params )
		@art.publish_at ||= Time.zone.now
		@art.user ||= current_user
		@art.status = 'draft'

		if params[:art][:category_name].present?
			@art.category = ArtCategory.where( name: params[:art][:category_name] ).first_or_create( status: 'active' )
		end

		if @art.save
			set_flash 'Art Created'
			redirect_to edit_art_admin_path( @art )
		else
			set_flash 'Art could not be created', :error, @art
			redirect_back( fallback_location: '/admin' )
		end
	end


	def destroy
		authorize( Art, :admin_destroy? )
		@art.trash!
		set_flash 'Art Deleted'
		redirect_back( fallback_location: '/admin' )
	end


	def edit
		authorize( @art, :admin_edit? )
	end

	def empty_trash
		authorize( Art, :admin_empty_trash? )
		@pictures = Art.trash.destroy_all
		redirect_back( fallback_location: '/admin' )
		set_flash "#{@pictures.count} destroyed"
	end


	def index
		authorize( Art, :admin? )
		sort_by = params[:sort_by] || 'publish_at'
		sort_dir = params[:sort_dir] || 'desc'

		@art = Art.order( "#{sort_by} #{sort_dir}" )

		if params[:status].present? && params[:status] != 'all'
			@art = eval "@art.#{params[:status]}"
		end

		if params[:q].present?
			@art = @art.where( "array[:q] && keywords", q: params[:q].downcase )
		end

		@art = @art.page( params[:page] )
	end


	def preview
		authorize( @Art, :admin_preview? )
		@media = @Art

		@media_comments = SwellSocial::UserPost.active.where( parent_obj_id: @media.id, parent_obj_type: @media.class.name ).order( created_at: :desc ) if defined?( SwellSocial )

		layout = @media.class.name.underscore.pluralize
		layout = @media.layout if @media.layout.present?
		
		render "art/show", layout: layout
	end


	def update
		authorize( @art, :admin_update? )
		
		@art.slug = nil if ( params[:art][:title] != @art.title ) || ( params[:art][:slug_pref].present? )

		@art.attributes = art_params
		@art.avatar_urls = params[:art][:avatar_urls] if params[:art].present? && params[:art][:avatar_urls].present?


		if params[:art][:category_name].present?
			@art.category = ArtCategory.where( name: params[:art][:category_name] ).first_or_create( status: 'active' )
		end

		if @art.save
			set_flash 'Art Updated'
			redirect_to edit_art_admin_path( id: @art.id )
		else
			set_flash 'Art could not be Updated', :error, @art
			render :edit
		end
		
	end


	private
		def art_params
			params.require( :art ).permit( :title, :subtitle, :slug_pref, :description, :content, :category_id, :status, :publish_at, :show_title, :is_commentable, :user_id, :tags, :tags_csv, :avatar, :avatar_asset_file, :avatar_asset_url, :cover_image, :avatar_urls, :redirect_url )
		end

		def get_Art
			@art = Art.friendly.find( params[:id] )
		end
end