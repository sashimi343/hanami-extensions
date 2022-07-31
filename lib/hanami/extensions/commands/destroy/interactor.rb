# frozen_string_literal: true
require "hanami/utils"
require "hanami/extensions/project"
require "hanami/extensions/string_util"

module Hanami
  module Extensions
    module Commands
      module Destroy
        class Interactor < Hanami::CLI::Commands::Command
          using Hanami::Extensions::StringUtil

          desc "Destroy an interactor"
          argument :interactor, required: true, desc: "The interactor name"
          example [
            "add_book # Will destroy AddBookInteractor and its spec file",
            "users/register # Will destroy Users::RegisterInteractor and its spec file",
          ]

          def initialize(out: $stdout, files: Hanami::Utils::Files, project: Project.new)
            super(out: out, files: files)
            @project = project
          end

          def call(interactor:, **options)
            class_full_name = interactor.modulize + "Interactor"

            destroy_interactor(class_full_name)
            destroy_interactor_spec(class_full_name)
          end

          private

          def destroy_interactor(class_full_name)
            path = @project.interactor_path(class_full_name)

            @files.delete(path)
            say(:remove, path)
          end

          def destroy_interactor_spec(class_full_name)
            path = @project.interactor_spec_path(class_full_name)

            @files.delete(path)
            say(:remove, path)
          end
        end
      end
    end
  end
end