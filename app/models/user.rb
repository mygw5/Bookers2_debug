class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image

  #フォローをした、されたの関係
  #アソシエーションが繋がっているテーブル名,実際のモデル名,外部キーとして何を持つか
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #一覧で使用
  #架空のテーブル名,中間テーブル名,実際にデータを取得しにいくテーブル名
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #フォローした時の処理
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  #フォローを外す時の処理
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
  #フォローしていればtrueを返す
  def following?(user)
    followings.include?(user)
  end

  #検索方法分岐
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
      #LIKEのあいまい検索構文
    elsif method == 'forward'
      User.where('name LIKE?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

end
