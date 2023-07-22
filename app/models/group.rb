class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :group_users

  has_one_attached :image
  validates :name, presence: true
  validates :introduction, presence: true

  def is_owned_by?(user)
      owner.id==user.id
  end

  def get_image
    (image.attached?) ? image : 'no_image.jpg'
  end

end
