class User < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, presence: true
  validates :name, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # 1対N
  has_many :books
  attachment :profile_image

  def email_required?
    false
  end

  def email_changed?
    false
  end

end
