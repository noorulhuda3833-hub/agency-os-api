class BriefingDocument < ApplicationRecord
  belongs_to :client

  validates :client, presence: true
  validates :content, presence: true
end
