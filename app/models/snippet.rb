class Snippet < ActiveRecord::Base
  include FindByTenant

  scope :find_by_body_text, ->(query) { joins(:document).where("documents.body LIKE :query", query: "%#{query}%") }

  acts_as_paranoid

  belongs_to :user
  belongs_to :webpage
  belongs_to :document

  accepts_nested_attributes_for :document
end
