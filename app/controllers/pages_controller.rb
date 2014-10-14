class PagesController < ApplicationController

def index
  @quotes= [
  ["We owe a lot to Thomas Edison - if it wasn't for him, we'd be watching television by candlelight.", "Milton Berle"],
  ["The higher a monkey climbs, the more you see of its behind.", "Joseph Stilwell"],
  ["I think it's wrong that only one company makes the game Monopoly.", "Steven Wright"]
  ]
end

end
