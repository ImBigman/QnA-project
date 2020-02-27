class Link < ApplicationRecord
  default_scope { order(name: :asc).order(:created_at) }

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url,
                      with: %r{(http|https)://[a-zA-Z0-9\-\#/\_]+[\.][a-zA-Z0-9\-\.\#/\_]+}i,
                      on: :create,
                      message: 'please enter URL in correct format'

  def gist?
    url.include? 'https://gist.github.com/'
  end
end
