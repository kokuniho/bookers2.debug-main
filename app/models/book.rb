class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :tagmaps, dependent: :destroy
  has_many :tags, through: :tagmaps
  scope :latest, -> {order(created_at: :desc)}
# 　scope :evaluate, -> {order(evaluation: :DESC)}

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(search, word, method)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end


   #検索メソッド、タイトルと内容をあいまい検索する
 def self.books_serach(search)
   Book.where(['title LIKE ? OR content LIKE ?', "%#{search}%", "%#{search}%"])
 end

 def save_books(tags)
   current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
   old_tags = current_tags - tags
   new_tags = tags - current_tags

   # Destroy
   old_tags.each do |old_name|
     self.tags.delete Tag.find_by(tag_name:old_name)
   end

   # Create
   new_tags.each do |new_name|
     book_tag = Tag.find_or_create_by(tag_name:new_name)
     self.tags << book_tag
   end
 end



end