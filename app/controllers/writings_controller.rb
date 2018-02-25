
class WritingsController < ApplicationController


	def index
		@tagged = params[:tagged]
		
		@category = SwellMedia::Category.friendly.find( params[:category] || params[:cat] ) if ( params[:category] || params[:cat] ).present?

		@title = @category.try(:name)
		@title ||= "Writings"

		@articles = SwellMedia::SearchService.search( SwellMedia::Article, category: @category, tags: @tagged )

		user_level = User.roles[current_user.try( :role )] || 0

		@articles = @articles.where( "availability <= :level", level: user_level )

		# set count before pagination
		@count = @articles.count

		@articles = @articles.page( params[:page] )

		set_page_meta title: @title, og: { type: 'blog' }, twitter: { card: 'summary' }
	end


	def show
		user_level = User.roles[current_user.try( :role )] || 0

		@articles = SwellMedia::Article.where( "availability <= :level", level: user_level )

		@article = @articles.friendly.find( params[:id] )

		
	end

end