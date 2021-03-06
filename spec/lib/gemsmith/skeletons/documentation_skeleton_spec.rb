# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::Skeletons::DocumentationSkeleton, :temp_dir do
  let(:cli) { instance_spy Gemsmith::CLI, destination_root: temp_dir }
  let(:configuration) { instance_spy Gemsmith::Configuration, gem_name: "tester" }
  let(:gem_dir) { File.join temp_dir, configuration.gem_name }
  subject { described_class.new cli, configuration: configuration }
  before { FileUtils.mkdir gem_dir }

  describe "#create_files" do
    before { subject.create_files }

    it "creates readme" do
      expect(cli).to have_received(:template).with("%gem_name%/README.md.tt", configuration.to_h)
    end

    it "creates contributing guidelines" do
      expect(cli).to have_received(:template).with("%gem_name%/CONTRIBUTING.md.tt", configuration.to_h)
    end

    it "creates code of conduct" do
      expect(cli).to have_received(:template).with("%gem_name%/CODE_OF_CONDUCT.md.tt", configuration.to_h)
    end

    it "creates software license" do
      expect(cli).to have_received(:template).with("%gem_name%/LICENSE.md.tt", configuration.to_h)
    end

    it "creates change log" do
      expect(cli).to have_received(:template).with("%gem_name%/CHANGELOG.md.tt", configuration.to_h)
    end
  end

  describe "#update_readme" do
    let(:tocer) { instance_spy Tocer::Writer }
    let(:file) { File.join cli.destination_root, cli.gem_name, "README.md" }
    before do
      allow(Tocer::Writer).to receive(:new).and_return(tocer)
      subject.update_readme
    end

    it "updates readme" do
      expect(tocer).to have_received(:write)
    end
  end

  describe "#create" do
    before do
      allow(subject).to receive(:create_files)
      allow(subject).to receive(:update_readme)
    end

    it "creates files" do
      subject.create
      expect(subject).to have_received(:create_files)
    end

    it "creates updates readme" do
      subject.create
      expect(subject).to have_received(:update_readme)
    end
  end
end
