# frozon_string_literal: true
require "hanami"
require_relative "./string_util"

module Hanami
  module Extensions
    class Project
      using Hanami::Extensions::StringUtil

      CORE_DIRECTORY = "lib"
      SPEC_DIRECTORY = "spec"
      DATABASE_DIRECTORY = "db"
      SEED_FILE_NAME = "seed.rb"

      INTERACTORS_DIRECTORY = "interactors"
      VALIDATORS_DIRECTORY = "validators"
      FIXTURES_DIRECTORY = "fixtures"

      MODULE_SEPARATOR = "::"
      DIRECTORY_SEPARATOR = "/"

      SOURCE_FILE_SUFFIX = ".rb"
      SPEC_FILE_SUFFIX = "_spec.rb"

      def initialize(environment: Hanami::Environment.new)
        @environment = environment
      end

      def seed_path()
        @environment.root.join(DATABASE_DIRECTORY, SEED_FILE_NAME)
      end

      def fixtures_directory()
        @environment.root.join(DATABASE_DIRECTORY, FIXTURES_DIRECTORY)
      end

      def interactor_path(class_full_name)
        sub_path = to_file_sub_path(class_full_name, SOURCE_FILE_SUFFIX)
        core_path.join(INTERACTORS_DIRECTORY, sub_path)
      end

      def validator_path(class_full_name)
        sub_path = to_file_sub_path(class_full_name, SOURCE_FILE_SUFFIX)
        core_path.join(VALIDATORS_DIRECTORY, sub_path)
      end
      
      def interactor_spec_path(class_full_name)
        sub_path = to_file_sub_path(class_full_name, SPEC_FILE_SUFFIX)
        spec_path.join(INTERACTORS_DIRECTORY, sub_path)
      end

      def validator_spec_path(class_full_name)
        sub_path = to_file_sub_path(class_full_name, SPEC_FILE_SUFFIX)
        spec_path.join(VALIDATORS_DIRECTORY, sub_path)
      end

      def test_framework()
        @environment.to_options[:test]
      end

      private

      def core_path()
        @environment.root.join(CORE_DIRECTORY, @environment.project_name)
      end

      def spec_path()
        @environment.root.join(SPEC_DIRECTORY, @environment.project_name)
      end

      def to_file_sub_path(class_full_name, suffix)
        class_full_name.split(MODULE_SEPARATOR).map(&:underscore).join(DIRECTORY_SEPARATOR) + suffix
      end
    end
  end
end