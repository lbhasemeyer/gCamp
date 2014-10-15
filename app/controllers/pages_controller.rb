class PagesController < ApplicationController

def index

  quote1 = Quote.new
  quote1.text = "We owe a lot to Thomas Edison - if it wasn't for him, we'd be watching television by candlelight."
  quote1.author = "Al Boliska"

  quote2 = Quote.new
  quote2.text = "The higher a monkey climbs, the more you see of its behind."
  quote2.author = "Joseph Stilwell"

  quote3 = Quote.new
  quote3.text = "I think it's wrong that only one company makes the game Monopoly."
  quote3.author = "Steven Wright"

@quotes= [quote1, quote2, quote3]

end

end
