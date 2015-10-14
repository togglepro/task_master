module TaskMaster
  class CustomRequestField
    include ActiveModel::Model

    DEFAULT_ATTRIBUTES = { required: false }

    VALID_TYPES = %w(text textarea tel number email money date datetime-local bool checkbox radio)

    TYPES_WITH_OPTIONS = %w(checkbox radio)

    attr_accessor :type, :label, :description, :field_name, :required, :order, :options

    def initialize(attributes = {})
      attributes = attributes.reverse_merge(DEFAULT_ATTRIBUTES)
      super(attributes)
    end

    validates :type, inclusion: { in: VALID_TYPES }

    [:label, :description, :field_name].each do |attribute|
      validates attribute, presence: true
    end

    validates :order, numericality: { greater_than: 0 }

    validates :label, length: { maximum: 30 }

    validates :description, length: { maximum: 300 }

    validates :field_name, length: { maximum: 30 }

    with_options if: -> { TYPES_WITH_OPTIONS.include?(type) } do
      validate do |custom_request_field|
        if Array(options).length < 1
          errors.add :options, "must not be empty"
        end
      end
    end

    def _initialize_required
      self.required = false if self.required.nil?
    end

    def order
      @order.to_s
    end

    def to_hash
      hash = {
        type: type,
        label: label,
        description: description,
        field_name: field_name,
        required: required,
        order: order
      }
      if TYPES_WITH_OPTIONS.include?(type)
        hash[:options] = options
      end
      hash
    end
  end
end
