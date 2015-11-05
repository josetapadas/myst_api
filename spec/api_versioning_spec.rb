require 'spec_helper'

describe ApiConstraints do
  let!(:api_constraints) { ApiConstraints.new(version: 1) }
  let!(:api_constraints_default) { ApiConstraints.new(version: 1, default: true) }

  describe '#matches?' do
    it 'should return true when Accept header matches the version' do
      request = double(host: 'myst.test', headers: { 'Accept' => 'application/myst.1' })
      expect(api_constraints.matches?(request)).to be(true)
    end

    it 'should return false when Accept header matches wrong the version' do
      request = double(host: 'myst.test', headers: { 'Accept' => 'application/myst.lol' })
      expect(api_constraints.matches?(request)).to be(false)
    end

    it 'should return false when Accept header matches wrong the version' do
      request = double(host: 'myst.test')
      expect(api_constraints_default.matches?(request)).to be(true)
    end
  end
end
