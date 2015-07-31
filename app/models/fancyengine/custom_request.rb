module Fancyengine
  class CustomRequest < ActiveRecord::Base
    serialize :custom_fields, JSON

    after_initialize :_initialize_custom_fields

    validates :description, presence: true

    validate :_custom_fields_is_not_empty

    validate :_custom_fields_are_all_valid

    after_commit :_create_in_fancy_hands

    def cancel
      return false unless key.present?

      response = Client.new.request.post("request/custom/cancel", { key: key })
      response["success"] == true
    end

    def _initialize_custom_fields
      self.custom_fields ||= []
    end

    def _custom_fields_is_not_empty
      if custom_fields.empty?
        errors.add :custom_fields, "can't be empty"
      end
    end

    def _custom_fields_are_all_valid
      _coerced_custom_fields = custom_fields.map { |f| CustomRequestField.new(f.to_hash) }
      if _coerced_custom_fields.any?(&:invalid?)
        messages = {}
        _coerced_custom_fields.each_with_index do |field, index|
          next if field.valid?
          messages[index] = field.errors.full_messages
        end
        errors.add(
          :custom_fields,
          messages.map do |index, full_messages|
            "custom field at index #{index} has errors #{full_messages.join(", ")}."
          end.join(", ")
        )
      end
    end

    def _create_in_fancy_hands
      response = Client.new.request.post("request/custom", _to_fancy_hands_data)
      self.key = response["key"]
      update_column :key, self.key
    end

    def _to_fancy_hands_data
      {
        title: title,
        description: description,
        bid: bid.to_f,
        expiration_date: expiration_date.strftime("%Y-%m-%dT%H:%M:%SZ"),
        custom_fields: custom_fields.map(&:to_hash).to_json
      }
    end

  end
end
