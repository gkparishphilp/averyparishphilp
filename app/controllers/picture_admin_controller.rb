class PictureAdminController < SwellMedia::AdminController
	before_action :get_picture, except: [ :create, :empty_trash, :index ]
	
	def create
		authorize( Picture, :admin_create? )
		@picture = Picture.new( picture_params )
		@picture.publish_at ||= Time.zone.now
		@picture.user ||= current_user
		@picture.status = 'draft'

		if params[:picture][:category_name].present?
			@picture.category = PictureCategory.where( name: params[:picture][:category_name] ).first_or_create( status: 'active' )
		end

		if @picture.save
			set_flash 'Picture Created'
			redirect_to edit_picture_admin_path( @picture )
		else
			set_flash 'Picture could not be created', :error, @picture
			redirect_back( fallback_location: '/admin' )
		end
	end


	def destroy
		authorize( Picture, :admin_destroy? )
		@picture.trash!
		set_flash 'picture Deleted'
		redirect_back( fallback_location: '/admin' )
	end


	def edit
		authorize( @picture, :admin_edit? )
	end

	def empty_trash
		authorize( Picture, :admin_empty_trash? )
		@pictures = Picture.trash.destroy_all
		redirect_back( fallback_location: '/admin' )
		set_flash "#{@pictures.count} destroyed"
	end


	def index
		authorize( Picture, :admin? )
		sort_by = params[:sort_by] || 'publish_at'
		sort_dir = params[:sort_dir] || 'desc'

		@pictures = Picture.order( "#{sort_by} #{sort_dir}" )

		if params[:status].present? && params[:status] != 'all'
			@pictures = eval "@pictures.#{params[:status]}"
		end

		if params[:q].present?
			@pictures = @pictures.where( "array[:q] && keywords", q: params[:q].downcase )
		end

		@pictures = @pictures.page( params[:page] )
	end


	def preview
		authorize( @picture, :admin_preview? )
		@media = @picture

		@media_comments = SwellSocial::UserPost.active.where( parent_obj_id: @media.id, parent_obj_type: @media.class.name ).order( created_at: :desc ) if defined?( SwellSocial )

		layout = @media.class.name.underscore.pluralize
		layout = @media.layout if @media.layout.present?
		
		render "pictures/show", layout: layout
	end


	def update
		authorize( @picture, :admin_update? )
		
		@picture.slug = nil if ( params[:picture][:title] != @picture.title ) || ( params[:picture][:slug_pref].present? )

		@picture.attributes = picture_params
		@picture.avatar_urls = params[:picture][:avatar_urls] if params[:picture].present? && params[:picture][:avatar_urls].present?


		if params[:picture][:category_name].present?
			@picture.category = PictureCategory.where( name: params[:picture][:category_name] ).first_or_create( status: 'active' )
		end

		if @picture.save
			set_flash 'picture Updated'
			redirect_to edit_picture_admin_path( id: @picture.id )
		else
			set_flash 'picture could not be Updated', :error, @picture
			render :edit
		end
		
	end


	private
		def picture_params
			params.require( :picture ).permit( :title, :subtitle, :slug_pref, :description, :content, :category_id, :status, :publish_at, :show_title, :is_commentable, :user_id, :tags, :tags_csv, :avatar, :avatar_asset_file, :avatar_asset_url, :cover_image, :avatar_urls, :redirect_url )
		end

		def get_picture
			@picture = Picture.friendly.find( params[:id] )
		end
end