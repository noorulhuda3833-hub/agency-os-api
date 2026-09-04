class Note < ApplicationRecord
  belongs_to :client
  has_many_attached :files
  
  validates :title, presence: true
  validates :content, presence: true

  validates :note_type, presence: true, inclusion: { in: %w[meeting call email task general] }
end
