# Mongoid::Cloneable

[![build status][1]][2]

[1]: https://travis-ci.org/dtmtec/mongoid_cloneable.png
[2]: http://travis-ci.org/dtmtec/mongoid_cloneable

git remote add origin https://github.com/dtmtec/mongoid_cloneable.git
git push -u origin master

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_cloneable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_cloneable

## Usage

Include `Mongoid::Cloneable` in your document and configure it with `cloneable`:

    class MyDocument
      include Mongoid::Document
      include Mongoid::Cloneable

      # whitelisting
      cloneable include: [ :foo, :bar ]

      # or

      # blacklisting
      cloneable exclude: [ :xyz, :fuzz ]
    end

Then when calling `clone` it will include or exclude the specified attributes or relations.

__Mongoid__ already clones all attributes and embedded associations. If you opt to use include, then everything else will not be cloned. If you opt to use exclude it will only exclude those attributes or relations.

When it is including referenced has_many or has_one relationships it will call clone on the referenced documents, thus creating copies of them and referencing those.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
