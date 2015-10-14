module TaskMaster
  RSpec.describe CustomRequestField do

    it "has a type attribute" do
      subject.type = "text"
      expect(subject.type).to eq "text"
    end

    it "validates that the type is one of the supported types" do
      %w(text textarea tel number email money date datetime-local bool checkbox radio).each do |type|
        subject.type = type
        subject.valid?
        expect(subject.errors[:type]).to be_empty
      end
      %w(ham egg cheese bologna).each do |type|
        subject.type = type
        subject.valid?
        expect(subject.errors[:type]).to include "is not included in the list"
      end
    end

    ["checkbox", "radio"].each do |type_with_options|
      context "when the type is #{type_with_options}" do
        before do
          subject.type = type_with_options
        end
        it "validates that the options are set if the type is checkbox" do
          subject.options = nil
          subject.valid?
          expect(subject.errors[:options]).to include "must not be empty"
        end
        it "includes the options when serialized" do
          subject.options = ["foo", "bar"]
          expect(subject.to_hash[:options]).to eq subject.options
        end
      end
    end

    it "has a label attribute" do
      label = "What did the person sound like?"
      subject.label = label
      expect(subject.label).to eq label
    end

    it "validates that the label is present" do
      subject.label = nil
      subject.valid?
      expect(subject.errors[:label]).to include "can't be blank"
    end

    it "validates that the label is 30 or fewer characters" do
      subject.label = "-" * 31
      subject.valid?
      expect(subject.errors[:label]).to include "is too long (maximum is 30 characters)"
    end

    it "validates that the description is 300 or fewer characters" do
      subject.description = "-" * 301
      subject.valid?
      expect(subject.errors[:description]).to include "is too long (maximum is 300 characters)"
    end

    it "has a description attribute" do
      description = "In other words, were they nice?"
      subject.description = description
      expect(subject.description).to eq description
    end

    it "validates that the description is present" do
      subject.description = nil
      subject.valid?
      expect(subject.errors[:description]).to include "can't be blank"
    end

    it "has a field_name attribute" do
      field_name = "person_sounds_like"
      subject.field_name = field_name
      expect(subject.field_name).to eq field_name
    end

    it "validates that the field_name is 30 or fewer characters" do
      subject.field_name = "-" * 31
      subject.valid?
      expect(subject.errors[:field_name]).not_to be_empty
    end

    it "validates that the field_name is present" do
      subject.field_name = nil
      subject.valid?
      expect(subject.errors[:field_name]).to include "can't be blank"
    end

    it "has a required attribute that's a boolean that initializes to false" do
      expect(subject.required).to eq false
    end

    it "can set the required attribute to true" do
      subject = described_class.new(required: true)
      expect(subject.required).to eq true
    end

    it "has an order attribute" do
      order = 1
      subject.order = order
      expect(subject.order).to eq "1"
    end

    it "validates that the order evaluates to an integer greater than 0" do
      [-1,0,"-1"].each do |invalid_order|
        subject.order = invalid_order
        subject.valid?
        expect(subject.errors[:order]).to include "must be greater than 0"
      end
      [1,"1"].each do |valid_order|
        subject.order = valid_order
        subject.valid?
        expect(subject.errors[:order]).to be_empty
      end
    end

    it "can serialize into a hash" do
      subject = FactoryGirl.build(:task_master_custom_request_field)
      expect(subject.to_hash).to eq({
        type: subject.type,
        label: subject.label,
        description: subject.description,
        field_name: subject.field_name,
        required: subject.required,
        order: subject.order
      })
    end
  end
end
