# frozen_string_literal: true
require "hanami/utils"
require "hanami/extensions/project"
require "hanami/extensions/string_util"

module Hanami
  module Extensions
    module Commands
      module Destroy
        class Validator < Hanami::CLI::Commands::Command
          using Hanami::Extensions::StringUtil

          desc "Destroy a validator"
          argument :validator, required: true, desc: "The validator name"
          example [
            "user # Will destroy UserValidator and its spec file",
            "books/create # Will destroy Books::CreateValidator and its spec file",
          ]

          def initialize(out: $stdout, files: Hanami::Utils::Files, project: Project.new)
            super(out: out, files: files)
            @project = project
          end

          def call(validator:, **options)
            class_full_name = validator.modulize + "Validator"

            destroy_validator(class_full_name)
            destroy_validator_spec(class_full_name)
          end

          private

          def destroy_validator(class_full_name)
            path = @project.validator_path(class_full_name)

            @files.delete(path)
            say(:remove, path)
          end

          def destroy_validator_spec(class_full_name)
            path = @project.validator_spec_path(class_full_name)

            @files.delete(path)
            say(:remove, path)
          end
        end
      end
    end
  end
end