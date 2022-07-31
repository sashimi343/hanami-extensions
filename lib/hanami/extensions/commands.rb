# frozen_string_literal: true
require "hanami/cli/commands"

module Hanami
  module Extensions
    module Commands
      require_relative "./commands/generate/interactor"
      require_relative "./commands/generate/validator"

      require_relative "./commands/destroy/interactor"
      require_relative "./commands/destroy/validator"

      require_relative "./commands/db/seed"
    end
  end
end

Hanami::CLI::Commands.register "generate", aliases: ["g"] do |prefix|
  prefix.register "interactor", Hanami::Extensions::Commands::Generate::Interactor
  prefix.register "validator", Hanami::Extensions::Commands::Generate::Validator
end

Hanami::CLI::Commands.register "destroy", aliases: ["d"] do |prefix|
  prefix.register "interactor", Hanami::Extensions::Commands::Destroy::Interactor
  prefix.register "validator", Hanami::Extensions::Commands::Destroy::Validator
end

Hanami::CLI::Commands.register "db" do |prefix|
  prefix.register "seed", Hanami::Extensions::Commands::Db::Seed
end