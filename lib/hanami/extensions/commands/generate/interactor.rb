# frozen_string_literal: true
require "hanami/utils"
require "hanami/extensions/project"
require "hanami/extensions/string_util"

module Hanami
  module Extensions
    module Commands
      module Generate
        class Interactor < Hanami::CLI::Commands::Command
          using Hanami::Extensions::StringUtil

          TEMPLTES_DIRECTORY = "interactor"
          SPEC_HELPER = "spec_helper.rb"
          GOTO_PARENT_DIRECTORY = "../"

          desc "Generate an interactor"
          argument :interactor, required: true, desc: "The interactor name"
          option :with_validation, type: :boolean, default: false, desc: "Generate interactor class with validation"
          example [
            "add_book # Will generate AddBookInteractor and its spec file",
            "users/register # Will generate Users::RegisterInteractor and its spec file",
          ]

          def initialize(out: $stdout, files: Hanami::Utils::Files, project: Project.new)
            super(out: out, files: files)
            @project = project
          end

          def call(interactor:, **options)
            class_full_name = interactor.modulize + "Interactor"
            module_names = class_full_name.modules
            class_name = class_full_name.class_name
            context = Hanami::CLI::Commands::Context.new(
              class_full_name: class_full_name,
              module_names: module_names,
              class_name: class_name,
              spec_helper: spec_helper_path(class_full_name),
            )

            generate_interactor(context, options.fetch(:with_validation))
            generate_interactor_spec(context)
          end

          private

          def generate_interactor(context, with_validation)
            source = with_validation ? template("interactor_with_validation.erb") : template("interactor.erb")
            destination = @project.interactor_path(context.class_full_name)

            generate_file(source ,destination, context)
            say(:create, destination)
          end

          def generate_interactor_spec(context)
            source = template("interactor_spec.#{@project.test_framework}.erb")
            destination = @project.interactor_spec_path(context.class_full_name)

            generate_file(source ,destination, context)
            say(:create, destination)
          end

          def template(name)
            Pathname.new(__dir__).join(TEMPLTES_DIRECTORY, name)
          end

          def spec_helper_path(class_full_name)
            depth_of_interactor = class_full_name.scan("::").length
            GOTO_PARENT_DIRECTORY * (depth_of_interactor + 2) + SPEC_HELPER
          end
        end
      end
    end
  end
end