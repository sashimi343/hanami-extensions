# frozen_string_literal: true
require "csv"
require "hanami/utils"
require_relative "./project"

module Hanami
  module Extensions
    class Seeder
      DEFAULT_CSV_OPTIONS = { headers: true, converters: :integer }.freeze

      attr_accessor :options, :fixtures_directory

      def initialize(options = DEFAULT_CSV_OPTIONS)
        @options = options
        @fixtures_directory = Project.new.fixtures_directory
      end

      def truncate_insert(repository, csv_name)
        repository.clear
        insert(repository, csv_name)
      end

      def insert_once(repository, csv_name)
        if repository.all.empty?
          insert(repository, csv_name)
        end
      end

      private

      def insert(repository, csv_name)
        csv_path = resolve_csv_path(csv_name)

        CSV.foreach(csv_path, @options) do |row|
          repository.create(Hanami::Utils::Hash.symbolize(row.to_hash))
        end
      end

      def resolve_csv_path(csv_name)
        Pathname.new(@fixtures_directory).join(csv_name)
      end
    end
  end
end