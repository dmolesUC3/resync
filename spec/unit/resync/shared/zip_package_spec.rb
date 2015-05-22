require 'spec_helper'
require 'resync/shared/zip_package'

module Resync
  describe ZipPackage do
    describe '#new' do
      it 'accepts a path to a ZIP file' do
        path = 'spec/data/resourcedump/resourcedump.zip'
        pkg = ZipPackage.new(zipfile: path)
        zipfile = pkg.zipfile
        expect(zipfile).to be_a(Zip::File)
        expect(zipfile.name).to eq(path)
      end

      it 'accepts a Zip::File object' do
        zipfile = Zip::File.open('spec/data/resourcedump/resourcedump.zip')
        pkg = ZipPackage.new(zipfile: zipfile)
        expect(pkg.zipfile).to eq(zipfile)
      end

      it 'extracts a manifest' do
        pkg = ZipPackage.new(zipfile: 'spec/data/resourcedump/resourcedump.zip')
        manifest = pkg.manifest
        expect(manifest).to be_a(ResourceDumpManifest)
      end

      it 'extracts entries' do
        pkg = ZipPackage.new(zipfile: 'spec/data/resourcedump/resourcedump.zip')
        bitstreams = pkg.bitstreams
        expect(bitstreams.size).to eq(2)

        bs0 = bitstreams[0]
        expect(bs0.path).to eq('resources/res1')
        expect(bs0.size).to eq(446)
        expect(bs0.content).to eq(File.read('spec/data/resourcedump/resources/res1'))

        bs1 = bitstreams[1]
        expect(bs1.path).to eq('resources/res2')
        expect(bs1.size).to eq(447)
        expect(bs1.content).to eq(File.read('spec/data/resourcedump/resources/res2'))
      end
    end
  end
end
