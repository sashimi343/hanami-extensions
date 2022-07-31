# frozen_string_literal: true
require "hanami/extensions/string_util"

RSpec.describe Hanami::Extensions::StringUtil do
  using Hanami::Extensions::StringUtil
  
  describe "#underscore" do
    subject { input.underscore }

    context "when a snake case string is given" do
      let(:input) { "snake_case" }

      it "returns input string" do
        is_expected.to eq input
      end
    end

    context "when a camel case string is given" do
      let(:input) { "CamelCasedString"}

      it "returns snake cased string" do
        is_expected.to eq "camel_cased_string"
      end
    end

    context "when mixed case string is given" do
      let(:input) { "MixedCase_String" }

      it "returns snake cased string" do
        is_expected.to eq "mixed_case_string"
      end
    end
  end

  describe "#camelize" do
    subject { input.camelize }

    context "when a camel case string is given" do
      let(:input) { "CamelCasedString" }

      it "returns input string" do
        is_expected.to eq input
      end
    end

    context "when a snake case string is given" do
      let(:input) { "snake_case_string" }

      it "returns camel cased string" do
        is_expected.to eq "SnakeCaseString"
      end
    end

    context "when a mixed case string is given" do
      let(:input) { "MixedCase_string_Given" }

      it "returns camel cased string" do
        is_expected.to eq "MixedCaseStringGiven"
      end
    end
  end

  describe "#modulize" do
    subject { input.modulize }

    context "when '/' separated string is given" do
      let(:input) { "admin_interactors/user/edit_profile" }

      it "returns class full name (with module name)" do
        is_expected.to eq "AdminInteractors::User::EditProfile"
      end
    end

    context "when '#' separated string is given" do
      let(:input) { "ExampleModule#AddTestClass" }

      it "returns class full name (with module name)" do
        is_expected.to eq "ExampleModule::AddTestClass"
      end
    end

    context "when none of separator is appeared" do
      let(:input) { "add_book" }

      it "returns classified (camel cased) string" do 
        is_expected.to eq "AddBook"
      end
    end
  end

  describe "#class_name" do
    subject { input.class_name }

    context "when class name without module name is given" do
      let(:input) { "ExampleClass" }

      it "returns input string" do
        is_expected.to eq input
      end
    end

    context "when class name with module name is given" do
      let(:input) { "Admin::UserManagement::UserProfile" }

      it "returns class name without module name" do
        is_expected.to eq "UserProfile"
      end
    end
  end
  
  describe "#modules" do
    subject { input.modules }

    context "when class name without module is given" do
      let(:input) { "ExampleClass" }

      it "returns empty array" do
        is_expected.to be_instance_of Array
        is_expected.to be_empty
      end
    end

    context "when 'Module::Class' string is given" do
      let(:input) { "TestModule::ExampleClass" }

      it "returns array of module names" do
        is_expected.to be_instance_of Array
        is_expected.to match ["TestModule"]
      end
    end

    context "when class name defined under nested modules is given" do
      let(:input) { "TestModule::Administrators::ExampleClass" }

      it "returns array of module names" do
        is_expected.to be_instance_of Array
        is_expected.to match ["TestModule", "Administrators"]
      end
    end
  end
end