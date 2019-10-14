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
    if params['ratings'] != nil
      session[:selected_ratings] = params['ratings'].keys
    end

    @all_ratings = ['G','PG','PG-13','R']
    @selected_ratings = ['G','PG','PG-13','R']

    if session[:already_visited]
      @selected_ratings = session[:selected_ratings] || []
    else
      session[:already_visited] = true
    end

    @movies = Movie.all
  end

  def sort_by_title
    flash[:title] = 1
    flash[:date] = 0
    @selected_ratings = session[:selected_ratings] || []
    @all_ratings = ['G','PG','PG-13','R']
    @movies = Movie.order(:title)
    filtered = []
    @movies.each do |movie|
      if @selected_ratings.include?(movie.rating)
        filtered.append(movie)
      end
    end
    @movies = filtered
    render 'index'
  end

  def sort_by_date
    flash[:date] = 1
    flash[:title] = 0
    @selected_ratings = session[:selected_ratings] || []
    @all_ratings = ['G','PG','PG-13','R']
    @movies = Movie.order(:release_date)
    filtered = []
    @movies.each do |movie|
      if @selected_ratings.include?(movie.rating)
        filtered.append(movie)
      end
    end
    @movies = filtered
    render "index"
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
