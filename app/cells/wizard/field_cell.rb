module Wizard
  class FieldCell < Cell::ViewModel
    property :id
    property :label
    property :input
    property :display_format

    def show
      render
    end

    private

    def check_format
      display_format
    end

    def field_item
      context[:content_item].field_items.select { |field_item| field_item.field_id == id }[0]
    end

    def field
      ::Field.find_by_id(id)
    end

    def field_type
      field.field_type_instance
    end
  end
end
