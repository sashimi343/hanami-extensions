# fronze_string_literal: true
require "hanami/utils"
require "hanami/extensions/project"

module Hanami
  module Extensions
    module Commands
      module Db
        class Seed < Hanami::CLI::Commands::Command
          desc "Load the seed data from db/seeds.rb"
          option :init, type: :boolean, default: false, desc: "Initialize db/seed.rb and db/fixtures directory"

          def initialize(out: $stdout, files: Hanami::Utils::Files, project: Project.new)
            super(out: out, files: files)
            @project = project
          end

          def call(**options)
            if options.fetch(:init)
              initialize_seed_files()
            else
              load_seed()
            end
          end

          private

          def initialize_seed_files()
            generate_seed_file()
            generate_fixtures_directory()
          end

          def load_seed()
            unless initialized?()
              @out.puts "ERROR: db/seed.rb file is not initialized."
              @out.puts "Please run the `db seed --init` command first."
              return
            end

            load @project.seed_path()
          end

          def initialized?()
            File.exist?(@project.seed_path())
          end

          def generate_seed_file()
            source = seed_template_path()
            destination = @project.seed_path()
            context = Hanami::CLI::Commands::Context.new({})

            generate_file(source, destination, context)
            say(:create, destination)
          end

          def generate_fixtures_directory()
            destination = @project.fixtures_directory()
            unless Dir.exist?(destination)
              Dir.mkdir(destination)
              say(:create, destination)
            end
          end

          def seed_template_path()
            Pathname.new(__dir__).join("seed", "seed.erb")
          end
        end
      end
    end
  end
end

