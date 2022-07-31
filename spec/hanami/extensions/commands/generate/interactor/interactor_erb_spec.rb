# frozen_string_literal: true
require "hanami/utils"

RSpec.describe "interactor.erb" do
  let(:erb_file_path) { Pathname.new(__dir__).join("../../../../../../lib/hanami/extensions/commands/generate/interactor/interactor.erb") }
  let(:erb) { ERB.new(File.read(erb_file_path), trim_mode: "-") }
  let(:generated_code) { erb.result_with_hash(params) }

  context "when class name without module name is given" do
    let(:params) { { class_full_name: "AddBookInteractor", module_names: [], class_name: "AddBookInteractor", spec_helper: "../../spec_helper.rb" } }

    it "defines AddBookInteractor class" do
      eval(generated_code)
      expect(Object.const_defined?("AddBookInteractor")).to be_truthy
    end
  end

  context "when class name with single module is given" do
    let(:params) { { class_full_name: "User::RegisterInteractor", module_names: ["User"], class_name: "RegisterInteractor", spec_helper: "../../../spec_helper.rb" } }

    it "defines interactor class" do
      eval(generated_code)
      expect(Object.const_defined?("User::RegisterInteractor")).to be_truthy
    end
  end

  context "when class name with nested module is given" do
    let(:params) { { class_full_name: "Hoge::Piyo::FooBarInteractor", module_names: ["Hoge", "Piyo"], class_name: "FooBarInteractor", spec_helper: "../../../../spec_helper.rb" } }

    it "defines interactor class" do
      eval(generated_code)
      expect(Object.const_defined?("Hoge::Piyo::FooBarInteractor")).to be_truthy
    end
  end
end