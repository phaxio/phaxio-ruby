require 'spec_helper'

describe MimeTypeHelper do
  it 'gets the mimetype for a filename' do
    expect(MimeTypeHelper.mimetype_for_file('test.pdf')).to eq('application/pdf')
  end

  it 'gets the extension for a mimetype' do
    expect(MimeTypeHelper.extension_for_mimetype('application/pdf')).to eq('pdf')
  end
end
