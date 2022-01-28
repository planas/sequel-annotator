# frozen_string_literal: true

require 'sequel'
require 'sqlite3'
require 'fileutils'

RSpec.describe Sequel::Annotator do
  let(:db) { Sequel.sqlite }
  let(:model_name) { 'Items' }
  let(:model) do
    Class.new(Sequel::Model(:items)) do
      def self.to_s
        "Item"
      end
    end
  end

  let(:fixtures) { File.expand_path('../fixtures', __dir__) }
  let(:tmp) { Pathname.new(File.expand_path('../tmp', __dir__)) }
  let(:paths) do
    Hash[
      'models'         => proc { |m| "#{m.to_s.demodulize.underscore}.rb" },
      'spec/models'    => proc { |m| "#{m.to_s.demodulize.underscore}_spec.rb" },
      'spec/factories' => proc { |m| "#{m.to_s.demodulize.pluralize.underscore}.rb" }
    ]
  end

  let(:annotator) { Sequel::Annotator.new(model, paths, tmp) }
  let(:schema_table) do
    <<~RUBY
    # +------------------------------------------------------------------------------------+
    # |                                       items                                        |
    # +-----------------------+-----------+------------------+---------+-------+-----+-----+
    # | Column                | Ruby Type | DB Type          | Default | Null? | PK? | FK? |
    # +-----------------------+-----------+------------------+---------+-------+-----+-----+
    # | id                    | integer   | integer          |    -    |   N   |  Y  |  N  |
    # | category_id           | integer   | integer          |    -    |   N   |  N  |  Y  |
    # | manufacturer_name     | string    | varchar(50)      |    -    |   Y   |  N  |  Y  |
    # | manufacturer_location | string    | varchar(255)     |    -    |   Y   |  N  |  Y  |
    # | name                  | string    | varchar(255)     |   Car   |   Y   |  N  |  N  |
    # | price                 | float     | double precision |   0.0   |   Y   |  N  |  N  |
    # +-----------------------+-----------+------------------+---------+-------+-----+-----+
    RUBY
  end

  Sequel.extension :inflector

  before do
    db.create_table :items do
      primary_key :id
      foreign_key :category_id, :categories, null: false
      foreign_key [:manufacturer_name, :manufacturer_location], :manufacturers

      String :manufacturer_name, size: 50
      String :manufacturer_location
      String :name, default: "Car"
      Float  :price, default: 0
    end
  end

  describe "#annotate" do
    around do |example|
      FileUtils.cp_r(fixtures, tmp)
      example.run
      FileUtils.rm_r(tmp)
    end

    it "should inject the annotation to each file" do
      annotator.annotate
      expect(tmp.join('models/item.rb').read).to eq(
        schema_table + <<~RUBY

        class Item < Sequel::Model
        end
        RUBY
      )
    end

    it "should replace an existing annotation to each file" do
      annotator.annotate
      expect(tmp.join('spec/factories/items.rb').read).to eq(
        schema_table + <<~RUBY

        FactoryBot.define do
          factory :item do
            name { "car" }
          end
        end
        RUBY
      )
    end

    it "should remove excess whitespace at the start of the file" do
      annotator.annotate
      expect(tmp.join('spec/models/item_spec.rb').read).to eq(
        schema_table + <<~RUBY

        RSpec.describe Item do
        end
        RUBY
      )
    end

    it "should return an array of annotated files" do
      #expect(annotator.annotate).to eq paths.map { |path, prc| path.join(prc.call(model)).to_s }
    end
  end

  describe "#schema_info" do
    it "should return the model schema" do
      expect(Sequel::Annotator.schema_table(model)).to eq schema_table
    end
  end

  it "has a version number" do
    expect(Sequel::Annotator::VERSION).not_to be nil
  end
end