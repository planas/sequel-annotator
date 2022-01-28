# frozen_string_literal: true

require 'terminal-table'

module Sequel
  class Annotator
    ANNOTATION_RE = /^#\s[\+\|].+[\+\|]\n/

    def initialize(model, paths, root = nil)
      @model = model
      @paths = paths
      @root  = root
    end

    def annotate
      @annotated_files = []

      @paths.each do |path, block|
        name  = block.call(@model)
        file  = File.join(File.expand_path(path, @root), name)
        table = self.class.schema_table(@model)

        if write_annotations(file, table)
          @annotated_files << file
        end
      end

      @annotated_files
    end

    def write_annotations(file, annotations)
      if File.exists?(file)
        content = File.read(file)
        if content.scan(ANNOTATION_RE).join != annotations
          File.open(file, "wb") do |f|
            current = content.gsub(ANNOTATION_RE, '').gsub(/\A\s+/, '')
            f.write([annotations, current].join("\n"))
          end
        end
      end
    end

    def self.schema_table(model)
      table_name = model.table_name
      foreign_keys = model.db.foreign_key_list(table_name).map { |x| x[:columns] }.flatten

      table = Terminal::Table.new
      table.title = table_name
      table.headings = ["Column", "Ruby Type", "DB Type", "Default", "Null?", "PK?", "FK?"]

      table.rows = model.db_schema.map do |key, value|
        [
          key,
          value[:type],
          value[:db_type],
          value[:ruby_default].nil? ? '-' : value[:ruby_default],
          value[:allow_null]  ? 'Y' : 'N',
          value[:primary_key] ? 'Y' : 'N',
          foreign_keys.include?(key) ? 'Y' : 'N'
        ]
      end

      # Align to the center the columns: Default, Null?, PK? and FK?
      for i in 3..6
        table.align_column(i, :center)
      end

      table.to_s.each_line.map { |line| "# #{line}" }.join + "\n"
    end
  end
end
