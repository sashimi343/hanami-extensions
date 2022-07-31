# frozen_string_literal: true
require "hanami/utils"

RSpec.describe "validator.erb" do
  let(:erb_file_path) { Pathname.new(__dir__).join("../../../../../../lib/hanami/extensions/commands/generate/validator/validator.erb") }
  let(:erb) { ERB.new(File.read(erb_file_path), trim_mode: "-") }
  let(:generated_code) { erb.result_with_hash(params) }

  context "when class name without module name is given" do
    let(:params) { { class_full_name: "AddBookValidator", module_names: [], class_name: "AddBookValidator", spec_helper: "../../spec_helper.rb" } }

    it "defines AddBookValidator class" do
      eval(generated_code)
      expect(Object.const_defined?("AddBookValidator")).to be_truthy
    end
  end

  context "when class name with single module is given" do
    let(:params) { { class_full_name: "User::RegisterValidator", module_names: ["User"], class_name: "RegisterValidator", spec_helper: "../../../spec_helper.rb" } }

    it "defines validator class" do
      eval(generated_code)
      expect(Object.const_defined?("User::RegisterValidator")).to be_truthy
    end
  end

  context "when class name with nested module is given" do
    let(:params) { { class_full_name: "Hoge::Piyo::FooBarValidator", module_names: ["Hoge", "Piyo"], class_name: "FooBarValidator", spec_helper: "../../../../spec_helper.rb" } }

    it "defines validator class" do
      eval(generated_code)
      expect(Object.const_defined?("Hoge::Piyo::FooBarValidator")).to be_truthy
    end
  end
end
