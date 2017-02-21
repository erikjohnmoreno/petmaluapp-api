class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_secure_token
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :conversations
  has_many :messages
  has_many :inverse_conversations, :class_name => 'Conversation', :foreign_key => 'receiver_id'
end
