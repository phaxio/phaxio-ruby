require 'spec_helper'

describe Phaxio::MimeTypeHelper do
  it 'gets the mimetype for a filename' do
    expect(subject.mimetype_for_file('test.pdf')).to eq('application/pdf')
  end

  it 'gets the extension for a mimetype' do
    expect(subject.extension_for_mimetype('application/pdf')).to eq('pdf')
  end
end
