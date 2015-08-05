module Fancyengine
  class CustomRequest < ActiveRecord::Base
    STATUSES = {
      1 => "NEW",
      5 => "OPEN",
      7 => "AWAITING_RESPONSE",
      20 => "CLOSED",
      21 => "EXPIRED"
    }

    serialize :custom_fields, JSON

    serialize :responses, JSON

    serialize :answers, JSON

    serialize :messages, JSON

    serialize :phone_calls, JSON

    belongs_to :requestor, polymorphic: true

    after_initialize :_initialize_custom_fields

    validates :description, presence: true

    validates :numeric_status, inclusion: { in: STATUSES.keys }, allow_nil: true

    validate :_custom_fields_is_not_empty

    validate :_custom_fields_are_all_valid

    before_save :_set_attributes_from_last_response

    before_save :_set_closed_without_answers

    after_commit :post_to_fancyhands, on: [:create]

    # Override this method if you'd like to move the post to Fancy Hands
    # into the background. Redefine #post_to_fancyhands to queue the job
    # in whatever other way you'd prefer.
    def post_to_fancyhands
      post_to_fancyhands_now
    end

    def post_to_fancyhands_now
      return if key.present?

      response = Client.new.create_custom_request(_to_fancy_hands_data)
      self.responses << response
      save
    end

    def cancel
      return false unless key.present?

      Client.new.cancel_custom_request(key)
    end

    def trigger_callback
      return false unless key.present?

      Client.new.trigger_callback(key)
    end

    def status
      return unless numeric_status.present?

      STATUSES[numeric_status]
    end

    def _set_attributes_from_last_response
      sorted_responses = []
      # add the responses that don't have date_updated present to the beginning
      # sorted responses

      sorted_responses += responses.select do |response|
        response["date_updated"].blank?
      end

      sorted_responses += responses.select do |response|
        response["date_updated"].present?
      end.sort_by do |response|
        DateTime.parse(response["date_updated"])
      end

      self.responses = sorted_responses

      return unless last_response = responses.last

      if key.blank?
        raise StandardError, "The last response had a blank key. #{last_response.inspect}" if last_response["key"].blank?
        self.key = last_response["key"]
      end

      if last_response["numeric_status"].present?
        self.numeric_status = Integer(last_response["numeric_status"])
      end

      if last_response["date_created"].present? && !fancyhands_created_at.present?
        self.fancyhands_created_at = DateTime.parse(last_response["date_created"])
      end

      if last_response["date_updated"].present?
        self.fancyhands_updated_at = DateTime.parse(last_response["date_updated"])
      end

      self.answers ||= {}

      Array(last_response["custom_fields"]).each do |custom_field|
        self.answers[custom_field["field_name"]] = custom_field["answer"]
      end

      self.messages = Array(last_response["messages"])

      self.phone_calls = Array(last_response["phone_calls"])

      return true
    end

    def _set_closed_without_answers
      return unless numeric_status == 20

      self.closed_without_answers = answers.values.all?(&:blank?)

      # don't stop the save process
      return true
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
      messages = {}
      custom_fields.map do |f|
        CustomRequestField.new(f.to_hash)
      end.each_with_index do |field, index|
        next if field.valid?
        messages[index] = field.errors.full_messages
      end
      if messages.any?
        errors.add(
          :custom_fields,
          messages.map do |index, full_messages|
            "custom field at index #{index} has errors #{full_messages.join(", ")}."
          end.join(", ")
        )
      end
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
