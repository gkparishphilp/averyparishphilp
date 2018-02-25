
class WritingAdminController < SwellMedia::AdminController
	
	before_action :get_article, except: [ :create, :empty_trash, :index ]
	
	def create
		authorize( SwellMedia::Article, :admin_create? )
		@article = SwellMedia::Article.new( article_params )
		@article.publish_at ||= Time.zone.now
		@article.user ||= current_user
		@article.status = 'draft'

		if params[:article][:category_name].present?
			@article.category = SwellMedia::ArticleCategory.where( name: params[:article][:category_name] ).first_or_create( status: 'active' )
		end

		if @article.save
			set_flash 'Article Created'
			redirect_to edit_writing_admin_path( @article )
		else
			set_flash 'Article could not be created', :error, @article
			redirect_back( fallback_location: '/admin' )
		end
	end


	def destroy
		authorize( SwellMedia::Article, :admin_destroy? )
		@article.trash!
		set_flash 'Article Deleted'
		redirect_back( fallback_location: '/admin' )
	end


	def edit
		authorize( @article, :admin_edit? )
	end

	def empty_trash
		authorize( SwellMedia::Article, :admin_empty_trash? )
		@articles = SwellMedia::Article.trash.destroy_all
		redirect_back( fallback_location: '/admin' )
		set_flash "#{@articles.count} destroyed"
	end


	def index
		authorize( SwellMedia::Article, :admin? )
		sort_by = params[:sort_by] || 'publish_at'
		sort_dir = params[:sort_dir] || 'desc'

		@articles = SwellMedia::Article.order( "#{sort_by} #{sort_dir}" )

		if params[:status].present? && params[:status] != 'all'
			@articles = eval "@articles.#{params[:status]}"
		end

		if params[:q].present?
			@articles = @articles.where( "array[:q] && keywords", q: params[:q].downcase )
		end

		@articles = @articles.page( params[:page] )
	end


	def preview
		authorize( @article, :admin_preview? )
		@media = @article

		@media_comments = SwellSocial::UserPost.active.where( parent_obj_id: @media.id, parent_obj_type: @media.class.name ).order( created_at: :desc ) if defined?( SwellSocial )

		layout = @media.class.name.underscore.pluralize
		layout = @media.layout if @media.layout.present?
		
		render "swell_media/articles/show", layout: layout
	end


	def update
		authorize( @article, :admin_update? )
		
		@article.slug = nil if ( params[:article][:title] != @article.title ) || ( params[:article][:slug_pref].present? )

		@article.attributes = article_params
		@article.avatar_urls = params[:article][:avatar_urls] if params[:article].present? && params[:article][:avatar_urls].present?


		if params[:article][:category_name].present?
			@article.category = SwellMedia::ArticleCategory.where( name: params[:article][:category_name] ).first_or_create( status: 'active' )
		end

		if @article.save
			set_flash 'Article Updated'
			redirect_to edit_writing_admin_path( id: @article.id )
		else
			set_flash 'Article could not be Updated', :error, @article
			render :edit
		end
		
	end


	private
		def article_params
			params.require( :article ).permit( :title, :subtitle, :slug_pref, :description, :content, :category_id, :status, :publish_at, :show_title, :is_commentable, :user_id, :tags, :tags_csv, :avatar, :avatar_asset_file, :avatar_asset_url, :cover_image, :avatar_urls, :redirect_url )
		end

		def get_article
			@article = SwellMedia::Article.friendly.find( params[:id] )
		end

end
