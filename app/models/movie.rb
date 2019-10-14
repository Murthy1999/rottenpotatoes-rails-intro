class Movie < ActiveRecord::Base

  def get_ordered_by(attribute, ratings)
    found = []
    Movie.order(attribute).each do |movie|
      found.append movie if ratings.include? movie.rating
    end
    found
  end

end
