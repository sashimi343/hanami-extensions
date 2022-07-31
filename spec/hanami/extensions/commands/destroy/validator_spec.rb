# frozen_string_literal: true
require "hanami/extensions/project"
require "hanami/extensions/commands/destroy/validator"

RSpec.describe Hanami::Extensions::Commands::Destroy::Validator do
  let(:options) { { test: test_framework } }
  let(:environment) { double("environment", root: Pathname.new("/path/to/test_project"), project_name: "test_project", to_options: options) }
  let(:project) { Hanami::Extensions::Project.new(environment: environment) }
  let(:files) { spy("Hanami::Utils::Files") }
  let(:out) { spy("stdout") }
  let(:validator) { described_class.new(out: out, files: files, project: project) }

  describe "#call" do
    context "when the test framework is rspec" do
      let(:test_framework) { "rspec" }
      let(:validator_name) { "Users/UpdateProfile" }

      it "deletes validator files" do
        validator.call(validator: validator_name)
        expect(files).to have_received(:delete).with(
          Pathname.new("/path/to/test_project/lib/test_project/validators/users/update_profile_validator.rb")
        )
      end

      it "deletes rspec spec files of an validator" do
        validator.call(validator: validator_name)
        expect(files).to have_received(:delete).with(
          Pathname.new("/path/to/test_project/spec/test_project/validators/users/update_profile_validator_spec.rb")
        )
      end

      it "displays the message that deletes the validator file and its spec file" do
        validator.call(validator: validator_name)
        expect(out).to have_received(:puts).with(%r{remove.*/path/to/test_project/lib/test_project/validators/users/update_profile_validator.rb})
        expect(out).to have_received(:puts).with(%r{remove.*/path/to/test_project/spec/test_project/validators/users/update_profile_validator_spec.rb})
      end
    end

    context "when the test framework is minitest" do
      let(:test_framework) { "minitest" }
      let(:validator_name) { "add_book" }

      it "deletes validator files" do
        validator.call(validator: validator_name)
        expect(files).to have_received(:delete).with(
          Pathname.new("/path/to/test_project/lib/test_project/validators/add_book_validator.rb")
        )
      end

      it "deletes minitest spec files of an validator" do
        validator.call(validator: validator_name)
        expect(files).to have_received(:delete).with(
          Pathname.new("/path/to/test_project/spec/test_project/validators/add_book_validator_spec.rb")
        )
      end

      it "displays the message that deletes the validator file and its spec file" do
        validator.call(validator: validator_name)
        expect(out).to have_received(:puts).with(%r{remove.*/path/to/test_project/lib/test_project/validators/add_book_validator.rb})
        expect(out).to have_received(:puts).with(%r{remove.*/path/to/test_project/spec/test_project/validators/add_book_validator_spec.rb})
      end
    end
  end
end