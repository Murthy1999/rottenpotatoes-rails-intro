class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']

    if params['ratings'] != nil
      puts "Here-1"
      puts params['ratings']
      @selected_ratings = session[:selected_ratings] = params['ratings'].keys
    elsif session[:is_redirect]
      puts 'a'
      @selected_ratings = session[:selected_ratings]
      
      if session[:sort_by_title]
        @movies = Movie.order :title
      elsif session[:sort_by_date]
        @movies = Movie.order :release_date
      else

      end
    else
      puts 'b'
      @selected_ratings = ['G','PG','PG-13','R']
    end

    if @movies == nil
      @movies = Movie.all
    end

  end

  # flash[:title] = 1
  # flash[:date] = 0
  # @movies = Movie.order(:title)
  # filtered = []
  # @movies.each do |movie|
  #   if @selected_ratings.include?(movie.rating)
  #     filtered.append(movie)
  #   end
  # end
  # @movies = filtered

  def sort_by_title
    session[:is_redirect] = true
    session[:sort_by_title] = true
    redirect_to movies_path
  end

  def sort_by_date
    session[:is_redirect] = true
    session[:sort_by_date] = true
    redirect_to movies_path
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
