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


def faq
  faq1 = Faq.new
  faq1.question = "What is gCamp?"
  faq1.answer = "gCamp is an awesome tool that is going to change your life.  gCamp is your one-stop shop to organize all your tasks and documents.  You'll also be able to track comments that you and others make.  gCamp may eventually replace all need for paper and pens in the entire world.  Well, maybe not, but it's going to be pretty cool."

  faq2 = Faq.new
  faq2.question = "How do I join gCamp?"
  faq2.answer = "Right now, gCamp is still in production.  So, there is not a sign-up page open to the public, yet!  Your best option is to become super best friends with a gCamp developer.  They can be found hanging around gSchool during the day and hitting the hottest clubs at night."

  faq3 = Faq.new
  faq3.question = "When will gCamp be finished?"
  faq3.answer = "gCamp is a work in progress.  That being said, it should be fully functional by December 2014.  Functional, but our developers are going to continue to improve the sight for the forseeable future.  Check in daily for new features and awesome functionality.  It's going to blow your mind.  Organization is only (well, will only be) a click away.  Amazing!"

@faqs= [faq1, faq2, faq3]
end


end
