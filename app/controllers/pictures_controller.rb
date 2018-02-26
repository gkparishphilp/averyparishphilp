
class PicturesController < ApplicationController


	def index
		@tagged = params[:tagged]
		
		@category = PictureCategory.friendly.find( params[:category] || params[:cat] ) if ( params[:category] || params[:cat] ).present?

		@title = @category.try(:name)
		@title ||= "Pictures"

		@pictures = Picture.active.order( publish_at: :desc )
		@pictures = @pictures.where( category_id: @category.id ) if @category.present?
		@pictures = @pictures.with_any_tags( @tagges ) if @tagged.present?

		user_level = User.roles[current_user.try( :role )] || 0

		@pictures = @pictures.where( "availability <= :level", level: user_level )

		# set count before pagination
		@count = @pictures.count

		@pictures = @pictures.page( params[:page] )

		set_page_meta title: @title, og: { type: 'blog' }, twitter: { card: 'summary' }
	end


	def show
		@user_level = User.roles[current_user.try( :role )] || 0

		@pictures = Picture.where( "availability <= :level", level: @user_level )

		@picture = @pictures.friendly.find( params[:id] )

		
	end

end