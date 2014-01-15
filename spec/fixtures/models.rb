class Car
  include Mongoid::Document
  include Mongoid::Cloneable

  belongs_to :person
  has_many :parts
  embeds_many :tires

  field :brand
end

class Tire
  include Mongoid::Document
  include Mongoid::Cloneable

  field :brand
end

class Part
  include Mongoid::Document
  include Mongoid::Cloneable

  belongs_to :car

  field :name
end

class Person
  include Mongoid::Document
  include Mongoid::Cloneable

  has_and_belongs_to_many :books, inverse_of: :people
  has_and_belongs_to_many :favorite_books, class_name: 'Book', inverse_of: :favorited_by
  has_many :authored_books, class_name: 'Book', inverse_of: :author
  has_one :top_book, class_name: 'Book', inverse_of: :top_of

  has_many :cars

  cloneable include: [:name, :authored_books, :favorite_books, :top_book]

  field :name, type: String
  field :birthdate, type: Date
end

class Book
  include Mongoid::Document
  include Mongoid::Cloneable

  embeds_many :pages
  embeds_one :front_page, class_name: 'Page', autobuild: true
  belongs_to :author, class_name: 'Person', inverse_of: :authored_books
  belongs_to :top_of, class_name: 'Person', inverse_of: :top_book

  has_and_belongs_to_many :people, inverse_of: :books
  has_and_belongs_to_many :favorited_by, class_name: 'Person', inverse_of: :favorite_books

  cloneable exclude: [:description, :pages]

  field :name
  field :description
end

class Page
  include Mongoid::Document
  include Mongoid::Cloneable

  embedded_in :book

  cloneable exclude: :number

  field :body
  field :number
end
