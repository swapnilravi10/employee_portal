class Dashboard::PostController < ApplicationController

    skip_before_action :verify_authenticity_token  

    def new_post
        @user = User.find(params[:user])
        @post = Post.new
        @post_attachment = @post.post_attachments.build
        respond_to do |format|
            format.js {render 'new_post.js.erb'}
        end
    end

    def create
        @post = Post.new(new_post_params)
        if new_post_params[:post].blank? and params[:post_attachments].blank?
            redirect_to :controller=> '/dashboard/admin',:action => 'index' and return
        end
        if @post.valid?
            if @post.save
                if params[:post_attachments]
                    params[:post_attachments]['post_image'].each do |a|
                        @post_attachment = @post.post_attachments.create!(:post_image => a, :post_id => @post.id)
                    end
                end
                flash.notice = "Successfully added new post"
                redirect_to :controller=> '/dashboard/admin',:action => 'index'
            else
                flash.now[:alert] = "There was some problem adding post"
                redirect_to :controller=> '/dashboard/admin',:action => 'index'
            end
            
        else
            flash.now[:alert] = @post.errors.full_messages[0]
            redirect_to :controller=> '/dashboard/admin',:action => 'index'
        end
    end
    def new_post_params
        params.require(:post).permit(:post, :user_id, post_attachments_attributes: [:post_image])
    end

    def edit
        @post = Post.find(params[:id])
        @user = User.find(@post.user_id)
        respond_to do |format|
            format.js {render 'edit_post.js.erb'}
        end
    end

    def update
        @post = Post.find(params[:id])
        @user = User.find(@post.user_id)
        if @post.update(post_params)
            @post.save
            flash.notice = "Successfully added new post"
            redirect_to :controller=> '/dashboard/admin',:action => 'index'
        else
            flash.now[:alert] = @post.errors.full_messages[0]
            redirect_to :controller=> '/dashboard/admin',:action => 'index'
        end

    end
    def post_params
        params.require(:post).permit(:post, :user_id)
    end

    def destroy
        Post.find(params[:id]).destroy
        flash.notice = "Post was successfully deleted"
        redirect_to :controller=> '/dashboard/admin',:action => 'index'
    end

    def post_like
        @post_liked = PostLike.find_by(:post_id=> params[:post], :user_id=> params[:user])
        @post = Post.find(params[:post])
        @posts = Post.order("created_at DESC")
        @current_user = User.find(params[:user])
        if @post_liked.blank?
            new_post = PostLike.new
            new_post.post_id = params[:post]
            new_post.user_id =  params[:user]
            new_post.save()
            @post.like = @post.like.to_i + 1
            @post.save()
            
        else
            @post_liked.delete
            if @post.like.to_i != 0
                @post.like = @post.like.to_i - 1    
                @post.save()
            end  
        end
        # redirect_to :controller=> '/dashboard/admin',:action => 'index'
        respond_to do |format|
            format.js {render '/dashboard/admin/post_section.js.erb'}
        end
    end

    def new_comment
        @comment = Comment.new(new_comment_params)
        if @comment.valid?
            @comment.save
            # flash.notice = "Successfully added new post"
            redirect_to :controller=> '/dashboard/admin',:action => 'index'
            # respond_to do |format|
            #     format.js {render '/dashboard/admin/post_section.js.erb'}
            # end
        else
            flash.now[:alert] = @comment.errors.full_messages[0]
            redirect_to :controller=> '/dashboard/admin',:action => 'index'
        end

    end

    def new_comment_params
        params.require(:comment).permit(:comment, :post_id, :user_id)
    end

    def delete_comment
        Comment.find(params[:id]).delete
        # redirect_to :controller=> '/dashboard/admin',:action => 'index'
        @posts = Post.order("created_at DESC")
        respond_to do |format|
            format.js {render '/dashboard/admin/post_section.js.erb'}
        end
    end
end
