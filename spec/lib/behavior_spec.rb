require_relative "../spec_helper"

describe Behavior do
  let(:name) { 'Aggression' }
  let(:key) { 'a' }
  let(:description) { 'Actual or attempted physical contact with another person.' }
  let(:behavior) { Behavior.new(name, key, description) }

  describe ".new" do
    it 'creates a new instance of Behavior' do
      expect(behavior).to be_a(Behavior)
    end

    it 'has 2 required arguments: name and key' do
      expect { Behavior.new(name, key) }.not_to raise_error
    end

    it 'has 1 optional agument: description' do
      expect { Behavior.new(name, key, description) }.not_to raise_error
    end
  end

  describe "#name" do
    it "returns the name of the behavior" do
      expect(behavior.name).to eq(name)
    end
  end

  describe "#key" do
    it "returns the keyboard key that will track that behavior" do
      expect(behavior.key).to eq(key)
    end
  end

  describe "#description" do
    it "returns the description for that behavior" do
      expect(behavior.description).to eq(description)
    end

    it "returns nil if a description is not available" do
      behavior_missing_description = Behavior.new(name, key)

      expect(behavior_missing_description.description).to eq(nil)
    end
  end

  describe "#frequency" do
    it "has a reader for the frequency of the behavior" do
      expect(behavior.frequency).to eq(0)
    end
  end

  describe "#increment" do
    it "increments the frequency by 1 with no arguments" do
      behavior.increment

      expect(behavior.frequency).to eq(1)
    end

    it "increments the frequency by the argument provided" do
      behavior.increment(5)

      expect(behavior.frequency).to eq(5)
    end
  end
end
