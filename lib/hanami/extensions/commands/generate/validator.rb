# frozen_string_literal: true
require "hanami/utils"
require "hanami/extensions/project"
require "hanami/extensions/string_util"

module Hanami
  module Extensions
    module Commands
      module Generate
        class Validator < Hanami::CLI::Commands::Command
          using Hanami::Extensions::StringUtil

          TEMPLTES_DIRECTORY = "validator"
          SPEC_HELPER = "spec_helper.rb"
          GOTO_PARENT_DIRECTORY = "../"

          desc "Generate a validator"
          argument :validator, required: true, desc: "The validator name"
          example [
            "user # Will generate UserValidator and its spec file",
            "books/create # Will generate Books::CreateValidator and its spec file",
          ]

          def initialize(out: $stdout, files: Hanami::Utils::Files, project: Project.new)
            super(out: out, files: files)
            @project = project
          end

          def call(validator:, **options)
            class_full_name = validator.modulize + "Validator"
            module_names = class_full_name.modules
            class_name = class_full_name.class_name
            context = Hanami::CLI::Commands::Context.new(
              class_full_name: class_full_name,
              module_names: module_names,
              class_name: class_name,
              spec_helper: spec_helper_path(class_full_name),
            )

            generate_validator(context)
            generate_validator_spec(context)
          end

          private

          def generate_validator(context)
            source = template("validator.erb")
            destination = @project.validator_path(context.class_full_name)

            generate_file(source ,destination, context)
            say(:create, destination)
          end

          def generate_validator_spec(context)
            source = template("validator_spec.#{@project.test_framework}.erb")
            destination = @project.validator_spec_path(context.class_full_name)

            generate_file(source ,destination, context)
            say(:create, destination)
          end

          def template(name)
            Pathname.new(__dir__).join(TEMPLTES_DIRECTORY, name)
          end

          def spec_helper_path(class_full_name)
            depth_of_validator = class_full_name.scan("::").length
            GOTO_PARENT_DIRECTORY * (depth_of_validator + 3) + SPEC_HELPER
          end
        end
      end
    end
  end
end