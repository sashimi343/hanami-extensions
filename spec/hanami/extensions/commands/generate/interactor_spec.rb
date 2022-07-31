# frozen_string_literal: true
require "hanami/extensions/project"
require "hanami/extensions/commands/generate/interactor"

RSpec.describe Hanami::Extensions::Commands::Generate::Interactor do
  let(:options) { { test: test_framework } }
  let(:environment) { double("environment", root: Pathname.new("/path/to/test_project"), project_name: "test_project", to_options: options) }
  let(:project) { Hanami::Extensions::Project.new(environment: environment) }
  let(:files) { spy("Hanami::Utils::Files") }
  let(:out) { spy("stdout") }
  let(:interactor) { described_class.new(out: out, files: files, project: project) }

  describe "#call" do
    let(:params) { { interactor: interactor_name, with_validation: with_validation } }

    context "when the test framework is rspec" do
      let(:test_framework) { "rspec" }
      let(:interactor_name) { "Users/UpdateProfile" }
      let(:with_validation) { false }

      it "creates interactor files" do
        interactor.call(params)
        expect(files).to have_received(:write).with(
          Pathname.new("/path/to/test_project/lib/test_project/interactors/users/update_profile_interactor.rb"),
          /module Users.*class UpdateProfileInteractor.*include Hanami::Interactor/m
        )
      end

      it "creates interactor class without validation logic" do
        interactor.call(params)
        expect(files).to_not have_received(:write).with(
          Pathname.new("/path/to/test_project/lib/test_project/interactors/administrator/code_masters/list_all_interactor.rb"),
          /require "hanami\/validations".*include Hanami::Validations/m
        )
      end

      it "creates rspec spec files of an interactor" do
        interactor.call(params)
        expect(files).to have_received(:write).with(
          Pathname.new("/path/to/test_project/spec/test_project/interactors/users/update_profile_interactor_spec.rb"),
          /RSpec.describe Users::UpdateProfileInteractor, type: :interactor do/
        )
      end

      it "displays the message that creates the interactor file and its spec file" do
        interactor.call(params)
        expect(out).to have_received(:puts).with(%r{create.*/path/to/test_project/lib/test_project/interactors/users/update_profile_interactor.rb})
        expect(out).to have_received(:puts).with(%r{create.*/path/to/test_project/spec/test_project/interactors/users/update_profile_interactor_spec.rb})
      end
    end

    context "when the test framework is minitest" do
      let(:test_framework) { "minitest" }
      let(:interactor_name) { "add_book" }
      let(:with_validation) { false }

      it "creates interactor files" do
        interactor.call(params)
        expect(files).to have_received(:write).with(
          Pathname.new("/path/to/test_project/lib/test_project/interactors/add_book_interactor.rb"),
          /class AddBookInteractor.*include Hanami::Interactor/m
        )
      end

      it "creates interactor class without validation logic" do
        interactor.call(params)
        expect(files).to_not have_received(:write).with(
          Pathname.new("/path/to/test_project/lib/test_project/interactors/administrator/code_masters/list_all_interactor.rb"),
          /require "hanami\/validations".*include Hanami::Validations/m
        )
      end

      it "creates minitest spec files of an interactor" do
        interactor.call(params)
        expect(files).to have_received(:write).with(
          Pathname.new("/path/to/test_project/spec/test_project/interactors/add_book_interactor_spec.rb"),
          /^describe AddBookInteractor do/
        )
      end

      it "displays the message that creates the interactor file and its spec file" do
        interactor.call(params)
        expect(out).to have_received(:puts).with(%r{create.*/path/to/test_project/lib/test_project/interactors/add_book_interactor.rb})
        expect(out).to have_received(:puts).with(%r{create.*/path/to/test_project/spec/test_project/interactors/add_book_interactor_spec.rb})
      end
    end

    context "when --with-validation option is specified" do
      let(:test_framework) { "rspec" }
      let(:interactor_name) { "Administrator#CodeMasters#ListAll" }
      let(:with_validation) { true }

      it "creates interactor files" do
        interactor.call(params)
        expect(files).to have_received(:write).with(
          Pathname.new("/path/to/test_project/lib/test_project/interactors/administrator/code_masters/list_all_interactor.rb"),
          /module Administrator.*module CodeMasters.*class ListAllInteractor.*/m
        )
      end

      it "creates interactor class with validation logic" do
        interactor.call(params)
        expect(files).to have_received(:write).with(
          Pathname.new("/path/to/test_project/lib/test_project/interactors/administrator/code_masters/list_all_interactor.rb"),
          /require "hanami\/validations".*include Hanami::Validations/m
        )
      end

      it "creates rspec spec files of an interactor" do
        interactor.call(params)
        expect(files).to have_received(:write).with(
          Pathname.new("/path/to/test_project/spec/test_project/interactors/administrator/code_masters/list_all_interactor_spec.rb"),
          /RSpec.describe Administrator::CodeMasters::ListAllInteractor, type: :interactor do/
        )
      end

      it "displays the message that creates the interactor file and its spec file" do
        interactor.call(params)
        expect(out).to have_received(:puts).with(%r{create.*/path/to/test_project/lib/test_project/interactors/administrator/code_masters/list_all_interactor.rb})
        expect(out).to have_received(:puts).with(%r{create.*/path/to/test_project/spec/test_project/interactors/administrator/code_masters/list_all_interactor_spec.rb})
      end
    end
  end
end