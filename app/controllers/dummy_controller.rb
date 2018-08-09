class DummyController < ApplicationController
  def index
    @dummy = Dummy.new(name: 'Dummy')
    authorize @dummy
  end
end