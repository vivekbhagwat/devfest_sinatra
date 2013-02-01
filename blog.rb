#Devfest blog
#Make directory
#git init
#(sudo) gem install sinatra datamapper erb


#STEP 1
require 'rubygems'
require 'sinatra'
require 'datamapper'
require 'erb'

#Create models 
DataMapper::Setup(:default, "sqlite3://#{Dir.pwd}/blog.db");

#Post
class Post
        include DataMapper::Resource
        property :id, Serial
        property :title, String
        property :body, Text
        property :created_at, DateTime
        
        has n, :comments
end

DataMapper.finalize

Post.auto_upgrade!
# Comment
class Comment
        include DataMapper::Resource
        property :id, Serial
        property :body, Text
        property :created_at, DateTime
        
        belongs_to :post
end

DataMapper.finalize

Comment.auto_upgrade!        


#STEP 2

    get '/hi' do
        "Hello world"
    end


#STEP 3
    get '/' do
    # get the latest 20 posts
        @posts = Post.all(:order => [ :id.desc ], :limit => 20)
        erb :index
    end
    
    get '/post/:id' do
        post = Post.all(:conditions => { :id => params[:id] })
        erb :post, :locals => {:body => post.body, :created_at => post.created_at}
    end
    
#./views/index.html
#<% @posts.each do |post| %>
#    <h3><%= post.title %></h3>
#    <p><%= post.body %></p>
#    <%= link_to "See Comments", @post %>
#<% end %>
    
