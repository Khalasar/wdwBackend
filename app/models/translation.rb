class Translation < ActiveRecord::Base
  belongs_to :place
  validates :language, presence: true, unless: :title_empty?

  def title_empty?
    title.empty?
  end
end
