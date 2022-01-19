require 'spec_helper'

RSpec.describe Ata do
  describe Ata::Reference, vcr: 'ata/reference' do
    let(:reference) { Ata::Reference.new ata_id }
    let(:ata_id) { Ata.create(name: 'Test ATA').id }

    describe '#get' do
      it 'returns information about the referenced ATA' do
        result = reference.get
        expect(result).to be_a(Ata)
        expect(result.name).to eq('Test ATA')
      end
    end
  end

  describe Ata::ProvisioningURLs, vcr: 'ata/provisioning_urls' do
    let(:provisioning_urls) { Ata.provisioning_urls }

    describe '#urls' do
      it 'returns the full hash of provisioning URLS' do
        expect(provisioning_urls.urls).to be_a(Hash)
        expect(provisioning_urls.urls.keys).to match_array([
          'OBi',
          'Grandstream',
          'Netgen',
        ])
      end
    end

    describe '#grandstream' do
      it 'returns the grandstream provisioning URL' do
        url = provisioning_urls.urls['Grandstream']
        expect(provisioning_urls.grandstream).to eq(url)
      end
    end

    describe '#obi' do
      it 'returns the obi provisioning URL' do
        url = provisioning_urls.urls['OBi']
        expect(provisioning_urls.obi).to eq(url)
      end
    end

    describe '#netgen' do
      it 'returns the netgen provisioning url' do
        url = provisioning_urls.urls['Netgen']
        expect(provisioning_urls.netgen).to eq(url)
      end
    end
  end

  describe 'getting a list of ATAs', vcr: 'ata/list' do
    let(:action) { Ata.list params }
    let(:params) { {} }

    it 'sends the request to phaxio' do
      expect_api_request :get, 'atas', params
      action
    end

    it 'returns a collection of ATAs' do
      result = action
      expect(result).to be_a(Ata::Collection)
    end
  end

  describe 'creating an ATA', vcr: 'ata/create' do
    let(:action) { Ata.create params }
    let(:params) { {name: 'Test ATA'} }

    it 'sends the request to phaxio' do
      expect_api_request :post, 'atas', name: 'Test ATA'
      action
    end

    it 'returns information about the created ATA' do
      result = action
      expect(result).to be_a(Ata)
      expect(result.name).to eq('Test ATA')
    end
  end

  describe 'getting information about an ATA', vcr: 'ata/get' do
    let(:action) { Ata.get ata_id, params }
    let(:ata_id) { Ata.create(name: 'Test ATA').id }
    let(:params) { {} }

    it 'sends the request to phaxio' do
      expect_api_request :get, "atas/#{ata_id}", params
      action
    end

    it 'returns information about the ATA' do
      result = action
      expect(result).to be_a(Ata)
      expect(result.name).to eq('Test ATA')
    end
  end

  describe 'updating an ATA', vcr: 'ata/update' do
    let(:action) { Ata.update ata_id, params }
    let(:ata_id) { Ata.create(name: 'Test ATA').id }
    let(:params) { {name: 'New Name'} }

    it 'sends the request to phaxio' do
      expect_api_request :patch, "atas/#{ata_id}", params
      action
    end

    it 'returns information about the updated ATA' do
      result = action
      expect(result).to be_a(Ata)
      expect(result.name).to eq('New Name')
    end
  end

  describe 'regenerating ATA credentials', vcr: 'ata/regenerate' do
    let(:action) { Ata.regenerate_credentials ata_id, params }
    let(:ata) { Ata.create(name: 'Test ATA') }
    let(:ata_id) { ata.id }
    let(:params) { {} }

    it 'sends the request to phaxio' do
      expect_api_request :patch, "atas/#{ata_id}/regenerate_credentials", params
      action
    end

    it 'returns information about the ATA' do
      original_username = ata.username
      # some actions don't return full creds; creation does, but run a sanity check just in case
      expect(original_username).to_not be_nil
      result = action
      expect(result).to be_a(Ata)
      expect(result.username).to_not eq(original_username)
      expect(result.username).to_not be_nil
    end
  end

  describe 'deleting an ATA', vcr: 'ata/delete' do
    let(:action) { Ata.delete ata_id, params }
    let(:ata_id) { Ata.create(name: 'Test ATA').id }
    let(:params) { {} }

    it 'sends the request to phaxio' do
      expect_api_request :delete, "atas/#{ata_id}", params
      action
    end

    it 'returns a reference to the deleted ATA' do
      result = action
      expect(result).to be_a(Ata::Reference)
      expect(result.id).to eq(ata_id)
    end
  end

  describe 'adding a phone number to an ATA', vcr: 'ata/add_phone_number' do
    let(:action) { Ata.add_phone_number ata_id, TEST_NUMBER, params }
    let(:ata_id) { Ata.create(name: 'Test ATA').id }
    let(:params) { {} }

    it 'sends the request to phaxio' do
      expect_api_request :post, "atas/#{ata_id}/phone_numbers/#{TEST_NUMBER}", params
      action
    end

    it 'returns a reference to the added phone number' do
      result = action
      expect(result).to be_a(PhoneNumber::Reference)
    end
  end

  describe 'removing a phone number from an ATA', vcr: 'ata/remove_phone_number' do
    let(:action) { Ata.remove_phone_number ata_id, TEST_NUMBER, params }
    let(:ata_id) { Ata.create(name: 'Test ATA').id }
    let(:params) { {} }

    before do
      Ata.add_phone_number ata_id, TEST_NUMBER
    end

    it 'sends the request to phaxio' do
      expect_api_request :delete, "atas/#{ata_id}/phone_numbers/#{TEST_NUMBER}", params
      action
    end

    it 'returns a reference to the removed phone number' do
      result = action
      expect(result).to be_a(PhoneNumber::Reference)
    end
  end

  describe 'listing provisioning URLs for an ATA', vcr: 'ata/provisioning_urls' do
    let(:action) { Ata.provisioning_urls params }
    let(:params) { {} }

    it 'sends the request to phaxio' do
      expect_api_request :get, "atas/provisioning_urls", params
      action
    end

    it 'returns a set of provisioning URLs' do
      response = action
      expect(response).to be_a(Ata::ProvisioningURLs)
    end
  end
end
