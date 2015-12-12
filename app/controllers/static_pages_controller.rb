class StaticPagesController < ApplicationController
  def home
  	@tweet = current_user.tweets.build if logged_in?
  	@tweet_items = current_user.feed.paginate(page: params[:pge])
  end

  def help
  end
end
