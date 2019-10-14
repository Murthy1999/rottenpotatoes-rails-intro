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
    puts params
    @all_ratings = ['G','PG','PG-13','R']
    @selected_ratings = ['G','PG','PG-13','R']
    if params['ratings']
      puts 'params ratings present'
      session[:selected_ratings] = params['ratings']
      @selected_ratings = params['ratings']
    elsif session[:selected_ratings]
      puts 'session ratings present'
      @selected_ratings = session[:selected_ratings]
    end


    if params['order_by'] == 'title' or session[:order_by] == :title
      puts 1
      flash[:title] = 1
      flash[:release_date] = 0
      @movies = Movie.order(:title)
    elsif params['order_by'] == 'release_date'
      puts 2
      flash[:title] = 0
      flash[:release_date] = 1
      @movies = Movie.order(:release_date)
    else
      puts 3
      @movies = Movie.all
    end

    puts "params are"
    puts params

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
    session[:order_by] = :title
    redirect_to movies_path(:order_by => 'title', :ratings => session[:selected_ratings])
  end

  def sort_by_date
    redirect_to movies_path(:order_by => 'release_date')
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
