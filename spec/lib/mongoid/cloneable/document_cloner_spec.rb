require "spec_helper"

describe Mongoid::Cloneable::DocumentCloner do
  let(:books) { [Book.new(name: 'Some book'), Book.new(name: 'other book')] }
  let(:authored_books) { [Book.new(name: 'Some authored book'), Book.new(name: 'other authored book')] }
  let(:favorite_books) { [Book.new(name: 'Some favorite book'), Book.new(name: 'other favorite book')] }
  let(:top_book) { Book.new(name: 'Lords of the rings') }

  let(:cloneable) do
    Person.new({
      name: 'Tyrion',
      birthdate: 33.years.ago.to_date,
      books: books,
      authored_books: authored_books,
      favorite_books: favorite_books,
      top_book: top_book
    })
  end

  let(:cloned_document) do
    cloneable.clone
  end

  subject(:cloner) { described_class.new(cloneable, cloned_document) }

  context "when no cloneable configuration is set" do
    let(:cloneable) { Car.new(brand: 'BMW', tires: [Tire.new] * 4, person: Person.new) }

    it "changes the clone id" do
      expect(cloner.cloned_document.id).to_not eq(cloneable.id)
    end

    it "clones the attributes" do
      expect(cloner.cloned_document.brand).to eq(cloneable.brand)
    end

    it "clones the embedded associations" do
      expect(cloner.cloned_document.tires.size).to eq(cloneable.tires.size)
    end

    it "doesn't clone has many relationships" do
      expect(cloner.cloned_document.parts.size).to eq(0)
    end
  end

  context "when it is configured to include attributes or relations" do
    it "clones only the included attributes" do
      expect(cloner.cloned_document.name).to eq(cloneable.name)
      expect(cloner.cloned_document.birthdate).to be_nil
    end

    it "won't clone has_* relationships that were not especified" do
      expect(cloner.cloned_document.books).to be_empty
    end

    it "won't even clone has_* relationship ids that were not especified" do
      expect(cloner.cloned_document.book_ids).to be_empty
    end

    it "clones specified has_many relationships" do
      expect(cloner.cloned_document.authored_books.size).to eq(cloneable.authored_books.size)
    end

    it "calls clone on each value of a has_many relationship" do
      authored_books.each { |book| expect(book).to receive(:clone).at_least(:once) }
      cloner.cloned_document
    end

    it "clones specified has_one relationship" do
      expect(cloner.cloned_document.top_book.name).to eq(cloneable.top_book.name)
    end

    it "calls clone on the has one relationship, cloning it too" do
      expect(top_book).to receive(:clone).at_least(:once)
      cloner.cloned_document
    end

    it "clones ids of has_and_belongs_to_many relationships" do
      expect(cloner.cloned_document.favorite_book_ids).to eq(cloneable.favorite_book_ids)
    end

    it "properly configures has_and_belongs_to_many relationships" do
      cloner.cloned_document

      favorite_books.each do |book|
        expect(book.favorited_by_ids).to include(cloner.cloned_document.id)
      end
    end
  end

  context "when it is configured to exclude some attributes or relations" do
    let(:author) { Person.new name: "George R. R. Martin" }
    let(:pages) { [Page.new(body: 'some')] * 4 }
    let(:front_page) { Page.new(body: 'A song of fire') }
    let(:people) { [Person.new] * 3 }

    let(:cloneable) do
      Book.new(name: 'Game of Thrones', description: 'A book about kings', author: author, pages: pages, front_page: front_page, people: people )
    end

    it "clones attributes that were not excluded" do
      expect(cloner.cloned_document.name).to eq(cloneable.name)
    end

    it "won't clone attributes that were excluded" do
      expect(cloner.cloned_document.description).to be_nil
    end

    it "clones belongs_to relationship" do
      expect(cloner.cloned_document.author_id).to eq(author.id)
    end

    it "won't clone has_* relationships" do
      expect(cloner.cloned_document.people).to be_empty
    end

    it "clones embedded relationships that were not excluded" do
      expect(cloner.cloned_document.front_page.body).to eq(cloneable.front_page.body)
    end
  end
end
