class ContentItem < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  acts_as_paranoid

  belongs_to :creator, class_name: "User"
  belongs_to :updated_by, class_name: "User"
  belongs_to :content_type
  has_many :field_items, -> { joins(:field).order("fields.order ASC") }, dependent: :destroy, autosave: true
  has_one :publish_state

  accepts_nested_attributes_for :field_items
  accepts_nested_attributes_for :publish_state

  validates :creator_id, :content_type_id, presence: true

  after_save :index
  after_save :update_tag_lists

  def self.taggable_fields
    taggable_on_array = Field.select { |field| field.field_type_instance.is_a?(TagFieldType) }.map { |field_item| field_item.name.parameterize('_') }
  end

  # The following method (#author_image) is currently faked
  # author_image is faked pending being able to reference the specific User object (ex:
  # content_item.author.user_image)

  def author_image
    "<img src='https://robohash.org/#{id}.png' height='100' width='100'/>".html_safe
  end

  def get_publish_state
    publish_state.try(:state) || 'Draft'
  end

  # The Method self.taggable_fields must always be above the acts_as_taggable_on inclusion for it.
  # Due to lack of hoisting - it cannot access the method unless the method appears before it in this
  # file.

  acts_as_taggable_on taggable_fields

  def as_indexed_json(options = {})
    json = as_json
    # json[:tenant_id] = TODO

    field_items.each do |field_item|
      field_type = field_item.field.field_type_instance(field_name: field_item.field.name)
      json.merge!(field_type.field_item_as_indexed_json_for_field_type(field_item))
    end

    json
  end

  def index
    __elasticsearch__.client.index(
      {index: content_type.content_items_index_name,
       type: self.class.name.parameterize('_'),
       id: id,
       body: as_indexed_json}
    )
  end

  def tag_field_items
    field_items.select { |field_item| field_item.field.field_type_instance.is_a?(TagFieldType) }
  end

  def update_tag_lists
    tag_data = tag_field_items.map { |field_item| {tag_name: field_item.field.name, tag_list: field_item.data["tag_list"]} }

    tag_data.each do |tags|
      ContentItemService.update_tags(self, tags)
    end
  end
end
