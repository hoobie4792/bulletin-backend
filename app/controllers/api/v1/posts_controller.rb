class Api::V1::PostsController < ApplicationController
  
  before_action :authenticate, :only => [:index, :show, :create, :destroy]

  def index
    if current_user
      posts = Post.get_posts_for_user(current_user)
    else
      posts = Post.get_default_posts
    end
    render :json => Post.serialized_posts(posts), :status => :ok
  end

  def show
    post = Post.find_by(id: params[:id])
    user = post.user
    if user.is_private && current_user 
      if !user.followers.include? current_user
        render :json => { message: 'Private account' }, :status => :unauthorized
        return
      end
    end
    render :json => post.serialized, :status => :ok
  end

  def create
    if current_user
      post = Post.new(content: post_params[:content])
      post.user = current_user
      if post.save
        post.current_user = current_user
        post.create_notifications
        post_params[:tags].each do |t| 
          tag = Tag.find_by(name: t.downcase)
          if !tag
            tag = Tag.create(name: t.downcase)
          end
          PostTag.create(post: post, tag: tag)
        end
        render :json => post.serialized, :status => :ok
      else
        render :json => { message: 'Could not create post' }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to create post' }, :status => :unauthorized
    end
  end

  def create_shared_post
    if current_user
      if shared_post_params[:shared_post][:id]
        shared_post = Post.find_by(id: shared_post_params[:shared_post][:id])
      else
        shared_post = Post.create(shared_post_params[:shared_post].except(:id))
      end
      post = Post.new(content: shared_post_params[:content])
      post.user = current_user
      if post.save
        post.current_user = current_user
        post.create_notifications
        Share.create(parent_post: post, shared_post: shared_post)
        shared_post_params[:tags].each do |t| 
          tag = Tag.find_by(name: t.downcase)
          if !tag
            tag = Tag.create(name: t.downcase)
          end
          PostTag.create(post: post, tag: tag)
        end
        
        render :json => post.serialized, :status => :ok
      else
        render :json => { message: 'Could not create post' }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to share post' }, :status => :unauthorized
    end
  end

  def update
    if current_user
      post = Post.find_by(id: params[:id])
      if post.user == current_user && post.update(post_params)
        render :json => post.serialized, :status => :ok
      else
        render :json => { message: 'Could not update post' }, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to update post' }, :status => :unauthorized
    end
  end

  def destroy
    if current_user
      post = Post.find_by(id: params[:id])
      if post.user == current_user && post.destroy
        render :json => true, :status => :ok
      else
        render :json => false, :status => :bad_request
      end
    else
      render :json => { message: 'Must be logged in to delete post' }, :status => :unauthorized
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :tags => [])
  end

  def shared_post_params
    params.require(:shared_post).permit(:content, :tags => [], :shared_post => [
      :id, :content, :created_at, :news_author, :news_image, :news_source, :news_title, :news_url, :is_news_story
    ])
  end

end
