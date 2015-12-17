require 'nokogiri'
require 'open-uri'
require './lib/post'
require './lib/comment'
require 'colorize'

unless ARGV.length == 1
  puts "Usage: ruby hn_scraper.rb input-uri\n"
  exit
end

# Instantiate post object
post = Post.new
post.url = ARGV[0]
post.item_id = ARGV[0].split('id=')[1]

# Retrieve web page
doc = Nokogiri::HTML(open(ARGV[0]))

# Set post attributes
post.title = doc.search('td.title > a')[0].inner_text #.map { |link| link.inner_text}

## Get comments
doc.search('.athing').map do |thing|
  comment = Comment.new
  comment.user = thing.search('.comhead > a')[0].inner_text
  comment.text = thing.search('.comment > span').map { |tag| tag.inner_text }
  post.comments << comment
end

puts "Post title: #{post.title.colorize(:blue)}"
puts "Number of comments: #{post.comments.count.to_s.colorize(:blue)}"

