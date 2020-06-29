class AddNewsColumnsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :news_author, :string
    add_column :posts, :news_image, :string
    add_column :posts, :news_source, :string
    add_column :posts, :news_title, :string
    add_column :posts, :news_url, :string
    add_column :posts, :is_news_story, :boolean, :default => :false
  end
end
