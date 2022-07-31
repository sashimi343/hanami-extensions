# frozen_string_literal: true
require "hanami/extensions/project"
require "hanami/extensions/commands/destroy/interactor"

RSpec.describe Hanami::Extensions::Commands::Destroy::Interactor do
  let(:options) { { test: test_framework } }
  let(:environment) { double("environment", root: Pathname.new("/path/to/test_project"), project_name: "test_project", to_options: options) }
  let(:project) { Hanami::Extensions::Project.new(environment: environment) }
  let(:files) { spy("Hanami::Utils::Files") }
  let(:out) { spy("stdout") }
  let(:interactor) { described_class.new(out: out, files: files, project: project) }

  describe "#call" do
    context "when the test framework is rspec" do
      let(:test_framework) { "rspec" }
      let(:interactor_name) { "Users/UpdateProfile" }

      it "deletes interactor files" do
        interactor.call(interactor: interactor_name)
        expect(files).to have_received(:delete).with(
          Pathname.new("/path/to/test_project/lib/test_project/interactors/users/update_profile_interactor.rb")
        )
      end

      it "deletes rspec spec files of an interactor" do
        interactor.call(interactor: interactor_name)
        expect(files).to have_received(:delete).with(
          Pathname.new("/path/to/test_project/spec/test_project/interactors/users/update_profile_interactor_spec.rb")
        )
      end

      it "displays the message that deletes the interactor file and its spec file" do
        interactor.call(interactor: interactor_name)
        expect(out).to have_received(:puts).with(%r{remove.*/path/to/test_project/lib/test_project/interactors/users/update_profile_interactor.rb})
        expect(out).to have_received(:puts).with(%r{remove.*/path/to/test_project/spec/test_project/interactors/users/update_profile_interactor_spec.rb})
      end
    end

    context "when the test framework is minitest" do
      let(:test_framework) { "minitest" }
      let(:interactor_name) { "add_book" }

      it "deletes interactor files" do
        interactor.call(interactor: interactor_name)
        expect(files).to have_received(:delete).with(
          Pathname.new("/path/to/test_project/lib/test_project/interactors/add_book_interactor.rb")
        )
      end

      it "deletes minitest spec files of an interactor" do
        interactor.call(interactor: interactor_name)
        expect(files).to have_received(:delete).with(
          Pathname.new("/path/to/test_project/spec/test_project/interactors/add_book_interactor_spec.rb")
        )
      end

      it "displays the message that deletes the interactor file and its spec file" do
        interactor.call(interactor: interactor_name)
        expect(out).to have_received(:puts).with(%r{remove.*/path/to/test_project/lib/test_project/interactors/add_book_interactor.rb})
        expect(out).to have_received(:puts).with(%r{remove.*/path/to/test_project/spec/test_project/interactors/add_book_interactor_spec.rb})
      end
    end
  end
end