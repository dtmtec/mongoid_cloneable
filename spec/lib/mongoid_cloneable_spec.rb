require "spec_helper"

describe Mongoid::Cloneable do
  let(:cloneable) { Person.new }
  let(:cloner) { double(Mongoid::Cloneable::DocumentCloner) }

  it "clones the document" do
    expect(Mongoid::Cloneable::DocumentCloner).to receive(:new)

    cloneable.clone
  end
end
