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
begin
  doc = Nokogiri::HTML(open(ARGV[0]))
rescue SocketError => msg
  puts msg
  exit
end

# Set post attributes
begin
  post.title = doc.search('td.title > a')[0].inner_text
rescue
  puts "Are you sure this is a HackerNews post?"
  exit
end

## Get comments
doc.search('.athing').map do |thing|
  comment = Comment.new
  comment.user = thing.search('.comhead > a')[0].inner_text
  comment.text = thing.search('.comment > span').map { |tag| tag.inner_text }
  post.comments << comment
end

puts "Post title: #{post.title.colorize(:blue)}"
puts "Number of comments: #{post.comments.count.to_s.colorize(:blue)}"

