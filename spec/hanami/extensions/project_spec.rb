# frozen_string_literal: true
require "hanami/extensions/project"

RSpec.describe Hanami::Extensions::Project do
  let(:root) { Pathname.new("/path/to/test_project") }
  let(:project_name) { "test_project" }
  let(:test_framework) { "rspec" }
  let(:options) { { test: test_framework } }
  let(:environment) { double("environment", root: root, project_name: project_name, to_options: options) }
  let(:project) { described_class.new(environment: environment) }

  describe "#test_framework" do
    subject { project.test_framework }

    it "returns test framework name that defined in Hanami::Environment" do
      is_expected.to eq test_framework
    end
  end

  describe "#interactor_path" do
    subject { project.interactor_path(class_full_name) }

    context "when class name without module name is given" do
      let(:class_full_name) { "AddBook" }

      it "returns Pathname instance" do
        is_expected.to be_an_instance_of Pathname
      end

      it "returns absolute path of interactor file" do
        is_expected.to eq Pathname.new("/path/to/test_project/lib/test_project/interactors/add_book.rb")
      end
    end

    context "when class name with module name is given" do
      let(:class_full_name) { "Admin::UserManagement::UserProfile" }

      it "returns Pathname instance" do
        is_expected.to be_an_instance_of Pathname
      end

      it "returns absolute path of interactor file" do
        is_expected.to eq Pathname.new("/path/to/test_project/lib/test_project/interactors/admin/user_management/user_profile.rb")
      end
    end
  end

  describe "#interactor_spec_path" do
    subject { project.interactor_spec_path(class_full_name) }

    context "when class name without module name is given" do
      let(:class_full_name) { "AddBook" }

      it "returns Pathname instance" do
        is_expected.to be_an_instance_of Pathname
      end

      it "returns absolute path of interactor_spec file" do
        is_expected.to eq Pathname.new("/path/to/test_project/spec/test_project/interactors/add_book_spec.rb")
      end
    end

    context "when class name with module name is given" do
      let(:class_full_name) { "Admin::UserManagement::UserProfile" }

      it "returns Pathname instance" do
        is_expected.to be_an_instance_of Pathname
      end

      it "returns absolute path of interactor_spec file" do
        is_expected.to eq Pathname.new("/path/to/test_project/spec/test_project/interactors/admin/user_management/user_profile_spec.rb")
      end
    end
  end
end