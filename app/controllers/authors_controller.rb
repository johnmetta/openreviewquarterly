class AuthorsController < ApplicationController
  before_filter :authenticate_admin!, :only => [:new,:edit,:create,:destroy,:update]
  def show
    if params[:author_name]
      @author=get_author_from_name(params[:author_name])
    else
      @author=Author.find(params[:id])
    end
    @pieces=@author.pieces.joins(:issue).where({:issues => {:is_published => true}}).sort_by{|p| p.issue.number}.reverse
  end

  def new
    @author=Author.new
  end

  def edit
    @author=Author.find(params[:id])
  end

  def create
    saved=Author.new(params[:author]).save()
    if saved
      redirect_to '/authors/all'
    else #form had errors
      render :acion=>'new'
    end
  end

  def update
    @author=Author.find(params[:id])
    saved=@Author.update_attributes(params[:author])
    if saved
      redirect_to "/authors/#{@author.id}"
    else
      redirect_to "/authors/#{@author.id}/edit"
    end
  end

  
  def destroy
    Author.find(params[:id]).delete
  end
    
  def all
    @authors=Author.all
  end
  
end